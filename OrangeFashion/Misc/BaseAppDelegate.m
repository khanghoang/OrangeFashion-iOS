//
//  BaseAppDelegate.m
//
//  Created by Torin on 3/6/13.
//
//

#import "BaseAppDelegate.h"
#import "AFUrbanAirshipClient.h"

@implementation BaseAppDelegate

SINGLETON_MACRO

#pragma mark - Application Lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //---------------------------------------------------------------------------
    
    //Initialize storage, restore Settings first
    [BaseStorageManager sharedInstance];
    
    //Critercism
    NSString *critercismToken = [[BaseStorageManager sharedInstance] getSettingStringValueWithKey:SETTINGS_CRITERCISM_TOKEN
                                                                                     defaultValue:SETTINGS_CRITERCISM_TOKEN_DEFAULT];
    if ([critercismToken length] > 0)
        [Crittercism enableWithAppID:critercismToken];
    
    //Full offline restore (async)
    [[BaseStorageManager sharedInstance] restore];
    
    //---------------------------------------------------------------------------
        
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    //Save offline data
    [[BaseStorageManager sharedInstance] dumpFullOfflineCache];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self clearNotifications];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [FBSession.activeSession close];
}




#pragma mark - Switch View Controller

- (void)switchRootViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)())completion
{
    if (animated) {
        [UIView transitionWithView:self.window duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            BOOL oldState = [UIView areAnimationsEnabled];
            [UIView setAnimationsEnabled:NO];
            self.window.rootViewController = viewController;
            [UIView setAnimationsEnabled:oldState];
        } completion:^(BOOL finished) {
            if (completion) completion();
        }];
    } else {
        self.window.rootViewController = viewController;
        if (completion) completion();
    }
}



#pragma mark - Push Notification

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    AFUrbanAirshipClient *client = [[AFUrbanAirshipClient alloc] initWithApplicationKey:URBAN_AIRSHIP_APP_KEY
                                                                      applicationSecret:URBAN_AIRSHIP_APP_SECRET];
    [client registerDeviceToken:deviceToken withAlias:nil success:^{
        DLog(@"Urban Airship registered device token successfully");
    } failure:^(NSError *error) {
        DLog(@"Urban Airship failed to register device token. Error: %@", error);
    }];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    DLog(@"FailToRegisterForRemoteNotification: %@", error.description);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    DLog(@"Received Push Notification: %@", userInfo);
    
    switch (application.applicationState) {
        case UIApplicationStateActive:
            [UIAlertView showAlertWithTitle:NSLocalizedString(@"Push Notification", nil) message:userInfo[@"aps"][@"alert"]];
            break;
        case UIApplicationStateBackground:
        case UIApplicationStateInactive:
            break;
        default:
            break;
    }
}

- (void)clearNotifications
{
    // Clear notifications in Notification Center
    // Setting badge number to 0 will clear notifications, but only when the number is changed before,
    // So to make it work when the number is not changed, we set it to 1 first.
    [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}



#pragma mark - FacebookSDK

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [FBSession.activeSession handleOpenURL:url];
}

@end