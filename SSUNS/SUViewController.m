//
//  SUViewController.m
//  SSUNS
//
//  Created by James on 2013-06-25.
//  Copyright (c) 2013 James. All rights reserved.
//

#import "SUViewController.h"
#import <ECSlidingViewController.h>
#import <QuartzCore/QuartzCore.h>

@interface UIView (ViewHierarchy)

- (BOOL)isChildOfClass:(Class)class;

@end

@implementation UIView (ViewHierarchy)

- (BOOL)isChildOfClass:(Class)class {
    if (self.superview) {
        if ([self.superview isKindOfClass:class]) {
            return YES;
        }
        [self.superview isChildOfClass:class];
    }
    return NO;
}

@end

@implementation SUViewController

- (id)initWithRootViewController:(UIViewController *)rootViewController andMenuViewController:(UIViewController *)menuViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        // Nav bar shadow
        self.navigationBar.layer.shadowColor = [[UIColor blackColor] CGColor];
        self.navigationBar.layer.shadowOffset = CGSizeMake(0.0, 2);
        self.navigationBar.layer.shadowOpacity = 0.5;
        self.navigationBar.layer.shouldRasterize = YES;
        
        _menuViewController = menuViewController;
                
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Menu
    if (_menuViewController != nil) {
        // Shadow
        self.view.layer.shadowOpacity = 0.5f;
        self.view.layer.shadowRadius = 5.0f;
        self.view.layer.shadowColor = [UIColor blackColor].CGColor;
        self.view.layer.shadowOffset = CGSizeMake(-2, 0);
        
        // Menu VC
        self.slidingViewController.underLeftViewController = _menuViewController;
        
        // Gesture recognizer
        self.slidingViewController.panGesture.delegate = self;
        [self.view addGestureRecognizer:self.slidingViewController.panGesture];
        
        // Triangle
        UIImageView *triangle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navbar_triangle"]];
        triangle.frame = CGRectMake(-8, 15, 8, 16);
        [self.view addSubview:triangle];
    }
    
}

- (IBAction)revealMenu {
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGPoint location = [touch locationInView:touch.window];
    // Is this a pan gesture?
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        // Is it on the left side of the window?
        if (location.x < 10 ||
            // Is the side nav already showing?
            [self.slidingViewController underLeftShowing] ||
            // Is the view a navbar?
            [touch.view isKindOfClass:[UINavigationBar class]] ||
            // Is it a child element of a navbar?
            [touch.view isChildOfClass:[UINavigationBar class]])
        {
            
            return YES;
        }
        return NO;
    }
    return YES;
}


@end
