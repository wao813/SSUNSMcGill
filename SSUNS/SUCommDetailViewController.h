//
//  SUCommDetailViewController.h
//  SSUNS
//
//  Created by James on 2013-08-21.
//  Copyright (c) 2013 James. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIAlertView.h>
#import "SUErrorDelegate.h"

@interface SUCommDetailViewController : UIViewController<UIWebViewDelegate>

-(id)initWithDictionary:(NSDictionary*)dict;
- (IBAction)pressBG:(id)sender;
- (IBAction)pressBG2:(id)sender;

@end
