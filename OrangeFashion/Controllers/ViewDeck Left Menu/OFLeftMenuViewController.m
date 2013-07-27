//
//  OFLeftMenuViewController.m
//  OrangeFashion
//
//  Created by Khang on 9/6/13.
//  Copyright (c) 2013 Khang. All rights reserved.
//

#import "OFLeftMenuViewController.h"
#import "OFSidebarMenuTableCell.h"
#import "OFSidebarMenuTableCell.h"
#import "OFAppDelegate.h"

@interface OFLeftMenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray        * arrMenu;
@property (weak, nonatomic) IBOutlet UITableView    * tableMenu;

@end

@implementation OFLeftMenuViewController

#pragma mark - View controller lifecycle

- (void)viewDidLoad
{
    self.arrMenu = [[NSMutableArray alloc] init];
    
    self.tableMenu.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"SidebarMenuTableCellBg"] resizableImageWithStandardInsetsTop:0 right:0 bottom:0 left:0]];
    [self.tableMenu registerNib:[UINib nibWithNibName:@"OFSidebarMenuTableCell" bundle:nil] forCellReuseIdentifier:@"SidebarMenuTableCell"];
    
    [[OFHelperManager sharedInstance] getMenuListOnComplete:^(NSArray *menu) {
        self.arrMenu = [[[menu objectAtIndex:1] objectForKey:@"session"] mutableCopy];
        [self.tableMenu reloadData];
    } orFailure:^(NSError *error) {
        DLog(@"Error when load menu");
    }];
}

#pragma mark - Tableview datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIndentifier = @"SidebarMenuTableCell";
    OFSidebarMenuTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    
    if (!cell) {
        cell = [[OFSidebarMenuTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }

    if (indexPath.row < self.arrMenu.count)
         [cell configWithData:[self.arrMenu objectAtIndex:indexPath.row]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if ([[OFUserManager sharedInstance] isLoggedUser])
        return 1;
    
    return self.arrMenu.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OFProductsViewController *productsVC = [[OFProductsViewController alloc] init];
    
    productsVC.category_id = [[[self.arrMenu objectAtIndex:indexPath.row] objectForKey:CATEGORY_ID] integerValue];
    
    IIViewDeckController *deckViewController = (IIViewDeckController*)[[(OFAppDelegate*)[[UIApplication sharedApplication]delegate] window] rootViewController];
    OFNavigationViewController *centralNavVC = (OFNavigationViewController *) deckViewController.centerController;
    
    [centralNavVC pushViewController:productsVC animated:YES];
    [deckViewController toggleLeftView];
}

@end
