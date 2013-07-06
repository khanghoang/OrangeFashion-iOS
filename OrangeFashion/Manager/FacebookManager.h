//
//  FacebookManager.h
//
//  Created by Torin on 22/11/12.
//
//

#import <Foundation/Foundation.h>

@class FacebookManager;

@protocol FacebookManagerDelegate <NSObject>
@optional
- (void)facebookSessionStateChanged:(FacebookManager *)facebookManager;
- (void)facebookLoginSucceeded:(FacebookManager *)facebookManager;
- (void)facebookLoginFailed:(FacebookManager *)facebookManager;
@end

@interface FacebookManager : BaseManager

@property (nonatomic, weak) id<FacebookManagerDelegate> delegate;

- (BOOL)isOpenSession;
- (void)openSession;
- (void)openSessionForPublishing;
- (void)logout;

@end
