//
//  OFAppDelegate.h
//  OrangeFashion
//
//  Created by Khang on 4/4/13.
//  Copyright (c) 2013 Khang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseAppDelegate.h"
#import "IIViewDeckController.h"

@interface OFAppDelegate : BaseAppDelegate <UIApplicationDelegate>

@property (retain, nonatomic) UIViewController *centerController;
@property (retain, nonatomic) UIViewController *leftController;

- (IIViewDeckController*)generateControllerStack;

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
