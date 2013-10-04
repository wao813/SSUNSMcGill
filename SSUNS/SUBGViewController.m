//
//  SUBGViewController.m
//  SSUNS
//
//  Created by Lucille Hua on 2013-09-12.
//  Copyright (c) 2013 James. All rights reserved.
//

#import "SUBGViewController.h"
#import "SUSpinnerView.h"
#import "SUWebParser.h"
@interface SUBGViewController ()
@property (nonatomic,strong)UIWebView *webView;
@property(nonatomic, strong) NSURL *requestUrl;
@end

@implementation SUBGViewController
@synthesize webView;
@synthesize requestUrl;

- (id)initWithUrlString:(NSString *)url
{
    self = [super init];
    if (self) {
        self.requestUrl = [[NSURL alloc]initWithString:url];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // Set left nav bar button to menu icon
    self.title = @"Background Guide";
    
    CGRect webFrame = self.view.frame;
    
    webView = [[UIWebView alloc] initWithFrame:webFrame];
    self.view.backgroundColor = [[UIColor alloc] initWithWhite:1.0f alpha:1.0f];
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    webView.scalesPageToFit = YES;
    
    self.view = webView;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.requestUrl cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60.0];
    
    __block NSCachedURLResponse *cachedURLResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
    
    NSData *responseData;
    
    //check if has cache
    if(cachedURLResponse && cachedURLResponse != (id)[NSNull null])
    {
        NSLog(@"findCache for BG");
        responseData = [cachedURLResponse data];
        
        [webView loadData:responseData MIMEType:@"application/pdf" textEncodingName:@"UTF-8" baseURL:nil];
        
    }
    else //if no cache get it from the server.
    {
        SUSpinnerView* spinnerView = [SUSpinnerView loadSpinnerIntoView:self.view];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            [spinnerView removeFromSuperview];
            [webView loadData:data MIMEType:@"application/pdf" textEncodingName:@"UTF-8" baseURL:nil];
            
            //cache received data
            cachedURLResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:data userInfo:nil storagePolicy:NSURLCacheStorageAllowed];
            //store in cache
            [[NSURLCache sharedURLCache] storeCachedResponse:cachedURLResponse forRequest:request];
            
        }];
    }
    
    
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
