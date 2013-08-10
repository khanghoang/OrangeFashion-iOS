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

@interface OFProductsViewController ()
<UITableViewDataSource, UITableViewDelegate, IIViewDeckControllerDelegate, UISearchDisplayDelegate, UISearchBarDelegate>

@property (strong, nonatomic) NSMutableArray            * productsArr;
@property (assign, nonatomic) BOOL                        isSearching;
@property (strong, nonatomic) NSMutableArray            * filteredList;

@end

@implementation OFProductsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = DEFAULT_NAVIGATION_TITLE;    
    if (![self.lblTitle isEqualToString:@""]) {
        self.title = self.lblTitle;
    }
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    [self.tableProducts registerNib:[UINib nibWithNibName:@"OFProductsTableCell" bundle:nil] forCellReuseIdentifier:@"OFProductsTableCell"];
    self.productsArr = [[NSMutableArray alloc] init];
    
    self.isSearching = NO;
    self.filteredList = [[NSMutableArray alloc] init];
    
    [SVProgressHUD showWithStatus:@"Đang tải sản phẩm" maskType:SVProgressHUDMaskTypeGradient];
    
    [self.tableProducts addPullToRefreshWithActionHandler:^{
        if (self.category_id > 0) {
            [self fillUpTableProductWithCategoryID:self.category_id];            
            return;
        }
        
        [self fillUpTableProductWithAllProducts];
    }];
    
    if (self.category_id > 0) {
        [self fillUpTableProductWithCategoryID:self.category_id];
        return;
    }
    
    [self fillUpTableProductWithAllProducts];
}

- (void)fillUpTableProductWithCategoryID:(NSInteger)categoryID
{
    [[OFProductManager sharedInstance] getProductsWithCategoryID:categoryID onSuccess:^(NSInteger statusCode, id obj) {
        [SVProgressHUD dismiss];
        [self.productsArr setArray:(NSArray *)obj];
        [self.tableProducts reloadData];        
        [self.tableProducts.pullToRefreshView stopAnimating];
    } failure:^(NSInteger statusCode, id obj) {
        //Handle when failure
        [SVProgressHUD showErrorWithStatus:@"Xin vui lòng kiểm tra kết nối mạng và thử lại"];
        NSMutableArray *arrProducts = [[OFProduct MR_findAll] mutableCopy];
        self.productsArr = arrProducts;
        [self.tableProducts reloadData];
        [self.tableProducts.pullToRefreshView stopAnimating];
    }];
}

- (void)fillUpTableProductWithAllProducts
{
    [[OFProductManager sharedInstance] getProductsOnSuccess:^(NSInteger statusCode, id obj) {
        [SVProgressHUD dismiss];
        [self.productsArr setArray:(NSArray *)obj];
        [self.tableProducts reloadData];
        [self.tableProducts.pullToRefreshView stopAnimating];
        
    } failure:^(NSInteger statusCode, id obj) {
        //Handle when failure
        [SVProgressHUD showErrorWithStatus:@"Xin vui lòng kiểm tra kết nối mạng và thử lại"];        
        [self.tableProducts reloadData];
        [self.tableProducts.pullToRefreshView stopAnimating];
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
    if (self.isSearching)
        return self.filteredList.count;
    
    return self.productsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"OFProductsTableCell";
    OFProductsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell)
        cell = [[OFProductsTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    if (self.isSearching && [self.filteredList count]) {
        if ([[self.filteredList objectAtIndex:indexPath.row] isKindOfClass:[OFProduct class]]) {
            [cell customProductCellWithProduct:[self.filteredList objectAtIndex:indexPath.row]];
            return cell;
        }
    }
 
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
    
    int selectedRow = [tableView indexPathForSelectedRow].row;
    
    if (self.isSearching) {
        if ([[self.filteredList objectAtIndex:selectedRow] isKindOfClass:[OFProduct class]]) {
            OFProduct *product = [self.filteredList objectAtIndex:selectedRow];
            desVC.productID = product.product_id;
        }else
        {
            desVC.productID = [[self.filteredList objectAtIndex:selectedRow] objectForKey:@"MaSanPham"];
        }
    }else{
        if ([[self.productsArr objectAtIndex:selectedRow] isKindOfClass:[OFProduct class]]) {
            OFProduct *product = [self.productsArr objectAtIndex:selectedRow];
            desVC.productID = product.product_id;
        }else
        {
            desVC.productID = [[self.productsArr objectAtIndex:selectedRow] objectForKey:@"MaSanPham"];
        }
    }
    
    OFNavigationViewController *centralNavVC = (OFNavigationViewController *) self.viewDeckController.centerController;
    [centralNavVC pushViewController:desVC animated:YES];

}

#pragma mark - UISearchDisplayControllerDelegate

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    //When the user taps the search bar, this means that the controller will begin searching.
    self.isSearching = YES;
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    //When the user taps the Cancel Button, or anywhere aside from the view.
    self.isSearching = NO;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterListForSearchText:searchString]; // The method we made in step 7
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterListForSearchText:[self.searchDisplayController.searchBar text]]; // The method we made in step 7
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (void)filterListForSearchText:(NSString *)searchText
{
    [self.filteredList removeAllObjects]; //clears the array from all the string objects it might contain from the previous searches
    
    NSArray *arrProduct = [OFProduct MR_findAll];
    for (OFProduct *product in arrProduct) {
        NSRange nameRange = [product.name rangeOfString:searchText options:NSCaseInsensitiveSearch];
        if (nameRange.location != NSNotFound) {
            [self.filteredList addObject:product];
        }
    }
}

@end
