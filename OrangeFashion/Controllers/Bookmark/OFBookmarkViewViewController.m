//
//  OFBookmarkViewViewController.m
//  OrangeFashion
//
//  Created by Khang on 21/7/13.
//  Copyright (c) 2013 Khang. All rights reserved.
//

#import "OFBookmarkViewViewController.h"
#import "OFSidebarMenuTableCell.h"

@interface OFBookmarkViewViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableViewBookmarkedProducts;
@property (strong, nonatomic) NSMutableArray *arrBookmarkedProducts;

@end

@implementation OFBookmarkViewViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.arrBookmarkedProducts = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view from its nib.
    [self.tableViewBookmarkedProducts registerNib:[UINib nibWithNibName:@"OFSidebarMenuTableCell" bundle:nil] forCellReuseIdentifier:@"SidebarMenuTableCell"];
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
    static NSString *cellIndentifier = @"SidebarMenuTableCell";
    OFSidebarMenuTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell)
        cell = (OFSidebarMenuTableCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SidebarMenuTableCell"];
    
    //TODO: something need to configed here
    [cell configWithData:nil];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrBookmarkedProducts.count;
}
@end
