#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIView (KNCategory)

/**
 * Shortcut for frame.origin.x.
 *
 * Sets frame.origin.x = left
 */
@property (nonatomic) CGFloat left;

/**
 * Shortcut for frame.origin.y
 *
 * Sets frame.origin.y = top
 */
@property (nonatomic) CGFloat top;

/**
 * Shortcut for frame.origin.x + frame.size.width
 *
 * Sets frame.origin.x = right - frame.size.width
 */
@property (nonatomic) CGFloat right;

/**
 * Shortcut for frame.origin.y + frame.size.height
 *
 * Sets frame.origin.y = bottom - frame.size.height
 */
@property (nonatomic) CGFloat bottom;

/**
 * Shortcut for frame.size.width
 *
 * Sets frame.size.width = width
 */
@property (nonatomic) CGFloat width;

/**
 * Shortcut for frame.size.height
 *
 * Sets frame.size.height = height
 */
@property (nonatomic) CGFloat height;

/**
 * Shortcut for center.x
 *
 * Sets center.x = centerX
 */
@property (nonatomic) CGFloat centerX;

/**
 * Shortcut for center.y
 *
 * Sets center.y = centerY
 */
@property (nonatomic) CGFloat centerY;

/**
 * Return the x coordinate on the screen.
 */
@property (nonatomic, readonly) CGFloat ttScreenX;

/**
 * Return the y coordinate on the screen.
 */
@property (nonatomic, readonly) CGFloat ttScreenY;

/**
 * Return the x coordinate on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGFloat screenViewX;

/**
 * Return the y coordinate on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGFloat screenViewY;

/**
 * Return the view frame on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGRect screenFrame;

/**
 * Shortcut for frame.origin
 */
@property (nonatomic) CGPoint origin;

/**
 * Center of bounds, not frame
 */
@property (nonatomic) CGPoint boundCenter;

/**
 * Shortcut for frame.size
 */
@property (nonatomic) CGSize size;

/**
 * Return first responder among the subviews of this view, otherwise return nil
 */
- (UIView *)findFirstResponder;

/**
 * Recursively find and dismiss the active responder, return the active responder found
 */
- (UIView *)findAndResignFirstResponder;


/**
 * Return the center point in the bounds
 */
@property (nonatomic, readonly) CGPoint contentCenter;



#pragma mark - Alignment

/**
 * Align below another view
 */
- (void)alignBelowView:(UIView*)anotherView offsetY:(CGFloat)offsetY sameWidth:(BOOL)sameWidth;

- (void)alignHorizontalCenterToView:(UIView*)anotherView;

- (void)alignVerticallyCenterToView:(UIView*)anotherView;

- (void)extendHeightToBottomOfView:(UIView*)anotherView setAutoResizingMask:(BOOL)autoMask;

- (void)resizeHeightTo:(CGFloat)value keepBottom:(BOOL)keepBottom;
- (void)resizeHeightToParentKeepBottom:(BOOL)keepBottom;
- (void)resizeWidthTo:(CGFloat)value keepRight:(BOOL)keepRight;
- (void)resizeWidthToParentKeepRight:(BOOL)keepRight;

- (void)fitSubviews;

//Mainly for UIScrollView
- (void)autoPushUpAllElements;



//Mainly for UITextField & UITextView
- (void)showHighlightBorder;
- (void)hideHighlightBorder;
- (void)clearHighlightBorder;
- (void)roundCorner;

- (UIImage *)capture;



#pragma mark - Animation

- (void)fadeInWithDuration:(CGFloat)duration;

- (void)fadeOutWithDuration:(CGFloat)duration;

- (void)growAndShrinkOnCompletion:(void (^)(BOOL finished))completion;

@end
