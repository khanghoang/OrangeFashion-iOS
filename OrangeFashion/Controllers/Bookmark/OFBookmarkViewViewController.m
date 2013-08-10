//
//  OFBookmarkViewViewController.m
//  OrangeFashion
//
//  Created by Khang on 21/7/13.
//  Copyright (c) 2013 Khang. All rights reserved.
//

#import "OFBookmarkViewViewController.h"
#import "OFBookmarkTableViewCell.h"
#import "OFProductDetailsViewController.h"
#import "OFBookmarkSectionHeader.h"
#import "OFPopupBookmark.h"
#import <objc/runtime.h>

@interface OFBookmarkViewViewController ()
<UITableViewDataSource,
UITableViewDelegate,
UIAlertViewDelegate,
OFBookmarkTableViewCellDelegate,
TVPickerViewDatasource,
TVPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView        * tableViewBookmarkedProducts;
@property (strong, nonatomic) NSMutableArray            * arrBookmarkedProducts;

@property (strong, nonatomic) NSArray                   * currentAvailableNumbers;

@end

@implementation OFBookmarkViewViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.currentAvailableNumbers = [[NSArray alloc] init];    
    self.title = @"Bookmark";
    self.arrBookmarkedProducts = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view from its nib.
    [self.tableViewBookmarkedProducts registerNib:[UINib nibWithNibName:@"OFBookmarkTableViewCell" bundle:nil] forCellReuseIdentifier:@"OFBookmarkTableViewCell"];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.arrBookmarkedProducts = [[OFProductManager sharedInstance] getBookmarkProducts];
    [self.tableViewBookmarkedProducts reloadData];
}

#pragma marks - TableView datasouce
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"OFBookmarkTableViewCell";
    OFBookmarkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell)
        cell = (OFBookmarkTableViewCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OFBookmarkTableViewCell"];
    
    cell.delegate = self;
    
    //TODO: something need to configed here
    NSNumber *productId = [[self.arrBookmarkedProducts objectAtIndex:indexPath.row] objectForKey:STORE_PRODUCT_ID];
    NSInteger number = [[[self.arrBookmarkedProducts objectAtIndex:indexPath.row] objectForKey:STORE_PRODUCT_NUMBER] intValue];
    OFProduct *product = [[OFProduct MR_findByAttribute:@"product_id" withValue:productId] lastObject];
    
    [cell configWithProduct:product andNumber:number];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrBookmarkedProducts.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [OFBookmarkTableViewCell getHeight];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    OFBookmarkSectionHeader *header = [[OFBookmarkSectionHeader alloc] init];
    [header changeNumberOfBookmarkProduct:[[OFProductManager sharedInstance] getBookmarkProducts].count];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [OFBookmarkSectionHeader getHeight];
}

#pragma mark - UITableview Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *productId = [[self.arrBookmarkedProducts objectAtIndex:indexPath.row] objectForKey:STORE_PRODUCT_ID];
    
    OFProduct *product = [[OFProductManager sharedInstance] productWithProductID:[productId integerValue]];
    
    if (!product)
        return;
    
    OFPopupBookmark *popup =[OFPopupBookmark initPopupWithTitle:product.name message:@"Dummy Message" dismissBlock:^(OFPopupBookmark *popupView) {
        DLog(@"Cancel");
    } comfirmBlock:^(OFPopupBookmark *popupView) {
        
        NSInteger selectedIndex = [popupView.numberPicker selectedIndex];
        NSNumber *value = [self.currentAvailableNumbers objectAtIndex:selectedIndex];
        
        [[OFProductManager sharedInstance] updateProductWithProductID:product.product_id withNumber:[value integerValue]];
        
        self.arrBookmarkedProducts = [[OFProductManager sharedInstance] getBookmarkProducts];
        [self.tableViewBookmarkedProducts reloadData];
        
    }];
    
    self.currentAvailableNumbers = @[@1, @2, @3];
    
    popup.numberPicker.delegate = self;
    popup.numberPicker.datasource = self;
    
    [popup show];
}

#pragma mark - OFBookmarkProduct delegate

- (void)onLongPress:(id)sender
{
    UIGestureRecognizer *recognizer = (UIGestureRecognizer*) sender[@"guesture"];
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {        
        NSNumber *productID = (NSNumber *)sender[@"productId"];
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Xoá sản phẩm" message:@"Bạn có chắc muốn xoá sản phẩm này khỏi danh sách ghi nhớ" delegate:self cancelButtonTitle:@"Huỷ" otherButtonTitles:@"Đồng ý", nil];
//        objc_setAssociatedObject(alertView, @"productID", productID, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//        [alertView show];
        
        OFProduct *product = [[OFProductManager sharedInstance] productWithProductID:[productID integerValue]];
        
        if (!product)
            return;
        
        OFPopupBookmark *popup =[OFPopupBookmark initPopupWithTitle:product.name message:@"Dummy Message" dismissBlock:nil];
        [popup show];
    }
}

#pragma mark - UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    NSNumber *producID = objc_getAssociatedObject(alertView, @"productID");
    if ([buttonTitle isEqualToString:@"Đồng ý"])
    {
        [[OFProductManager sharedInstance] removeBookmarkProductWithProductID:producID];
        self.arrBookmarkedProducts = [[OFProductManager sharedInstance] getBookmarkProducts];
        [self.tableViewBookmarkedProducts reloadData];
    }
}

#pragma mark - TVPickerView datasource

- (NSInteger)numberOfElementsInTVPickerViewView
{
    return self.currentAvailableNumbers.count;
}

-(NSString *)tvPickerView:(TVPickerView *)tvPickerView titleForIndex:(NSInteger)index
{
    return [NSString stringWithFormat:@"%@", [[self.currentAvailableNumbers objectAtIndex:index] stringValue]];
}

@end
