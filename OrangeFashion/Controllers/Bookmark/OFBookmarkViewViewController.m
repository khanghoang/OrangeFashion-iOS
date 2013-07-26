//
//  OFBookmarkViewViewController.m
//  OrangeFashion
//
//  Created by Khang on 21/7/13.
//  Copyright (c) 2013 Khang. All rights reserved.
//

#import "OFBookmarkViewViewController.h"
#import "OFBookmarkTableCell.h"
#import "OFProductDetailsViewController.h"
#import <objc/runtime.h>

@interface OFBookmarkViewViewController ()
<UITableViewDataSource, UITableViewDelegate, OFBookmarkTableCellDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView        * tableViewBookmarkedProducts;
@property (strong, nonatomic) NSMutableArray            * arrBookmarkedProducts;

@end

@implementation OFBookmarkViewViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableViewBookmarkedProducts.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"SidebarMenuTableCellBg"] resizableImageWithStandardInsetsTop:0 right:0 bottom:0 left:0]];
    self.arrBookmarkedProducts = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view from its nib.
    [self.tableViewBookmarkedProducts registerNib:[UINib nibWithNibName:@"OFBookmarkTableCell" bundle:nil] forCellReuseIdentifier:@"OFBookmarkTableCell"];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.arrBookmarkedProducts = [OFProduct getBookmarkProducts];
    [self.tableViewBookmarkedProducts reloadData];
}

#pragma marks - TableView datasouce
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"OFBookmarkTableCell";
    OFBookmarkTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell)
        cell = (OFBookmarkTableCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OFBookmarkTableCell"];
    
    cell.delegate = self;
    
    //TODO: something need to configed here
    NSNumber *productId = [self.arrBookmarkedProducts objectAtIndex:indexPath.row];
    OFProduct *product = [[OFProduct MR_findByAttribute:@"product_id" withValue:productId] lastObject];
    NSDictionary *data = @{PRODUCT_NAME: product.name, PRODUCT_ID: product.product_id};
    [cell configWithData:data];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrBookmarkedProducts.count;
}

#pragma mark - UITableview Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *productId = [self.arrBookmarkedProducts objectAtIndex:indexPath.row];
    OFProductDetailsViewController *detailsVC = [[OFProductDetailsViewController alloc] init];
    detailsVC.productID = productId;
    
    OFNavigationViewController *centralNavVC = (OFNavigationViewController *) self.viewDeckController.centerController;
    [centralNavVC pushViewController:detailsVC animated:YES];
    
    [self.viewDeckController toggleRightView];
}

#pragma mark - OFBookmarkProduct delegate

- (void)onLongPress:(id)sender
{
    UIGestureRecognizer *recognizer = (UIGestureRecognizer*) sender[@"guesture"];
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {        
        NSNumber *productID = (NSNumber *)sender[@"productId"];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Xoá sản phẩm" message:@"Bạn có chắc muốn xoá sản phẩm này khỏi danh sách ghi nhớ" delegate:self cancelButtonTitle:@"Huỷ" otherButtonTitles:@"Đồng ý", nil];
        objc_setAssociatedObject(alertView, @"productID", productID, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [alertView show];
    }
}

#pragma mark - UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    NSNumber *producID = objc_getAssociatedObject(alertView, @"productID");
    if ([buttonTitle isEqualToString:@"Đồng ý"])
    {
        [OFProduct removeBookmarkProductWithProductID:producID];
        self.arrBookmarkedProducts = [OFProduct getBookmarkProducts];
        [self.tableViewBookmarkedProducts reloadData];
    }
}

@end
