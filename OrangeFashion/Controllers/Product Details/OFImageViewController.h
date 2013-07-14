//
//  OFImageViewController.h
//  OrangeFashion
//
//  Created by Khang on 2/6/13.
//  Copyright (c) 2013 Khang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OFImageViewControllerDelegate <NSObject>

- (void)onTapProductImages:(id)sender;

@end

@interface OFImageViewController : BaseViewController

@property (assign, nonatomic) int                                index;
@property (assign, nonatomic) id<OFImageViewControllerDelegate>  delegate;

@property (nonatomic, strong) NSString                          * imageURL;
@property (weak, nonatomic) IBOutlet UIImageView                * imgView;

@end
