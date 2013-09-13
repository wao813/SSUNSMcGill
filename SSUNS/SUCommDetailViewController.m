//
//  SUCommDetailViewController.m
//  SSUNS
//
//  Created by James on 2013-08-21.
//  Copyright (c) 2013 James. All rights reserved.
//

#import "SUCommDetailViewController.h"
#import "SUWebParser.h"
#import "SUWebViewController.h"
#import "SUSpinnerView.h"
#import "SUBGViewController.h"

@interface SUCommDetailViewController ()
@property (nonatomic,strong)NSDictionary* detailDectionary;
@property (nonatomic,strong)UIWebView* webView;
@property (nonatomic,strong)NSURL* bgUrl;
@end

@implementation SUCommDetailViewController
@synthesize detailDectionary;//href, img, text
@synthesize webView;

-(id)initWithDictionary:(NSDictionary*)dict{
    self = [super init];
    if (self) {
        detailDectionary = [[NSDictionary alloc]initWithDictionary:dict];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem* bgButton = [[UIBarButtonItem alloc] initWithTitle:@"BG" style:UIBarButtonItemStyleBordered target:self action:@selector(pressBG:)];
    self.navigationItem.rightBarButtonItem = bgButton;

    
    CGRect webFrame = self.view.frame;
    if (![UIApplication sharedApplication].statusBarHidden) {
        webFrame.origin.y -= [UIApplication sharedApplication].statusBarFrame.size.height;
    }
    
    webView = [[UIWebView alloc] initWithFrame:webFrame];
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    webView.scalesPageToFit = YES;
    
    [self.view addSubview:webView];

	// Do any additional setup after loading the view.
    self.title = [detailDectionary valueForKey:@"text"];

    SUSpinnerView* spinner = [SUSpinnerView loadSpinnerIntoView:self.view];
    [SUWebParser loadCommittee:[detailDectionary valueForKey:@"href"] withResponse:^(NSDictionary *responseBlock) {
        [spinner removeFromSuperview];
        //title, content
        NSString* htmlString = [[NSString alloc]initWithFormat:@"<body><img border='0' src='%@' height='200px' style='margin-top:50px;margin-left:auto;margin-right:auto;display:block;' /><div style='margin-top:50px;margin-left:20px;margin-right:20px;'><p style='font-family:Helvetica;font-size:50px;text-align:justify;'>%@</p></div></body>",[detailDectionary valueForKey:@"img"],[responseBlock valueForKey:@"content"]];
        //self.bgUrl = [NSURL URLWithString:[responseBlock valueForKey:@"bgUrl"]];
        [webView loadHTMLString:htmlString baseURL:nil];
//        [webView setDelegate:self];


    } andError:^(NSString *errorBlock) {
        
    }];
}

- (IBAction)pressBG:(id)sender {
    SUBGViewController* bgViewController = [[SUBGViewController alloc]initWithUrlString:@"http://www.ssuns.org/static/files/SSUNS-Brochure.pdf"];
    
   // SUWebViewController *bgViewController = [[SUWebViewController alloc] initWithUrl:[NSURL URLWithString:@"http://www.ssuns.org/static/files/SSUNS-Brochure.pdf"] andTitle:@"SSUNS"];
    [self.navigationController pushViewController:bgViewController animated:YES];
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
