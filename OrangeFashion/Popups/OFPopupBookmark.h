//
//  OFPopupBookmark.h
//  OrangeFashion
//
//  Created by Khang on 10/8/13.
//  Copyright (c) 2013 Khang. All rights reserved.
//

#import "OFPopupBaseView.h"

@interface OFPopupBookmark : OFPopupBaseView

@property (weak, nonatomic) IBOutlet TVPickerView *numberPicker;

+ (id)initPopupWithTitle:(NSString *)title
                 message:(NSString *)message
            dismissBlock:(void (^)(OFPopupBookmark *popupView))dismissBlock
            comfirmBlock:(void (^)(OFPopupBookmark *popupView))confirmBlock;

@end
