//
//  OFProductsViewController.m
//  OrangeFashion
//
//  Created by Khang on 5/4/13.
//  Copyright (c) 2013 Khang. All rights reserved.
//

#import "OFProductsViewController.h"
#import "OFProductsTableCell.h"
#import "OFProductDetailsViewController.h"
#import "IIViewDeckController.h"

@interface OFProductsViewController () <IIViewDeckControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *productsTableView;
@property (strong, nonatomic) NSMutableArray *productsArr;

@end

@implementation OFProductsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [SVProgressHUD showWithStatus:@"Đang tải sản phẩm" maskType:SVProgressHUDMaskTypeGradient];
    
    [OFProduct getProductsOnSuccess:^(NSInteger statusCode, id obj) {
        [SVProgressHUD dismiss];
        [self.productsArr setArray:(NSArray *)obj];
        [self.productsTableView reloadData];
        
    } failure:^(NSInteger statusCode, id obj) {
        //Handle when failure
        [SVProgressHUD showErrorWithStatus:@"Xin vui lòng kiểm tra kết nối mạng và thử lại"];
    }];
    
    [self.productsTableView reloadData];
}

- (NSMutableArray *)productsArr
{
    if (!_productsArr) {
        _productsArr = [[NSMutableArray alloc] init];
    }
    
    return _productsArr;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.productsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"Products Table Cell";
    OFProductsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell)
        cell = [[OFProductsTableCell alloc]init];
    
    // Configure the cell...
    OFProduct *product = [OFProduct productWithDictionary:[self.productsArr objectAtIndex:indexPath.row]];
    
    [cell customProductCellWithProduct:product];
    
    return cell;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"View Product Details" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"View Product Details"]) {
        OFProductDetailsViewController *desVC = (OFProductDetailsViewController *)[segue destinationViewController];
        
        int selectedRow = [self.tableView indexPathForSelectedRow].row;
        
        desVC.productID = [[self.productsArr objectAtIndex:selectedRow] objectForKey:@"MaSanPham"];
    }
}

- (void)viewDidUnload {
    [self setProductsTableView:nil];
    [super viewDidUnload];
}
@end
