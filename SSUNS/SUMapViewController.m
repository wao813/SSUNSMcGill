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
    
    CGRect frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height-self.navigationController.navigationBar.frame.size.height);
    
    webView = [[UIWebView alloc] initWithFrame:frame];
    [self.view addSubview:webView];
    
    
    SUSpinnerView* spinner = [SUSpinnerView loadSpinnerIntoView:self.view];
    [SUWebParser loadMapWithResponse:^(NSDictionary *responseBlock) {
        [spinner removeFromSuperview];
        //title, content
        NSString* htmlString = [[NSString alloc]initWithFormat:@"%@",[responseBlock valueForKey:@"content"]];
        [webView loadHTMLString:htmlString baseURL:nil];

    } andError:^(NSString *errorBlock) {
        
    }];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//
//- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
//    CGFloat ratioAspect = webView.bounds.size.width/webView.bounds.size.height;
//
//    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
//    CGFloat staBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
//    [webView setFrame:CGRectMake(0, 0, self.view.frame.size.height+navBarHeight+staBarHeight, self.view.frame.size.width-navBarHeight)];
//
//    switch (toInterfaceOrientation) {
//        case UIInterfaceOrientationPortraitUpsideDown:
//        case UIInterfaceOrientationPortrait:
//            // Going to Portrait mode
//            for (UIScrollView *scroll in [webView subviews]) { //we get the scrollview
//                // Make sure it really is a scroll view and reset the zoom scale.
//                if ([scroll respondsToSelector:@selector(setZoomScale:)]){
//                    scroll.minimumZoomScale = scroll.minimumZoomScale/ratioAspect;
//                    scroll.maximumZoomScale = scroll.maximumZoomScale/ratioAspect;
//                    [scroll setZoomScale:(scroll.zoomScale/ratioAspect) animated:YES];
//                }
//            }
//
//            break;
//        default:
//            // Going to Landscape mode
//            for (UIScrollView *scroll in [webView subviews]) { //we get the scrollview
//                // Make sure it really is a scroll view and reset the zoom scale.
//                if ([scroll respondsToSelector:@selector(setZoomScale:)]){
//                    scroll.minimumZoomScale = scroll.minimumZoomScale *ratioAspect;
//                    scroll.maximumZoomScale = scroll.maximumZoomScale *ratioAspect;
//                    [scroll setZoomScale:(scroll.zoomScale*ratioAspect) animated:YES];
//                }
//            }
//
//            break;
//    }
//}
//
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    // Return YES for supported orientations
//    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
//}
//
//
@end
