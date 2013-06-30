//
//  UiViewController+Transitions.m
//  Labgoo Misc
//
//  Created by Israel Roth on 3/4/12.
//  Copyright (c) 2012 Labgoo LTD. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UIViewController+Additions.h"

@implementation UIViewController(Transitions)

#pragma mark - Custom transition

- (void)presentModalViewController:(UIViewController *)modalViewController withPushDirection:(NSString *)direction
{
  [CATransaction begin];
  
  CATransition *transition = [CATransition animation];
  transition.type = kCATransitionPush;
  transition.subtype = direction;
  transition.duration = 0.35f;
  transition.fillMode = kCAFillModeForwards;
  transition.removedOnCompletion = YES;
  
  [[UIApplication sharedApplication].keyWindow.layer addAnimation:transition forKey:@"transition"];
  [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
  [CATransaction setCompletionBlock: ^ {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(transition.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^ {
      [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    });
  }];
  
  [self presentModalViewController:modalViewController animated:NO];
  
  [CATransaction commit];
}

- (void)dismissModalViewControllerWithPushDirection:(NSString *)direction
{  
  [CATransaction begin];
  
  CATransition *transition = [CATransition animation];
  transition.type = kCATransitionPush;
  transition.subtype = direction;
  transition.duration = 0.35f;
  transition.fillMode = kCAFillModeForwards;
  transition.removedOnCompletion = YES;
  
  [[UIApplication sharedApplication].keyWindow.layer addAnimation:transition forKey:@"transition"];
  [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
  [CATransaction setCompletionBlock: ^ {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(transition.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^ {
      [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    });
  }];
  
  [self dismissModalViewControllerAnimated:NO];
  
  [CATransaction commit];
}

- (void)dismissModalViewControllerWithFadeDuration:(CGFloat)duration
{
  [CATransaction begin];
  
  CATransition *transition = [CATransition animation];
  transition.type = kCATransitionFade;
  transition.duration = duration;
  transition.fillMode = kCAFillModeForwards;
  transition.removedOnCompletion = YES;
  
  [[UIApplication sharedApplication].keyWindow.layer addAnimation:transition forKey:@"transition"];
  [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
  [CATransaction setCompletionBlock: ^ {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(transition.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^ {
      [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    });
  }];
  
  [self dismissModalViewControllerAnimated:NO];
  
  [CATransaction commit];
}



#pragma mark - Helpers

- (BOOL)hasNativeFacebookApp
{
  NSURL *url = [NSURL URLWithString:@"fb://profile/566862027"];
  BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];
  return canOpen;
}

- (BOOL)openFacebookPageID:(NSString*)pageID
{
  BOOL hasNativeApp = [self hasNativeFacebookApp];
  
  //Open with native Facebook app
  if (hasNativeApp) {
    NSString *url = [NSString stringWithFormat:@"fb://profile/%@", pageID];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.25 * NSEC_PER_SEC), dispatch_get_current_queue(), ^{
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    });
    return YES;
  }

  //Open in Safari browser
  NSString *url = [NSString stringWithFormat:@"http://facebook.com/%@", pageID];
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.25 * NSEC_PER_SEC), dispatch_get_current_queue(), ^{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
  });
  return NO;
}

- (BOOL)hasNativeTwitterApp
{
  NSURL *url = [NSURL URLWithString:@"twitter://user?screen_name=torinnguyen"];
  BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];
  return canOpen;
}

- (BOOL)openTwitterScreenName:(NSString*)screenName
{
  BOOL hasNativeApp = [self hasNativeFacebookApp];
  
  //Open with native Twitter app
  if (hasNativeApp) {
    NSString *url = [NSString stringWithFormat:@"twitter://user?screen_name=%@", screenName];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.25 * NSEC_PER_SEC), dispatch_get_current_queue(), ^{
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    });
    return YES;
  }
  
  //Open in Safari browser
  NSString *url = [NSString stringWithFormat:@"url://twitter.com/%@", screenName];
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.25 * NSEC_PER_SEC), dispatch_get_current_queue(), ^{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
  });
  return NO;
}

- (UIView *)dismissKeyboard
{
    //This is just a shortcut to UIView+Additions
    return [self.view findAndResignFirstResponder];
}

@end

