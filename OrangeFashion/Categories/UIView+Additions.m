#import "UIView+Additions.h"

/**
 * Additions.
 */

@implementation UIView (KNCategory)


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)left {
    return self.frame.origin.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)top {
    return self.frame.origin.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerX {
    return self.center.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerY {
    return self.center.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)width {
    return self.bounds.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)height {
    return self.bounds.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)ttScreenX {
    CGFloat x = 0;
    for (UIView* view = self; view; view = view.superview) {
        x += view.left;
    }
    return x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)ttScreenY {
    CGFloat y = 0;
    for (UIView* view = self; view; view = view.superview) {
        y += view.top;
    }
    return y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)screenViewX {
    CGFloat x = 0;
    for (UIView* view = self; view; view = view.superview) {
        x += view.left;
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            x -= scrollView.contentOffset.x;
        }
    }
    
    return x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)screenViewY {
    CGFloat y = 0;
    for (UIView* view = self; view; view = view.superview) {
        y += view.top;
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            y -= scrollView.contentOffset.y;
        }
    }
    return y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGRect)screenFrame {
    return CGRectMake(self.screenViewX, self.screenViewY, self.width, self.height);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGPoint)origin {
    return self.frame.origin;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGPoint)boundCenter {
    return CGPointMake(self.size.width/2, self.size.height/2);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setBoundCenter:(CGPoint)point {
    //Do nothing
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGSize)size {
    return self.frame.size;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}





///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView *)findFirstResponder
{
    if (self.isFirstResponder)
        return self;
    
    for (UIView *subview in self.subviews) {
        UIView *firstResponder = [subview findFirstResponder];
        
        if (firstResponder != nil)
            return firstResponder;
    }
    
    return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView *)findAndResignFirstResponder;
{
    if (self.isFirstResponder) {
        [self resignFirstResponder];
        return self;
    }
    for (UIView *subView in self.subviews) {
        if ([subView findAndResignFirstResponder])
            return self;
    }
    return NO;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGPoint)contentCenter
{
    return CGPointMake(floorf(self.width/2.0f), floorf(self.height/2.0f));
}


#pragma mark - Alignment

- (void)alignBelowView:(UIView*)anotherView offsetY:(CGFloat)offsetY sameWidth:(BOOL)sameWidth
{
    if (anotherView == nil) {
        DLog(@"WARNING: anotherView is empty. Check IB linking.");
        return;
    }
    
    CGRect frame = self.frame;
    frame.origin.y = CGRectGetMaxY(anotherView.frame) + offsetY;
    if (sameWidth) {
        frame.size.width = CGRectGetWidth(anotherView.frame);
        frame.origin.x = CGRectGetMinX(anotherView.frame);
    }
    self.frame = frame;
}

- (void)alignHorizontalCenterToView:(UIView*)anotherView
{
    if (anotherView == nil) {
        DLog(@"WARNING: anotherView is empty. Check IB linking.");
        return;
    }
    
    if ([anotherView.subviews containsObject:self])
        self.center = CGPointMake(CGRectGetWidth(self.bounds)/2, self.center.y);
    else
        self.center = CGPointMake(anotherView.center.x, self.center.y);
}

- (void)alignVerticallyCenterToView:(UIView*)anotherView
{
    if (anotherView == nil) {
        DLog(@"WARNING: anotherView is empty. Check IB linking.");
        return;
    }
    
    if ([anotherView.subviews containsObject:self])
        self.center = CGPointMake(self.center.x, CGRectGetHeight(self.bounds)/2);
    else
        self.center = CGPointMake(self.center.x, anotherView.center.y);
}

- (void)extendHeightToBottomOfView:(UIView*)anotherView setAutoResizingMask:(BOOL)autoMask
{
    CGRect frame = self.frame;
    frame.size.height = CGRectGetMaxY(anotherView.frame) - CGRectGetMinY(frame);
    if (frame.size.height > 0)
        self.frame = frame;
    
    if (autoMask)
        self.autoresizingMask = self.autoresizingMask | UIViewAutoresizingFlexibleHeight;
}



#pragma mark -

- (void)resizeHeightTo:(CGFloat)value keepBottom:(BOOL)keepBottom
{
    CGRect frame = self.frame;
    CGFloat maxY = CGRectGetMaxY(frame);
    frame.size.height = value;
    if (keepBottom)
        frame.origin.y = maxY - value;
    self.frame = frame;
}

- (void)resizeHeightToParentKeepBottom:(BOOL)keepBottom
{
    [self resizeHeightTo:CGRectGetHeight(self.superview.bounds) keepBottom:keepBottom];
}

- (void)resizeWidthTo:(CGFloat)value keepRight:(BOOL)keepRight
{
    CGRect frame = self.frame;
    CGFloat maxX = CGRectGetMaxX(frame);
    frame.size.width = value;
    if (keepRight)
        frame.origin.x = maxX - value;
    self.frame = frame;
}

- (void)resizeWidthToParentKeepRight:(BOOL)keepRight
{
    [self resizeWidthTo:CGRectGetWidth(self.superview.bounds) keepRight:keepRight];
}

/*
 * Auto adjust self.frame to contain all subviews
 */
- (void)fitSubviews
{
    CGFloat maxY = 0;
    for (UIView *subview in self.subviews)
        if (maxY < CGRectGetMaxY(subview.frame))
            maxY = CGRectGetMaxY(subview.frame);
    maxY += LABEL_SPACING;
    
    //If lesser than current size
    if (maxY <= self.height)
        maxY = self.height;
    
    [self resizeHeightTo:maxY keepBottom:NO];
}

- (void)autoPushUpAllElements
{
    if ([self.subviews count] <= 0)
        return;
    
    //Find the first element
    CGFloat minY = self.height;
    UIView * minView = nil;
    for (UIView *subview in self.subviews)
        if (subview.hidden == NO && subview.alpha > 0)
            if (subview.top < minY) {
                minY = subview.top;
                minView = subview;
            }
    if (minView == nil)
        return;
    
    //How much to shift
    CGFloat delta = minView.origin.y;
    
    //Shift everything
    for (UIView *subview in self.subviews)
        subview.top = subview.top - delta;
}




#pragma mark -

- (void)showHighlightBorder
{
    self.layer.borderColor = [UIColor colorWithRed:28.0f/255.0f green:96.0f/255.0f blue:150.0f/255.0f alpha:1.0f].CGColor;
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 4;
}

- (void)hideHighlightBorder
{
    self.layer.borderColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0f].CGColor;
    self.layer.borderWidth = 0.5f;
    self.layer.cornerRadius = 4;
}

