//
//  EGCPopupView.m
//  EagleChild
//
//  Created by Khang on 5/7/13.
//
//

#import "OFPopupBaseView.h"
#import <objc/runtime.h>

@interface OFPopupBaseView() <UIGestureRecognizerDelegate>

@property (nonatomic, weak) IBOutlet UIImageView * imgBackground;
@property (nonatomic, strong) AGWindowView * agWindowView;

@end

@implementation OFPopupBaseView


#pragma mark - Initialize

+ (id)initPopupWithTitle:(NSString *)title
                 message:(NSString *)message
            dismissBlock:(void (^)(id popupView))dismissBlock
{
    OFPopupBaseView *popupView = [[self alloc] initWithNib];
    if (self == nil)
        return nil;
    
    popupView.lblTitle.text = title;
    popupView.lblSubtitle.text = message;
    
    //set block as an attribute in runtime
    objc_setAssociatedObject(popupView, "dismissBlockCallback", [dismissBlock copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    return popupView;
}



#pragma mark - Initialization helpers

- (id)initWithNib
{
    NSString *className = NSStringFromClass([self class]);
    return [self initWithNibName:className];
}

- (id)initWithNibName:(NSString *)nibName
{
    self = [super init];
    if (self == nil)
        return nil;
    
    // Initialization code
    self = [[[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil] objectAtIndex:0];
    
    self.imgBackground.image = [self.imgBackground.image resizableImageWithStandardInsets];
    
    return self;
}



#pragma mark - Action for buttons

- (IBAction)onBtnClose:(UIButton *)sender
{
    //get back the block object attribute we set earlier
    void (^block)(id popupView) = objc_getAssociatedObject(self, "dismissBlockCallback");
    
    [self dismissOnCompletion:^{
        if (block)
            block(self);
    }];
}



#pragma mark - Public interfaces

- (void)show
{
    [self showOnCompletion:nil];
}

- (void)dismiss
{
    [self dismissOnCompletion:nil];
}

- (void)showOnCompletion:(void(^)(void))completionBlock
{
    self.agWindowView = [[AGWindowView alloc] initAndAddToKeyWindow];
    
    UITapGestureRecognizer *tapOutsideToClose = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOutsideToClose:)];
    [self.agWindowView addGestureRecognizer:tapOutsideToClose];
    
    [self.agWindowView addSubview:self];
    
    self.center = [self getWindowCenter];
    self.alpha = 0;
    self.layer.transform = CATransform3DMakeScale(0.8, 0.8, 0.8);
    
    //Optional
    [self addShadow];

    [UIView mt_animateViews:@[self]
                   duration:0.5
             timingFunction:kMTEaseOutElastic
                    options:UIViewAnimationOptionBeginFromCurrentState
                 animations:^{
                     self.alpha = 1;
                     self.layer.transform = CATransform3DIdentity;
                 } completion:^{

                 }];
    
    [UIView animateWithDuration:0.4 animations:^{
        self.agWindowView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    } completion:^(BOOL finished) {
        if (completionBlock)
            completionBlock();
    }];
}

- (void)dismissOnCompletion:(void(^)(void))completionBlock
{
    [UIView mt_animateViews:@[self]
                   duration:0.6
             timingFunction:kMTEaseInElastic
                    options:UIViewAnimationOptionBeginFromCurrentState
                 animations:^{
                     self.alpha = 0;
                     self.layer.transform = CATransform3DMakeScale(0.6, 0.6, 0.6);
                 } completion:^{
                     
                 }];
    
    double delayInSeconds = 0.2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.agWindowView fadeOutAndRemoveFromSuperview:completionBlock];
    });
}




#pragma mark - Private helpers

- (void)addShadow
{
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.12;
    self.layer.shadowOffset = CGSizeZero;
    self.layer.shadowRadius = 10;
    self.layer.masksToBounds = NO;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (CGPoint)getWindowCenter
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation))
        return CGPointMake(CGRectGetMidX(screenRect), CGRectGetMidY(screenRect));
    
    return CGPointMake(CGRectGetMidY(screenRect), CGRectGetMidX(screenRect));
}

- (void)tapOutsideToClose:(id)sender
{
    [self dismiss];
}

#pragma mark - UIGestureDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return NO;
}

@end
