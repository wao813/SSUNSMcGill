//
//  SUMapViewController.m
//  SSUNS
//
//  Created by James on 2013-06-25.
//  Copyright (c) 2013 James. All rights reserved.
//

#import "SUMapViewController.h"
#import "SUWebParser.h"
#import "SUSpinnerView.h"

@interface SUMapViewController ()
@property(nonatomic,strong)UIWebView* webView;
@end

@implementation SUMapViewController
@synthesize webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // Set left nav bar button to menu icon
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem menuButtonWithAction:^{
        [(SUViewController *)self.navigationController revealMenu];
    }];
    
    self.title = @"Maps";
    
    CGRect webFrame = self.view.frame;
    if (![UIApplication sharedApplication].statusBarHidden) {
        CGFloat heightOffset = [UIApplication sharedApplication].statusBarFrame.size.height;
        CGFloat widthOffset = [UIApplication sharedApplication].statusBarFrame.size.width;
        if (widthOffset>heightOffset) {
            webFrame.origin.y -= heightOffset;
        }else{
            webFrame.origin.x -= widthOffset;
        }
    }
    
    webView = [[UIWebView alloc] initWithFrame:webFrame];
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    webView.scalesPageToFit = YES;

    [self.view addSubview:webView];
    
    
    SUSpinnerView* spinner = [SUSpinnerView loadSpinnerIntoView:self.view];
    [SUWebParser loadMapWithResponse:^(NSDictionary *responseBlock) {
        [spinner removeFromSuperview];
        //title, content
        Boolean installed = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]];
        NSString* urlString = nil;
        if (installed)
        {
            urlString = [[NSString alloc]initWithFormat:@"comgooglemaps://?q=%@",[responseBlock valueForKey:@"content"]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }
        else
        {
            urlString = [[NSString alloc]initWithFormat:@"https://maps.google.ca/?q=%@",[responseBlock valueForKey:@"content"]];
            NSLog(urlString);
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }
        [webView loadHTMLString:@"" baseURL:nil];
        
    } andError:^(NSString *errorBlock) {
        NSLog(@"error");
    }];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

/* Fix for landscape + zooming webview bug.
 * If you experience perfomance problems on old devices ratation, comment out this method.
 */
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    CGFloat ratioAspect = webView.bounds.size.width/webView.bounds.size.height;
    switch (toInterfaceOrientation) {
        case UIInterfaceOrientationPortraitUpsideDown:
        case UIInterfaceOrientationPortrait:
            // Going to Portrait mode
            for (UIScrollView *scroll in [webView subviews]) { //we get the scrollview
                // Make sure it really is a scroll view and reset the zoom scale.
                if ([scroll respondsToSelector:@selector(setZoomScale:)]){
                    scroll.minimumZoomScale = scroll.minimumZoomScale/ratioAspect;
                    scroll.maximumZoomScale = scroll.maximumZoomScale/ratioAspect;
                    [scroll setZoomScale:(scroll.zoomScale/ratioAspect) animated:YES];
                }
            }
            break;
        default:
            // Going to Landscape mode
            for (UIScrollView *scroll in [webView subviews]) { //we get the scrollview
                // Make sure it really is a scroll view and reset the zoom scale.
                if ([scroll respondsToSelector:@selector(setZoomScale:)]){
                    scroll.minimumZoomScale = scroll.minimumZoomScale *ratioAspect;
                    scroll.maximumZoomScale = scroll.maximumZoomScale *ratioAspect;
                    [scroll setZoomScale:(scroll.zoomScale*ratioAspect) animated:YES];
                }
            }
            break;
    }
}
@end
