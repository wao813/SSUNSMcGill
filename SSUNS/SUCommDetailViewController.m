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
@property (nonatomic,strong)UIToolbar* toolbar;
@property (nonatomic,strong)NSArray* bgUrl;
@end

@implementation SUCommDetailViewController
@synthesize detailDectionary;//href, img, text
@synthesize webView;
@synthesize toolbar;

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
   
    [SUWebParser loadCommittee:[detailDectionary valueForKey:@"href"] withResponse:^(NSDictionary *responseBlock) {
        //bg button first
        self.bgUrl = [responseBlock valueForKey:@"bgUrl"];
        if (self.bgUrl.count==1)
        {
            UIBarButtonItem* bgButton = [[UIBarButtonItem alloc] initWithTitle:@"BG" style:UIBarButtonItemStyleBordered target:self action:@selector(pressBG:)];
            self.navigationItem.rightBarButtonItem = bgButton;
            
            NSLog(@"Add bg done");
        }
        if (self.bgUrl.count==2)
        {
            //some have two bg
            UIBarButtonItem* bgButton1 = [[UIBarButtonItem alloc] initWithTitle:@"BG1" style:UIBarButtonItemStyleBordered target:self action:@selector(pressBG:)];
            UIBarButtonItem* bgButton2 = [[UIBarButtonItem alloc] initWithTitle:@"BG2" style:UIBarButtonItemStyleBordered target:self action:@selector(pressBG2:)];
            NSArray* item_array = [NSArray arrayWithObjects:bgButton2, bgButton1, nil];
            
            self.navigationItem.rightBarButtonItems = item_array;
            
            NSLog(@"Add bg done");
            
        }
        
    } andError:^(NSString *errorBlock) {
        NSLog(@"error loading");
        
    }];
    
    // set up views
    CGRect webFrame = self.view.frame;
    
    webView = [[UIWebView alloc] initWithFrame:webFrame];
    self.view.backgroundColor = [[UIColor alloc] initWithWhite:1.0f alpha:1.0f];
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    webView.scalesPageToFit = YES;
    
    self.view = webView;
    
	// Do any additional setup after loading the view.
    self.title = @"Details";

    SUSpinnerView* spinner = [SUSpinnerView loadSpinnerIntoView:self.view];
    [SUWebParser loadCommittee:[detailDectionary valueForKey:@"href"] withResponse:^(NSDictionary *responseBlock) {
        [spinner removeFromSuperview];
        //title, content
        NSString* htmlString = [[NSString alloc]initWithFormat:@"<body><center><h1 style='margin-top:50px;font-family:Helvetica;font-size:50px;'>%@</h1></center><img border='0' src='%@' height='200px' style='margin-top:50px;margin-left:auto;margin-right:auto;display:block;' /><div style='margin-top:50px;margin-left:20px;margin-right:20px;'><p style='font-family:Helvetica;font-size:40px;text-align:justify;'>%@</p></div></body>",[detailDectionary valueForKey:@"text"], [detailDectionary valueForKey:@"img"],[responseBlock valueForKey:@"content"]];

        [webView loadHTMLString:htmlString baseURL:nil];
        

        } andError:^(NSString *errorBlock) {
            NSLog(@"error");
    }];
}

- (IBAction)pressBG:(id)sender{
    SUBGViewController* bgViewController = [[SUBGViewController alloc]initWithUrlString:[self.bgUrl objectAtIndex:0]];
    [self.navigationController pushViewController:bgViewController animated:YES];
}

- (IBAction)pressBG2:(id)sender{
    SUBGViewController* bgViewController = [[SUBGViewController alloc]initWithUrlString:[self.bgUrl objectAtIndex:1]];
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
