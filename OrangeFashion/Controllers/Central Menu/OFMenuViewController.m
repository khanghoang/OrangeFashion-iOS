//
//  OFMenuViewController.m
//  OrangeFashion
//
//  Created by Khang on 11/5/13.
//  Copyright (c) 2013 Khang. All rights reserved.
//

#import "OFMenuViewController.h"

@interface OFMenuViewController ()

@property (weak, nonatomic) IBOutlet UIView *viewVayDam;

@property (nonatomic, strong) IBOutlet UITapGestureRecognizer *tapRecognizer;

@end

@implementation OFMenuViewController

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
    [self.navigationController setNavigationBarHidden:NO];
    
	// Do any additional setup after loading the view.
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTap)];
    
    tapGesture.numberOfTapsRequired = 1;
    
    [self.view addGestureRecognizer:tapGesture];
}

- (void)viewTap{
    DLog(@"Tapped");
    
    [self performSegueWithIdentifier:@"SegueFromMenuToListProducts" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setViewVayDam:nil];
    [super viewDidUnload];
}
@end
