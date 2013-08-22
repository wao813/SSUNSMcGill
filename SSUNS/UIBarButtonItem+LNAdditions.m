//
//  UIBarButtonItem+LNAdditions.m
//  SSUNS
//
//  Created by James on 2013-08-21.
//  Copyright (c) 2013 James. All rights reserved.
//

#import "UIBarButtonItem+LNAdditions.h"
#import "UIBlockButton.h"

@implementation UIBarButtonItem (LNAdditions)


+ (UIBarButtonItem *)buttonWithName:(NSString *)name inactiveImage:(UIImage *)inactiveImage activeImage:(UIImage *)activeImage andAction:(ActionBlock)action {
    
    UIBlockButton *button = [[UIBlockButton alloc] initWithFrame:CGRectMake(0, 0, inactiveImage.size.width, inactiveImage.size.height)];
    
    [button setBackgroundImage:inactiveImage forState:UIControlStateNormal];
    [button setBackgroundImage:activeImage forState:UIControlStateHighlighted];
    
    [button handleControlEvent:UIControlEventTouchUpInside withBlock:action];
    
    UIBarButtonItem *navButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    navButton.accessibilityLabel = [NSString stringWithFormat:@"%@ Button", name];
    return navButton;
}

+ (UIBarButtonItem *)menuButtonWithAction:(ActionBlock)action {
    return [UIBarButtonItem buttonWithName:@"Menu"
                             inactiveImage:[UIImage imageNamed:@"13-target"]
                               activeImage:[UIImage imageNamed:@"13-target"]
                                 andAction:action
            ];
}

@end
