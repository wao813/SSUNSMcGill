//
//  SUAboutViewController.m
//  SSUNS
//
//  Created by James on 2013-08-21.
//  Copyright (c) 2013 James. All rights reserved.
//

#import "SUAboutViewController.h"
#import "SUSpinnerView.h"
@interface SUAboutViewController ()
@property (nonatomic,strong)UIWebView* webView;
@end

@implementation SUAboutViewController
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
    
    self.title = @"About";
    
    CGRect frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height-self.navigationController.navigationBar.frame.size.height);
    
    webView = [[UIWebView alloc] initWithFrame:frame];
    [self.view addSubview:webView];
    
    
    NSURL *requestUrl = [NSURL URLWithString:@"http://www.ssuns.org/static/files/SSUNS-Brochure.pdf"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestUrl cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60.0];
    
    __block NSCachedURLResponse *cachedURLResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
    
    NSData *responseData;
    
    //check if has cache
    if(cachedURLResponse && cachedURLResponse != (id)[NSNull null])
    {
        NSLog(@"findCache for Itinerary");
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

@end
