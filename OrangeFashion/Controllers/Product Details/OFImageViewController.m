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
    
    self.view.frame = [[super view] frame];
    self.imgView.frame = [[super view] frame];
    
    self.productImage.userInteractionEnabled = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {
    [self setImgView:nil];
    [super viewDidUnload];
}
@end
