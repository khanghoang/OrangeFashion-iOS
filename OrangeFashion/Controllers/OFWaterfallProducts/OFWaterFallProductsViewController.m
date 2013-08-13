//
//  OFWaterFallProductsViewController.m
//  OrangeFashion
//
//  Created by Khang on 2/8/13.
//  Copyright (c) 2013 Khang. All rights reserved.
//

#import "OFWaterFallProductsViewController.h"
#import "OFCollectionViewCell.h"
#import "OFProductDetailsViewController.h"
#import "WaterFlowLayout.h"

@interface OFWaterFallProductsViewController ()
<PSUICollectionViewDataSource, UICollecitonViewDelegateWaterFlowLayout, UICollectionViewDataSourceWaterFlowLayout>

@property (weak, nonatomic) IBOutlet PSUICollectionView * collectionView;

@property (strong, nonatomic) NSMutableArray            * arrProducts;
@property (strong, nonatomic) NSMutableArray            * arrSize;
@property (assign, nonatomic) NSInteger                   randomValueForWaterSize;

@end

@implementation OFWaterFallProductsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.arrProducts = [[NSMutableArray alloc] init];
    
    [[OFProductManager sharedInstance] getProductsWithCategoryID:21 onSuccess:^(NSInteger statusCode, id obj) {
        [SVProgressHUD dismiss];
        [self.arrProducts setArray:(NSArray *)obj];
        [self calculateRandomValueForCollectionViewCellSize];
        [self.collectionView reloadData];
    } failure:^(NSInteger statusCode, id obj) {
        //Handle when failure
        [SVProgressHUD showErrorWithStatus:@"Xin vui lòng kiểm tra kết nối mạng và thử lại"];
        [self.collectionView reloadData];
    }];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    [self.collectionView registerClass:[OFCollectionViewCell class] forCellWithReuseIdentifier:@"OFCollectionViewCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.arrSize = [@[
                         [NSValue valueWithCGSize:CGSizeMake(145, 380)],
                         [NSValue valueWithCGSize:CGSizeMake(145, 340)],
                         [NSValue valueWithCGSize:CGSizeMake(145, 300)],
                         [NSValue valueWithCGSize:CGSizeMake(145, 280)],
                         [NSValue valueWithCGSize:CGSizeMake(145, 250)]
                         ] mutableCopy];
    
    WaterFlowLayout *cvLayout = [[WaterFlowLayout alloc] init];
    cvLayout.flowdatasource = self;
    cvLayout.flowdelegate = self;
    self.collectionView.collectionViewLayout = cvLayout;
    
    self.collectionView.decelerationRate = 3.3;
    
}

- (NSInteger)numberOfSectionsInCollectionView:(PSUICollectionView *)collectionView
{
    return 1;
}

- (PSUICollectionViewCell *)collectionView:(PSUICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    OFCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OFCollectionViewCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[OFCollectionViewCell alloc] init];
    }
    
    OFProduct *product;
    
    if ([[self.arrProducts objectAtIndex:indexPath.row] isKindOfClass:[OFProduct class]]) {
        product = [self.arrProducts objectAtIndex:indexPath.row];
        [cell configCellWithProduct:product];
    }else{
        product = [OFProduct productWithDictionary:[self.arrProducts objectAtIndex:indexPath.row]];
        [cell configCellWithProduct:product];
    }
    
    cell.delegate = (id) self.parentVC;
    
    return cell;
}

- (NSInteger)collectionView:(PSUICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrProducts.count;
}

- (void)calculateRandomValueForCollectionViewCellSize
{
    int nElements = self.arrSize.count - 1;
    int n = arc4random_uniform(nElements);
    self.randomValueForWaterSize = n;
}

- (CGSize)getSizeAtIndexPath:(NSIndexPath *)indexPath
{    
    NSValue *value = [self.arrSize objectAtIndex:indexPath.row % self.arrSize.count];
    CGSize size;
    [value getValue:&size];
    
    return size;
}

#pragma mark-  UICollecitonViewDelegateWaterFlowLayout
- (CGFloat)flowLayout:(WaterFlowLayout *)flowView heightForRowAtIndex:(int)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    CGSize size = [self getSizeAtIndexPath:indexPath];    
    return size.height;
}


#pragma mark- UICollectionViewDatasourceFlowLayout
- (NSInteger)numberOfColumnsInFlowLayout:(WaterFlowLayout*)flowlayout
{
    return 2;
}

@end
