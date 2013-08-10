//
//  OFPopupBookmark.m
//  OrangeFashion
//
//  Created by Khang on 10/8/13.
//  Copyright (c) 2013 Khang. All rights reserved.
//

#import "OFPopupBookmark.h"
#import "objc/runtime.h"

@interface OFPopupBookmark() <UIGestureRecognizerDelegate>

@end

@implementation OFPopupBookmark

+ (id)initPopupWithTitle:(NSString *)title
                 message:(NSString *)message
            dismissBlock:(void (^)(OFPopupBookmark *popupView))dismissBlock
            comfirmBlock:(void (^)(OFPopupBookmark *popupView))confirmBlock
{
    OFPopupBookmark *popup;
    popup = [super initPopupWithTitle:title message:message dismissBlock:dismissBlock];
    objc_setAssociatedObject(popup, "OFPopupBookmarkDismissBlock", [dismissBlock copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(popup, "OFPopupBookmarkConfirmBlock", [confirmBlock copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return popup;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return NO;
}

- (IBAction)onBtnCancel:(id)sender {
    void (^block)(OFPopupBookmark *popupView) = objc_getAssociatedObject(self, "OFPopupBookmarkDismissBlock");
    if (block) {
        block(self);
    }
    [self dismiss];
}

- (IBAction)onBtnOkie:(id)sender {
    void (^block)(OFPopupBookmark *popupView) = objc_getAssociatedObject(self, "OFPopupBookmarkConfirmBlock");
    if (block) {
        block(self);
    }
    [self dismiss];
}

@end
