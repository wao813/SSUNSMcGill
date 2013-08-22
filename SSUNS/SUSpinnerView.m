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

- (UIImage *)addBackground{
    // Create an image context (think of this as a canvas for our masterpiece) the same size as the view
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 1);
    
    // Our gradient only has two locations - start and finish. More complex gradients might have more colours
    size_t num_locations = 2;
    
    // The location of the colors is at the start and end
    CGFloat locations[2] = { 0.0, 1.0 };
    
    // These are the colors! That's two RBGA values
    CGFloat components[8] = {
        0.4,0.4,0.4, 0.8,
        0.1,0.1,0.1, 0.5 };
    
    // Create a color space
    CGColorSpaceRef myColorspace = CGColorSpaceCreateDeviceRGB();
    
    // Create a gradient with the values we've set up
    CGGradientRef myGradient = CGGradientCreateWithColorComponents (myColorspace, components, locations, num_locations);
    
    // Set the radius to a nice size, 80% of the width. You can adjust this
    float myRadius = (self.bounds.size.width*.8)/2;
    
    // Now we draw the gradient into the context. Think painting onto the canvas
    CGContextDrawRadialGradient (UIGraphicsGetCurrentContext(), myGradient, self.center, 0, self.center, myRadius, kCGGradientDrawsAfterEndLocation);
    
    // Rip the 'canvas' into a UIImage object
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // And release memory
    CGColorSpaceRelease(myColorspace);
    CGGradientRelease(myGradient);
    UIGraphicsEndImageContext();
    
    // … obvious.
    return image;
}

+(SUSpinnerView *)loadSpinnerIntoView:(UIView *)superView{
    
    SUSpinnerView *spinnerView = [[SUSpinnerView alloc] initWithFrame:superView.bounds];
    
    if(!spinnerView){
        return nil;
    }
    
    UIImageView *background = [[UIImageView alloc] initWithImage:[spinnerView addBackground]];
    
    // Make a little bit of the superView show through
    background.alpha = 0.7;
    
    [spinnerView addSubview:background];

    
    // This is the new stuff here ;)
    UIActivityIndicatorView *indicator =
    [[UIActivityIndicatorView alloc]
     initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
    
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
