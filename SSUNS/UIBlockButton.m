//
//  UIBlockButton.m
//  SSUNS
//
//  Created by James on 2013-08-21.
//  Copyright (c) 2013 James. All rights reserved.
//

#import "UIBlockButton.h"

@implementation UIBlockButton

- (void)handleControlEvent:(UIControlEvents)event withBlock:(ActionBlock)action {
    _actionBlock = action;
    [self addTarget:self action:@selector(callActionBlock:) forControlEvents:event];
}

- (void)callActionBlock:(id)sender{
    _actionBlock();
}

- (void)setClickableAreaExtensionX:(int)x Y:(int)y
{
    leftExt = rightExt = x;
    topExt = bottomExt = y;
}

- (void)setClickableExtensionTop:(int)t bottom:(int)b left:(int)l right:(int)r;
{
    leftExt = l;
    rightExt = r;
    topExt = t;
    bottomExt = b;
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (leftExt+rightExt+topExt+bottomExt != 0 && self.hidden == NO) {
        CGRect largerFrame = CGRectMake(0 - leftExt, 0 - topExt, self.frame.size.width + rightExt, self.frame.size.height + bottomExt);
        return (CGRectContainsPoint(largerFrame, point) == 1) ? self : nil;
    }
    
    return [super hitTest:point withEvent:event];
}

@end

