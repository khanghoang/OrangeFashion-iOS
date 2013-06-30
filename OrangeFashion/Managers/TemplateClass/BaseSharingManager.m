//
//  BaseSharingManager.m
//
//
//  Created by Suraj on 8/1/13.
//
//

#import "BaseSharingManager.h"
#import <Twitter/Twitter.h>
#import <FacebookSDK/FacebookSDK.h>

@interface BaseSharingManager() <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>

@property (nonatomic, copy) SuccessComposeBlock successBlock;
@property (nonatomic, copy) FailureComposeBlock failureBlock;

@end

@implementation BaseSharingManager

//============================================================================
#pragma mark - Init
//============================================================================

SINGLETON_MACRO

- (void)presentReportEmailComposerOn:(UIViewController *)rootVC
                           OnSuccess:successBlock
                           OnFailure:failureBlock
{
    MFMailComposeViewController *composeVC = [self reportEmailComposer];
    self.successBlock = successBlock;
    self.failureBlock = failureBlock;
    [composeVC setMailComposeDelegate:self];
    
    [self presentViewController:composeVC fromViewController:rootVC];
}

- (void)presentMailComposerWithSharingItem:(id <EGCSharingProtocol>)item
                        fromViewController:(UIViewController *)rootVC
                                   success:(SuccessComposeBlock)successBlock
                                   failure:(FailureComposeBlock)failureBlock
{
    //If device is not setup for email yet, this will pop up a system default message and composeVC will be nil
    MFMailComposeViewController *composeVC = [[MFMailComposeViewController alloc] init];
    if (!composeVC)
        return;
    
    [composeVC setSubject:[item sharingTitle]];
    [composeVC setMessageBody:[item sharingFullMessage] isHTML:NO];
    [composeVC setMailComposeDelegate:self];
    
    self.successBlock = successBlock;
    self.failureBlock = failureBlock;
    
    [self presentViewController:composeVC fromViewController:rootVC];
}

- (void)presentMessageComposerWithSharingItem:(id <EGCSharingProtocol>)item
                           fromViewController:(UIViewController *)rootVC
                                      success:(SuccessComposeBlock)successBlock
                                      failure:(FailureComposeBlock)failureBlock
{
    // If the device doesn't support messaging, this will pop up a system default message and composeVC will be nil
    // This includes iMessage as well
    MFMessageComposeViewController *composeVC = [[MFMessageComposeViewController alloc] init];
    if (!composeVC)
        return;
    
    composeVC.body = [item sharingFullMessage];
    [composeVC setMessageComposeDelegate:self];
    
    self.successBlock = successBlock;
    self.failureBlock = failureBlock;
    
    [self presentViewController:composeVC fromViewController:rootVC];
}

- (void)showSharingMenuWithItem:(id <EGCSharingProtocol>)sharingItem fromViewController:(UIViewController *)rootVC
{
    PSActionSheet *actionSheet = [[PSActionSheet alloc] initWithTitle:@""];
    
    [actionSheet addButtonWithTitle:NSLocalizedString(@"Share on Facebook", nil) block:^{
        [self shareOnFacebookWithSharingItem:sharingItem fromViewController:rootVC];
    }];
    
    [actionSheet addButtonWithTitle:NSLocalizedString(@"Share on Twitter", nil) block:^{
        [self shareOnTwitterWithItem:sharingItem fromViewController:rootVC];
    }];
    
    [actionSheet addButtonWithTitle:NSLocalizedString(@"Share via SMS", nil) block:^{
        [self presentMessageComposerWithSharingItem:sharingItem fromViewController:rootVC success:nil failure:nil];
    }];
    
    [actionSheet addButtonWithTitle:NSLocalizedString(@"Share via Email", nil) block:^{
        [self presentMailComposerWithSharingItem:sharingItem fromViewController:rootVC success:nil failure:nil];
    }];
    
    [actionSheet setCancelButtonWithTitle:NSLocalizedString(@"Cancel", nil) block:nil];
    
    [actionSheet showInView:rootVC.view];
}

//============================================================================
#pragma mark - Mail/Message ComposeDelegate
//============================================================================

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    [controller.presentingViewController dismissViewControllerAnimated:YES completion:nil];
	
	switch (result) {
        case MFMailComposeResultSent:
        {
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"AURSendMailStatus", nil)];
            if (self.successBlock != nil)
                self.successBlock();
            break;
        }
        case MFMailComposeResultFailed:
        {
            [UIAlertView showAlertWithTitle:NSLocalizedString(@"AURShareRestaurantErrorTitle", nil)
                                    message:NSLocalizedString(@"AURSendMailErrorMessage", nil)];
            if (self.failureBlock != nil)
                self.failureBlock(error);
			break;
        }
        default:
            break;
	}
	self.successBlock = nil;
	self.failureBlock = nil;
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result
{
    [controller.presentingViewController dismissViewControllerAnimated:YES completion:nil];
	
	switch (result) {
        case MessageComposeResultSent:
        {
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"AURSendMessageStatus", nil)];
            if (self.successBlock != nil)
                self.successBlock();
            
            break;
        }
        case MessageComposeResultFailed:		// Apparently message compose failure does not give any error msg
        {
            [UIAlertView showAlertWithTitle:NSLocalizedString(@"AURShareRestaurantErrorTitle", nil)
                                    message:NSLocalizedString(@"AURSendMessageErrorMessage", nil)];
            if (self.failureBlock != nil)
                self.failureBlock(nil);
			break;
        }
        default:
            break;
	}
	self.successBlock = nil;
	self.failureBlock = nil;
}

