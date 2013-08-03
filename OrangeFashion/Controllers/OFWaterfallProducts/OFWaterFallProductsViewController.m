//
//  OFWaterFallProductsViewController.m
//  OrangeFashion
//
//  Created by Khang on 2/8/13.
//  Copyright (c) 2013 Khang. All rights reserved.
//

#import "OFWaterFallProductsViewController.h"
#import "OFCollectionViewCell.h"

@interface OFWaterFallProductsViewController ()
<PSUICollectionViewDataSource, PSUICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet PSUICollectionView * collectionView;
@property (strong, nonatomic) NSArray                   * arrSize;

@end

@implementation OFWaterFallProductsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
    
    [self.collectionView registerClass:[OFCollectionViewCell class] forCellWithReuseIdentifier:@"OFCollectionViewCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.arrSize = @[
                         [NSValue valueWithCGSize:CGSizeMake(145, 160)],
                         [NSValue valueWithCGSize:CGSizeMake(145, 200)],
                         [NSValue valueWithCGSize:CGSizeMake(145, 240)],
                         [NSValue valueWithCGSize:CGSizeMake(145, 280)],
                         [NSValue valueWithCGSize:CGSizeMake(145, 300)],
                         ];
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
    
    NSInteger index = indexPath.section * 3 + indexPath.row % self.arrSize.count;
    NSValue *value = [self.arrSize objectAtIndex:index];
    CGSize size;
    [value getValue:&size];
    
    CGRect frame = cell.frame;
    frame.size = size;
    cell.frame = frame;
    
    return cell;
}

- (NSInteger)collectionView:(PSUICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 20;
}

#pragma mark - PSTCollectionViewDelegateFlowLayout

- (CGSize)collectionView:(PSUICollectionView *)collectionView layout:(PSUICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger index = indexPath.section * 3 + indexPath.row % self.arrSize.count;
    NSValue *value = [self.arrSize objectAtIndex:index];
    CGSize size;
    [value getValue:&size];
    
    return size;
}

- (CGFloat)collectionView:(PSUICollectionView *)collectionView layout:(PSUICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(PSUICollectionView *)collectionView layout:(PSUICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

@end
