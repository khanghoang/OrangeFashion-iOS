//
//  OFLeftMenuViewController.m
//  OrangeFashion
//
//  Created by Khang on 9/6/13.
//  Copyright (c) 2013 Khang. All rights reserved.
//

#import "OFLeftMenuViewController.h"
#import "OFSidebarMenuTableCell.h"

@interface OFLeftMenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *menuList;


@end

@implementation OFLeftMenuViewController

#pragma mark - View controller lifecycle

- (void)viewDidLoad
{
    self.menuList.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"SidebarMenuTableCellBg"] resizableImageWithStandardInsetsTop:0 right:0 bottom:0 left:0]];
    [self.menuList registerNib:[UINib nibWithNibName:@"OFSidebarMenuTableCell" bundle:nil] forCellReuseIdentifier:@"SidebarMenuTableCell"];
}

#pragma mark - Tableview datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIndentifier = @"SidebarMenuTableCell";
    OFSidebarMenuTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    
    if (!cell) {
        cell = [[OFSidebarMenuTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    
    NSDictionary *menu = @{@"title": @"dummy"};
    [cell configWithData:menu];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

@end