//============================================================================
// Private Method
//============================================================================

#pragma mark - Facebook

- (void)shareOnFacebookWithSharingItem:(id <EGCSharingProtocol>)item fromViewController:(UIViewController *)rootVC
{
    // Using Facebook Share Dialog
    FBShareDialogParams *shareDialogParams = [[FBShareDialogParams alloc] init];
    shareDialogParams.name = [item sharingTitle];
    shareDialogParams.link = [item sharingURL];
    shareDialogParams.description = [item sharingMessage];
    if ([FBDialogs canPresentShareDialogWithParams:shareDialogParams]) {
        [FBDialogs presentShareDialogWithParams:shareDialogParams clientState:nil handler:nil];
        return;
    }
    
    // Using iOS 6 Share Sheet
    BOOL presented = [FBDialogs presentOSIntegratedShareDialogModallyFrom:rootVC
                                                              initialText:[item sharingMessage]
                                                                    image:nil
                                                                      url:[item sharingURL]
                                                                  handler:nil];
    if (presented)
        return;
    
    // Using Feed Dialog
    NSMutableDictionary *feedDialogParams = [NSMutableDictionary dictionary];
    [feedDialogParams setValue:[item sharingTitle] forKey:@"name"];
    [feedDialogParams setValue:[item sharingURL].absoluteString forKey:@"link"];
    [feedDialogParams setValue:[item sharingMessage] forKey:@"description"];
    [FBWebDialogs presentFeedDialogModallyWithSession:nil parameters:feedDialogParams handler:nil];
}

#pragma mark - Twitter

- (void)shareOnTwitterWithItem:(id <EGCSharingProtocol>)sharingItem fromViewController:(UIViewController *)rootVC
{
    id tweetSheet = nil;
    
    // iOS 6
    if (NSClassFromString(@"SLComposeViewController") && [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    }
    // iOS 5
    else {
        tweetSheet = [[TWTweetComposeViewController alloc] init];
    }
    
    if (!tweetSheet)
        return;
    
    [tweetSheet setInitialText:[sharingItem sharingMessage]];
    [tweetSheet addURL:[sharingItem sharingImageURL]];
    
    [rootVC presentViewController:tweetSheet animated:YES completion:NULL];
}

#pragma mark - Mail & Message

- (void)presentViewController:(UIViewController *)presentedVC fromViewController:(UIViewController *)presentingVC
{
    if (presentingVC && presentedVC) {
        [presentingVC presentViewController:presentedVC animated:YES completion:nil];
    }
}

- (MFMailComposeViewController *)reportEmailComposer
{
    //If device is not setup for email yet, this will pop up a system default message
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    if (mailComposer == nil)
        return nil;
    
    NSString *messageBody = @"<html><body><p>";   //the <p> is to enable HTML content (hack for iOS)
    messageBody = [messageBody stringByAppendingFormat:@"App ID: %@", [OpenUDID hashedValue]];
    messageBody = [messageBody stringByAppendingFormat:@"<br/>Device Type: %@", [BaseDeviceLibrary getPlatformString]];
    messageBody = [messageBody stringByAppendingFormat:@"<br/>OS Version: %@", [[UIDevice currentDevice] systemVersion]];
    
    if ([BaseDeviceLibrary getCarrierName] != nil)
        messageBody = [messageBody stringByAppendingFormat:@"<br/>Carrier Name: %@", [BaseDeviceLibrary getCarrierName]];
    messageBody = [messageBody stringByAppendingFormat:@"<br/>App version: %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
    
    if ([EGCUserManager sharedInstance].currentUser == nil)
        messageBody = [messageBody stringByAppendingFormat:@"<br/>UserId: %@", [EGCUserManager sharedInstance].currentUser.ID];
    
    //Creating a NSDateFormater is expensive, we cache it
    static NSDateFormatter *staticAuroraLongDateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticAuroraLongDateFormatter = [[NSDateFormatter alloc] init];
        [staticAuroraLongDateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        [staticAuroraLongDateFormatter setDateFormat:@"E, dd MMM yyyy HH:mm:ss Z"];
        [staticAuroraLongDateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en"]];
        
    });
    
    messageBody = [messageBody stringByAppendingFormat:@"<br/>Date & Time: %@", [staticAuroraLongDateFormatter stringFromDate:[NSDate date]]];
    messageBody = [messageBody stringByAppendingFormat:@"</body></html>"];
    
    //Dynamic settings from server
    NSString *email = [[BaseStorageManager sharedInstance] getSettingStringValueWithKey:SETTINGS_FEEDBACK_EMAIL
                                                                          defaultValue:SETTINGS_FEEDBACK_EMAIL_DEFAULT];
    NSString *subject = [[BaseStorageManager sharedInstance] getSettingStringValueWithKey:SETTINGS_FEEDBACK_SUBJECT
                                                                            defaultValue:SETTINGS_FEEDBACK_SUBJECT_DEFAULT];
    
    [mailComposer setToRecipients:@[email]];
    [mailComposer setSubject:subject];
    [mailComposer setMessageBody:messageBody isHTML:YES];
    
    //BCC myself (if logged in)
    NSString * myEmail = [[EGCUserManager sharedInstance].currentUser email];
    if ([myEmail length] > 3 && [myEmail rangeOfString:@"@"].location != NSNotFound)
        [mailComposer setBccRecipients:[[NSArray alloc] initWithObjects:myEmail, nil]];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        mailComposer.modalPresentationStyle = UIModalPresentationPageSheet;
#endif
    
    return mailComposer;
}

@end
