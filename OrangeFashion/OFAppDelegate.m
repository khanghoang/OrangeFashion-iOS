//
//  OFAppDelegate.m
//  OrangeFashion
//
//  Created by Khang on 4/4/13.
//  Copyright (c) 2013 Khang. All rights reserved.
//

#import "OFAppDelegate.h"
#import "OFMenuViewController.h"
#import "IIViewDeckController.h"
#import "OFHomeViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "UAConfig.h"
#import "UAirship.h"
#import "UAPush.h"
#import "UAAnalytics.h"
#import "CHDraggableView.h"
#import "CHDraggableView+Avatar.h"
#import "CHDraggingCoordinator.h"
#import "OFPageMenuViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface OFAppDelegate() <CHDraggingCoordinatorDelegate>

@property (strong, nonatomic) OFNavigationViewController        * navController;
@property (strong, nonatomic) CHDraggingCoordinator             * draggingCoordinator;

@end

@implementation OFAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [super application:application didFinishLaunchingWithOptions:launchOptions];
    // Setup Flurry
    [Flurry startSession:SETTINGS_FLURRY_TOKEN_DEFAULT];
    
    // Setup Google map
    [GMSServices provideAPIKey:SETTINGS_GOOGLE_MAP_API_TOKEN];
    
    // Setup Google Analytics
    [self setUpGoogleAnalytic];
    
    // start MR
    [MagicalRecord setupCoreDataStack];
    [FBLoginView class];
    
    [FacebookManager sharedInstance].delegate = self;
    
    // Make the color of Navigation bar no more effects the status bar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque
                                                animated:NO];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    IIViewDeckController *deckController = [self generateControllerStack];
    self.leftController = deckController.leftController;
    self.centerController = deckController.centerController;
    self.navController = (OFNavigationViewController *)deckController.centerController;
    
    self.window.rootViewController = deckController;
    [self.window makeKeyAndVisible];
    
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        // Yes, so just open the session (this won't display any UX).
        [self openSession];
        
#warning DO IT LATER
//        [self.navController pushViewController:[[OFMenuViewController alloc] init] animated:YES];
    } else {
        // No, display the login page.
//        [self showLoginView];
    }
    
    // Urban Airship
    UAConfig *config = [UAConfig defaultConfig];
    
    // Call takeOff (which creates the UAirship singleton)
    [UAirship takeOff:config];
    
    // Request a custom set of notification types
    [UAPush shared].notificationTypes = (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeNewsstandContentAvailability);
     
    [[UAPush shared] setPushEnabled:YES];
    
    [self addDraggableBookmark];
    
    return YES;
}

- (void)addDraggableBookmark
{
    CHDraggableView *draggableView = [CHDraggableView draggableViewWithImage:[UIImage imageNamed:@"bookmark-icons"]];    
    self.draggingCoordinator = [[CHDraggingCoordinator alloc] initWithWindow:self.window draggableViewBounds:draggableView.bounds];
    self.draggingCoordinator.delegate = self;
    self.draggingCoordinator.snappingEdge = CHSnappingEdgeBoth;
    draggableView.delegate = self.draggingCoordinator;
    
    [self.window addSubview:draggableView];
}

- (void)setUpGoogleAnalytic
{
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    // Optional: set debug to YES for extra debugging information.
    [GAI sharedInstance].debug = YES;
    // Create tracker instance.
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:GOOGLE_TRACKING_ID];
    [GAI sharedInstance].debug = YES;
}

- (IIViewDeckController*)generateControllerStack {
    
    OFLeftMenuViewController* leftController = [[OFLeftMenuViewController alloc] init];
    OFBookmarkViewViewController* rightController = [[OFBookmarkViewViewController alloc] init];
    
    // Set up ViewDeck central
    OFPageMenuViewController *centralViewController = [[OFPageMenuViewController alloc] init];
    OFNavigationViewController *centralNavController = [[OFNavigationViewController alloc] initWithRootViewController:centralViewController];
    
    IIViewDeckController* deckController =  [[IIViewDeckController alloc] initWithCenterViewController:centralNavController leftViewController:leftController rightViewController:rightController];
    
    [deckController setNavigationControllerBehavior:IIViewDeckNavigationControllerIntegrated];
    [deckController setCenterhiddenInteractivity:IIViewDeckCenterHiddenNotUserInteractiveWithTapToCloseBouncing];
    
    deckController.rightSize = 60;
    
    return deckController;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    // We need to properly handle activation of the application with regards to Facebook Login
    // (e.g., returning from iOS 6.0 Login Dialog or from fast app switching).
    [FBSession.activeSession handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [FBSession.activeSession close];
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"OrangeFashion" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"OrangeFashion.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Facebook

- (void)openSession
{
    [[FacebookManager sharedInstance] openSession];
}

- (void)showLoginView
{
    UIViewController *topViewController = [self.navController topViewController];    
    OFHomeViewController* loginViewController = [[OFHomeViewController alloc]initWithNibName:@"OFHomeViewController" bundle:nil];
    [topViewController presentModalViewController:loginViewController animated:NO];
}

#pragma mark - CHDragging delegate
- (UIViewController *)draggingCoordinator:(CHDraggingCoordinator *)coordinator viewControllerForDraggableView:(CHDraggableView *)draggableView
{
//    return [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    return [[OFBookmarkViewViewController alloc] init];
}

@end
