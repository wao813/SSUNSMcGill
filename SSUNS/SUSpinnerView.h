//
//  SUSpinnerView.h
//  SSUNS
//
//  Created by James on 2013-08-21.
//  Copyright (c) 2013 James. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SUSpinnerView : UIView

+(SUSpinnerView *)loadSpinnerIntoView:(UIView *)superView;
-(void)removeSpinner;

@end
