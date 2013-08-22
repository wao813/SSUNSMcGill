//
//  UIBlockButton.h
//  SSUNS
//
//  Created by James on 2013-08-21.
//  Copyright (c) 2013 James. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBlockButton : UIButton {
    ActionBlock _actionBlock;
    int leftExt;
    int rightExt;
    int topExt;
    int bottomExt;
}

- (void)setClickableAreaExtensionX:(int)x Y:(int)y;
- (void)setClickableExtensionTop:(int)t bottom:(int)b left:(int)l right:(int)r;
- (void)handleControlEvent:(UIControlEvents)event withBlock:(ActionBlock)action;

@end