- (void)clearHighlightBorder
{
    self.layer.borderColor = [UIColor clearColor].CGColor;
    self.layer.borderWidth = 0;
    self.layer.cornerRadius = 0;
}

- (void)roundCorner
{
    CGFloat min = MIN(self.frame.size.width,
                      self.frame.size.height);
    
    self.layer.cornerRadius = min / 2;
    self.layer.masksToBounds = YES;
}

- (UIImage *)capture
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}




#pragma mark - Animation

- (void)fadeInWithDuration:(CGFloat)duration
{
    [UIView animateWithDuration:duration animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        self.alpha = 1;
    }];
}

- (void)fadeOutWithDuration:(CGFloat)duration
{
    [UIView animateWithDuration:duration animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.alpha = 0;
    }];
}

- (void)growAndShrinkOnCompletion:(void (^)(BOOL finished))completion
{
    UIView *superview = self.superview;
    if (superview == nil)
        return;
    if (self.hidden || self.alpha <= 0)
        return;
    
    UIImage * selfImage = [self capture];
    UIImageView * imageView = [[UIImageView alloc] initWithImage:selfImage];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.layer.shouldRasterize = YES;
    imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    imageView.frame = self.frame;
    imageView.alpha = self.alpha;
    imageView.hidden = NO;
    [superview addSubview:imageView];
    self.hidden = YES;
    
    CGRect originalFrame = self.frame;
    CGRect enlargedFrame = self.frame;
    enlargedFrame.size.width *= 1.1;
    enlargedFrame.size.height *= 1.1;
    enlargedFrame.origin.x = CGRectGetMidX(originalFrame) - CGRectGetWidth(enlargedFrame)/2;
    enlargedFrame.origin.y = CGRectGetMidY(originalFrame) - CGRectGetHeight(enlargedFrame)/2;
    
    __block UIView * weakSelf = self;
    __block UIImageView * weakImageView = imageView;
    
    [UIView animateWithDuration:0.2 animations:^{
        weakImageView.frame = enlargedFrame;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2 animations:^{
            weakImageView.frame = originalFrame;
            
        } completion:^(BOOL finished) {
            weakSelf.hidden = NO;
            [weakImageView removeFromSuperview];
            weakImageView.image = nil;
            
            if (completion)
                completion(finished);
        }];
    }];
}

@end
