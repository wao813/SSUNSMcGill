//
//  SUViewController.h
//  SSUNS
//
//  Created by James on 2013-06-25.
//  Copyright (c) 2013 James. All rights reserved.
//

@interface SUViewController : UINavigationController <UIGestureRecognizerDelegate> {
    UIViewController *_menuViewController;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController andMenuViewController:(UIViewController *)menuViewController;

- (IBAction)revealMenu;

@end
