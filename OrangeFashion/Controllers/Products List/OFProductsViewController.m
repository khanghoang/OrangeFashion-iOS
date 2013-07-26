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

@property (strong, nonatomic) NSMutableArray            * productsArr;

@end

@implementation OFProductsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    [self.tableProducts registerNib:[UINib nibWithNibName:@"OFProductsTableCell" bundle:nil] forCellReuseIdentifier:@"OFProductsTableCell"];
    self.productsArr = [[NSMutableArray alloc] init];
    
    [SVProgressHUD showWithStatus:@"Đang tải sản phẩm" maskType:SVProgressHUDMaskTypeGradient];

    if (self.category_id > 0) {
        [self fillUpTableProductWithCategoryID:self.category_id];
        self.category_id = 0;
        return;
    }
    
    [self fillUpTableProductWithAllProducts];
    
}

- (void)fillUpTableProductWithCategoryID:(NSInteger)categoryID
{
    [OFProduct getProductsWithCategoryID:categoryID onSuccess:^(NSInteger statusCode, id obj) {
        [SVProgressHUD dismiss];
        [self.productsArr setArray:(NSArray *)obj];
        [self.tableProducts reloadData];
    } failure:^(NSInteger statusCode, id obj) {
        //Handle when failure
        [SVProgressHUD showErrorWithStatus:@"Xin vui lòng kiểm tra kết nối mạng và thử lại"];
        NSMutableArray *arrProducts = [[OFProduct MR_findAll] mutableCopy];
        self.productsArr = arrProducts;
        [self.tableProducts reloadData];
        
    }];
}

- (void)fillUpTableProductWithAllProducts
{
    [OFProduct getProductsOnSuccess:^(NSInteger statusCode, id obj) {
        [SVProgressHUD dismiss];
        [self.productsArr setArray:(NSArray *)obj];
        [self.tableProducts reloadData];
        
    } failure:^(NSInteger statusCode, id obj) {
        //Handle when failure
        [SVProgressHUD showErrorWithStatus:@"Xin vui lòng kiểm tra kết nối mạng và thử lại"];        
        [self.tableProducts reloadData];
        
    }];
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
    NSString *CellIdentifier = @"OFProductsTableCell";
    OFProductsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell)
        cell = [[OFProductsTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
 
    // Configure the cell...
    if ([[self.productsArr objectAtIndex:indexPath.row] isKindOfClass:[OFProduct class]]) {
        [cell customProductCellWithProduct:[self.productsArr objectAtIndex:indexPath.row]];
        return cell;
    }
    
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
    OFProductDetailsViewController *desVC = [[OFProductDetailsViewController alloc] init];
    int selectedRow = [self.tableProducts indexPathForSelectedRow].row;
    
    if ([[self.productsArr objectAtIndex:selectedRow] isKindOfClass:[OFProduct class]]) {
        OFProduct *product = [self.productsArr objectAtIndex:selectedRow];
        desVC.productID = product.product_id;
    }else
    {
        desVC.productID = [[self.productsArr objectAtIndex:selectedRow] objectForKey:@"MaSanPham"];
    }
    
    OFNavigationViewController *centralNavVC = (OFNavigationViewController *) self.viewDeckController.centerController;
    [centralNavVC pushViewController:desVC animated:YES];

}

@end
