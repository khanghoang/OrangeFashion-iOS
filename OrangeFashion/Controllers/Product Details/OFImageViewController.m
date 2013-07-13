//
//  OFImageViewController.m
//  OrangeFashion
//
//  Created by Khang on 2/6/13.
//  Copyright (c) 2013 Khang. All rights reserved.
//

#import "OFImageViewController.h"

@interface OFImageViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *productImage;

@end

@implementation OFImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self.productImage setImageWithURL:[[NSURL alloc] initWithString:self.imageURL] placeholderImage:nil];
    self.view.frame = self.parentViewController.view.frame;
    
    self.view.backgroundColor = [UIColor blackColor];
    self.productImage.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapImages:)];
    [tap setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tap];
}

#pragma mark - OFImageViewController delegate

- (void)onTapImages:(id)sender
{
    DLog("Tapped");
    if ([self.delegate respondsToSelector:@selector(onTapProductImages:)]) {
        [self.delegate performSelector:@selector(onTapProductImages:) withObject:self];
    }
}


@end
