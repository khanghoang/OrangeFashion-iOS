//
//  OFLeftMenuViewController.m
//  OrangeFashion
//
//  Created by Khang on 9/6/13.
//  Copyright (c) 2013 Khang. All rights reserved.
//

#import "OFLeftMenuViewController.h"
#import "OFSidebarMenuTableCell.h"
#import "OFLeftMenuSectionHeader.h"
#import "OFWaterFallProductsViewController.h"
#import "OFMapViewController.h"
#import "OFAppDelegate.h"

@interface OFLeftMenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray        * arrMenu;
@property (strong, nonatomic) NSArray               * arrSection;

@property (strong, nonatomic) NSArray               * arrSubMenuSectionOne;

@property (weak, nonatomic) IBOutlet UITableView    * tableMenu;

@end

@implementation OFLeftMenuViewController

#pragma mark - View controller lifecycle

- (void)viewDidLoad
{
    self.arrMenu = [[NSMutableArray alloc] init];
    
    self.arrSubMenuSectionOne = @[@"Orange Fashion", @"Hàng mới về", @"Liên hệ"];
    self.arrSection = @[@"Nổi bật", @"Danh mục", @"Thông tin", @"Tuỳ chỉnh"];
    
    self.tableMenu.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"SidebarMenuTableCellBg"] resizableImageWithStandardInsetsTop:0 right:0 bottom:0 left:0]];
    [self.tableMenu registerNib:[UINib nibWithNibName:NSStringFromClass([OFSidebarMenuTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([OFSidebarMenuTableCell class])];
    
    [[OFHelperManager sharedInstance] getMenuListOnComplete:^(NSArray *menu) {
        self.arrMenu = [[[menu objectAtIndex:1] objectForKey:@"session"] mutableCopy];
        [self.tableMenu reloadData];
    } orFailure:^(NSError *error) {
        DLog(@"Error when load menu");
    }];
}

#pragma mark - Tableview datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arrSection.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [OFLeftMenuSectionHeader getHeight];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    OFLeftMenuSectionHeader *header;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")) {
        header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([OFLeftMenuSectionHeader class])];
    }else{
        header = [[OFLeftMenuSectionHeader alloc] init];
    }
    if (!header) {
        header = [[OFLeftMenuSectionHeader alloc] init];
    }
    
    if ([[self.arrSection objectAtIndex:section] isKindOfClass:[NSString class]]) {
        NSString *title = [self.arrSection objectAtIndex:section];
        [header configTitleNameWithString:[title uppercaseString]];
    }
    
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellIndentifier =  NSStringFromClass([OFSidebarMenuTableCell class]);
    OFSidebarMenuTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    
    if (!cell) {
        cell = [[OFSidebarMenuTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    
    if (indexPath.section == 0) {
        NSString *title = [self.arrSubMenuSectionOne objectAtIndex:indexPath.row];
        NSDictionary *data = @{MENU_TITLE : title};
        [cell configWithData:data];
        return cell;
    }
    
    if (indexPath.section == 3) {
        NSDictionary *data = @{MENU_TITLE : @"Bản đồ"};
        [cell configWithData:data];
        return cell;
    }

    if (indexPath.row < self.arrMenu.count)
         [cell configWithData:[self.arrMenu objectAtIndex:indexPath.row]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    // Hit
    if (section == 0) {
        return self.arrSubMenuSectionOne.count;
    }
    
    // Menu
    if (section == 1) {
        return self.arrMenu.count;
    }
    
    // Information
    if (section == 2) {
        return 1;
    }
    
    // Log out
    if (section == 3) {
        return 1;
    }
    
    return self.arrMenu.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    IIViewDeckController *deckViewController = (IIViewDeckController*)[[(OFAppDelegate*)[[UIApplication sharedApplication]delegate] window] rootViewController];
    OFNavigationViewController *centralNavVC = (OFNavigationViewController *) deckViewController.centerController;
    
    if (indexPath.section == 0) {
        
        // Back to master menu
        if (indexPath.row == 0) {
            [centralNavVC popToRootViewControllerAnimated:YES];
            [deckViewController toggleLeftView];
            return;
        }
        
        // New products
        if (indexPath.row == 1) {
            OFProductsViewController *productsVC = [[OFProductsViewController alloc] init];
            productsVC.category_id = 21;
            productsVC.lblTitle = [self.arrSubMenuSectionOne objectAtIndex:indexPath.row];
            
            [centralNavVC pushViewController:productsVC animated:YES];
            [deckViewController toggleLeftView];
            return;
        }
        
        // Contact screen
        if (indexPath.row == 2) {
            return;
        }
    }
    
    if (indexPath.section == 3) {
        [centralNavVC pushViewController:[[OFMapViewController alloc] init] animated:YES];
        [deckViewController toggleLeftView];
        return;
    }
    
    if (indexPath.section == 2) {
        [centralNavVC pushViewController:[[OFWaterFallProductsViewController alloc] init] animated:YES];
        [deckViewController toggleLeftView];
        return;
    }
    
    OFProductsViewController *productsVC = [[OFProductsViewController alloc] init];
    productsVC.category_id = [[[self.arrMenu objectAtIndex:indexPath.row] objectForKey:CATEGORY_ID] integerValue];
    productsVC.lblTitle = [[self.arrMenu objectAtIndex:indexPath.row] objectForKey:MENU_TITLE];
    [centralNavVC pushViewController:productsVC animated:YES];
    [deckViewController toggleLeftView];
}

@end
