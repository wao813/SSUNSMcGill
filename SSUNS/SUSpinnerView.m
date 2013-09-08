//
//  SUSpinnerView.m
//  SSUNS
//
//  Created by James on 2013-08-21.
//  Copyright (c) 2013 James. All rights reserved.
//

#import "SUSpinnerView.h"
#import <QuartzCore/QuartzCore.h>

@implementation SUSpinnerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+(SUSpinnerView *)loadSpinnerIntoView:(UIView *)superView{
    
    SUSpinnerView *spinnerView = [[SUSpinnerView alloc] initWithFrame:superView.bounds];
    
    if(!spinnerView){
        return nil;
    }
    
    //UIImageView *background = [[UIImageView alloc] initWithImage:[spinnerView addBackground]];
    
    // Make a little bit of the superView show through
    //background.alpha = 0.9;
    
    //[spinnerView addSubview:background];

    
    // This is the new stuff here ;)
    UIActivityIndicatorView *indicator =
    [[UIActivityIndicatorView alloc]
     initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
    
    // Set the resizing mask so it's not stretched
    indicator.autoresizingMask =
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleLeftMargin;
    
    // Place it in the middle of the view
    indicator.center = superView.center;
    
    // Add it into the spinnerView
    [spinnerView addSubview:indicator];
    
    // Start it spinning! Don't miss this step
    [indicator startAnimating];

        
    // Add the spinner view to the superView. Boom.
    [superView addSubview:spinnerView];
    
    // Create a new animation
    CATransition *animation = [CATransition animation];
    
    // Set the type to a nice wee fade
    [animation setType:kCATransitionFade];
    
    // Add it to the superView
    [[superView layer] addAnimation:animation forKey:@"layerAnimation"];
    return spinnerView;
}

-(void)removeSpinner{
    CATransition *animation = [CATransition animation];
    [animation setType:kCATransitionFade];
    [[[self superview] layer] addAnimation:animation forKey:@"layerAnimation"];
    
    [self removeFromSuperview];
}

@end
