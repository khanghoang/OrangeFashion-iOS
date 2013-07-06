//
//  FacebookManager.m
//
//  Created by Torin on 22/11/12.
//
//

#import "FacebookManager.h"

@interface FacebookManager()

@end

@implementation FacebookManager

SINGLETON_MACRO

#pragma mark -

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
  switch (state) {
      
    case FBSessionStateOpen:
      if ([self.delegate respondsToSelector:@selector(facebookLoginSucceeded:)])
        [self.delegate facebookLoginSucceeded:self];
      break;
      
    case FBSessionStateClosed:
    case FBSessionStateClosedLoginFailed: 
      [FBSession.activeSession closeAndClearTokenInformation];
      if ([self.delegate respondsToSelector:@selector(facebookLoginFailed:)])
          [self.delegate facebookLoginFailed:self];
      break;
      
    default:
      break;
  }
  
  //Callback
  if ([self.delegate respondsToSelector:@selector(facebookSessionStateChanged:)])
    [self.delegate facebookSessionStateChanged:self];
}

- (BOOL)isOpenSession
{
  if ([FBSession activeSession] == nil)
    return NO;
  
  return FBSession.activeSession.isOpen;
}

- (void)openSession
{
  [FBSession openActiveSessionWithReadPermissions:[NSArray hgwFacebookPermissionsArray]
                                     allowLoginUI:YES
                                completionHandler:^(FBSession *session, FBSessionState state, NSError *error)
   {
     [self sessionStateChanged:session state:state error:error];
   }];
}

- (void)openSessionForPublishing
{
  [FBSession openActiveSessionWithPublishPermissions:@[@"publish_stream"]
                                     defaultAudience:FBSessionDefaultAudienceFriends
                                        allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState state, NSError *error)
   {
     [self sessionStateChanged:session state:state error:error];
   }];
}

- (void)logout
{
  if ([FBSession activeSession] == nil)
    return;
  
  [[FBSession activeSession] closeAndClearTokenInformation];
}


@end
