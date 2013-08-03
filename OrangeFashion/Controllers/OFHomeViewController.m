//
//  OFHomeViewController.m
//  OrangeFashion
//
//  Created by Khang on 9/6/13.
//  Copyright (c) 2013 Khang. All rights reserved.
//

#import "OFHomeViewController.h"
#import "OFAppDelegate.h"
#import "OFMenuViewController.h"
#import "OFPageMenuViewController.h"

@interface OFHomeViewController () <FBLoginViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblShowAllProducts;
@property (weak, nonatomic) IBOutlet FBLoginView *FBLoginView;
@property (weak, nonatomic) IBOutlet UIImageView *imgFBAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lblFBUsername;

@end

@implementation OFHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Facebook SDK * pro-tip *
        // We wire up the FBLoginView using the interface builder
        // but we could have also explicitly wired its delegate here.
        self.FBLoginView.readPermissions = @[@"publish_actions", @"email", @"user_likes"];
        self.FBLoginView.defaultAudience = FBSessionDefaultAudienceFriends;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showProductsList)];
    [self.view addGestureRecognizer:tap];
}

- (void)showProductsList
{
    OFNavigationViewController *navVC = (OFNavigationViewController *)self.viewDeckController.centerController;
    [navVC pushViewController:[[OFPageMenuViewController alloc] init] animated:YES];
}

- (IBAction)performLogin:(id)sender
{
    OFAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate openSession];
}

- (void)loginFailed
{
    // User switched back to the app without authorizing. Stay here, but
    // stop the spinner.
}

- (void)showLoginView
{
    UIViewController *topViewController = [self.navigationController topViewController];
    UIViewController *modalViewController = [topViewController modalViewController];
    
    // If the login screen is not already displayed, display it. If the login screen is
    // displayed, then getting back here means the login in progress did not successfully
    // complete. In that case, notify the login view so it can update its UI appropriately.
    if (![modalViewController isKindOfClass:[OFHomeViewController class]]) {
        OFHomeViewController* loginViewController = [[OFHomeViewController alloc]
                                                      initWithNibName:@"OFHomeViewController"
                                                      bundle:nil];
        [topViewController presentModalViewController:loginViewController animated:NO];
    } else {
        OFHomeViewController* loginViewController = (OFHomeViewController*)modalViewController;
        [loginViewController loginFailed];
    }
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    [[OFUserManager sharedInstance] setLoggedUser:user];
    
    [self.imgFBAvatar setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", user.id]]placeholderImage:nil];
    [self.imgFBAvatar roundCorner];
    self.imgFBAvatar.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.imgFBAvatar.layer shouldRasterize];
    self.imgFBAvatar.layer.borderWidth = 3;
    
    self.lblFBUsername.text = [[OFUserManager sharedInstance].loggedUser username];
}

@end
