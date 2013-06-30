//
//  BaseAppDelegate.h
//
//  Created by Torin on 3/6/13.
//
//

#import <UIKit/UIKit.h>

@interface BaseAppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIViewController *viewController;

- (void)switchRootViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)())completion;

@end
