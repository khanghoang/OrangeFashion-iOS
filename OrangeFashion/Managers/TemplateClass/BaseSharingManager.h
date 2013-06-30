//
//  BaseSharingManager.h
//
//
//  Created by Suraj on 8/1/13.
//
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

typedef void (^SuccessComposeBlock)(void);
typedef void (^FailureComposeBlock)(NSError *error);

@interface BaseSharingManager : BaseManager

/*
 * Present report email composer, prefilled with as much device info as we can obtain
 */
- (void)presentReportEmailComposerOn:(UIViewController *)rootVC
                           OnSuccess:successBlock
                           OnFailure:failureBlock;

- (void)presentMailComposerWithSharingItem:(id <EGCSharingProtocol>)item
                        fromViewController:(UIViewController *)rootVC
                                   success:(SuccessComposeBlock)successBlock
                                   failure:(FailureComposeBlock)failureBlock;

- (void)presentMessageComposerWithSharingItem:(id <EGCSharingProtocol>)item
                           fromViewController:(UIViewController *)rootVC
                                      success:(SuccessComposeBlock)successBlock
                                      failure:(FailureComposeBlock)failureBlock;

- (void)showSharingMenuWithItem:(id <EGCSharingProtocol>)sharingItem fromViewController:(UIViewController *)rootVC;

@end
