//
//  EGCPopupView.h
//  EagleChild
//
//  Created by Khang on 5/7/13.
//
//

#import <UIKit/UIKit.h>

@interface OFPopupBaseView : UIView

@property (nonatomic, strong) IBOutlet UILabel * lblTitle;
@property (nonatomic, strong) IBOutlet UILabel * lblSubtitle;
@property (nonatomic, strong) IBOutlet UIButton * btnClose;

+ (id)initPopupWithTitle:(NSString *)title
                 message:(NSString *)message
            dismissBlock:(void (^)(id popupView))dismissBlock;

- (id)initWithNib;
- (id)initWithNibName:(NSString *)nibName;

- (void)show;
- (void)dismiss;

- (void)showOnCompletion:(void(^)(void))completionBlock;
- (void)dismissOnCompletion:(void(^)(void))completionBlock;

@end
