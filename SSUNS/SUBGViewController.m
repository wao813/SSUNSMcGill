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
    [self loadCommitteeDictionary];
    self.title = @"Background Guide";
    
    CGRect webFrame = self.view.frame;
    if (![UIApplication sharedApplication].statusBarHidden) {
        webFrame.origin.y -= [UIApplication sharedApplication].statusBarFrame.size.height;
    }
    
    webView = [[UIWebView alloc] initWithFrame:webFrame];
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    webView.scalesPageToFit = YES;
    
    [self.view addSubview:webView];
    
    
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

-(void)loadCommitteeDictionary{
    [SUWebParser loadCommitteesListWithResponse:^(NSDictionary *responseBlock) {
        
        /* here is what it returns
         {
         categories =     (
         "GAs and ECOSOCs",
         "Specialised Agencies",
         Crises
         );
         groups =     (
         (
         {
         href = "http://www.ssuns.org/committees/disec";
         img = "http://www.ssuns.org/static/img/committees/disec.jpg";
         text = "Disarmament and International Security";
         },
         {
         href = "http://www.ssuns.org/committees/fao";
         img = "http://www.ssuns.org/static/img/committees/fao.jpg";
         text = "Food and Agricultural Organization";
         },
         {
         href = "http://www.ssuns.org/committees/wsc";
         img = "http://www.ssuns.org/static/img/committees/wsc.jpg";
         text = "World Summit for Children";
         },
         {
         href = "http://www.ssuns.org/committees/au";
         img = "http://www.ssuns.org/static/img/committees/au.jpg";
         text = "African Union";
         },
         {
         href = "http://www.ssuns.org/committees/igf";
         img = "http://www.ssuns.org/static/img/committees/igf.jpg";
         text = "Internet Governance Forum";
         },
         {
         href = "http://www.ssuns.org/committees/unac";
         img = "http://www.ssuns.org/static/img/committees/unac.jpg";
         text = "United Nations Alliance of Civilizations";
         },
         {
         href = "http://www.ssuns.org/committees/csd";
         img = "http://www.ssuns.org/static/img/committees/csd.jpg";
         text = "Commission for Social Development";
         }
         ),
         (
         {
         href = "http://www.ssuns.org/committees/emirs";
         img = "http://www.ssuns.org/static/img/committees/emirs.jpg";
         text = "Meeting of the Emirs";
         },
         {
         href = "http://www.ssuns.org/committees/epha";
         img = "http://www.ssuns.org/static/img/committees/epha.jpg";
         text = "European Public\tHealth Alliance";
         },
         {
         href = "http://www.ssuns.org/committees/undef";
         img = "http://www.ssuns.org/static/img/committees/undef.jpg";
         text = "UN Democracy Fund";
         },
         {
         href = "http://www.ssuns.org/committees/nfl";
         img = "http://www.ssuns.org/static/img/committees/nfl.jpg";
         text = "National Football\tLeague";
         },
         {
         href = "http://www.ssuns.org/committees/oas";
         img = "http://www.ssuns.org/static/img/committees/oas.jpg";
         text = "Organization of American States";
         },
         {
         href = "http://www.ssuns.org/committees/automobile";
         img = "http://www.ssuns.org/static/img/committees/automobile.jpg";
         text = "Alliance of Automobile Manufacturers \U2013 2008";
         },
         {
         href = "http://www.ssuns.org/committees/tunisian";
         img = "http://www.ssuns.org/static/img/committees/tunisian.jpg";
         text = "Bilingual Committee: Tunisian Uprising";
         },
         {
         href = "http://www.ssuns.org/committees/newspaper";
         img = "http://www.ssuns.org/static/img/committees/newspaper.jpg";
         text = "Newspaper Revolution 2020";
         }
         ),
         (
         {
         href = "http://www.ssuns.org/committees/ad-hoc";
         img = "http://www.ssuns.org/static/img/committees/ad-hoc.jpg";
         text = "Ad-Hoc Committee";
         },
         {
         href = "http://www.ssuns.org/committees/unsc";
         img = "http://www.ssuns.org/static/img/committees/unsc.jpg";
         text = "United Nations Security Council";
         },
         {
         href = "http://www.ssuns.org/committees/robinh";
         img = "http://www.ssuns.org/static/img/committees/robinh.jpg";
         text = "Literary Committee: Robin Hood";
         },
         {
         href = "http://www.ssuns.org/committees/punic";
         img = "http://www.ssuns.org/static/img/committees/punic.jpg";
         text = "Punic Wars";
         },
         {
         href = "http://www.ssuns.org/committees/korean";
         img = "http://www.ssuns.org/static/img/committees/korean.jpg";
         text = "Joint:\tKorean War";
         },
         {
         href = "http://www.ssuns.org/committees/war";
         img = "http://www.ssuns.org/static/img/committees/war.jpg";
         text = "Joint: War of 1812";
         }
         )
         );
         }
         */
        NSMutableDictionary* callBackDict= [[NSMutableDictionary alloc]init];
        NSArray* groups= [responseBlock objectForKey:@"categories"];
        NSArray* committees= [responseBlock objectForKey:@"groups"];
        for(NSDictionary* comm in committees){
            //do what you want for dictionary here then you can call some after parse function after
            
        }
        [self callbackMethod:callBackDict];

    } andError:^(NSString *errorBlock) {
        
    }];
}

-(void)callbackMethod:(NSDictionary*)dict{
    //start to use the dict.
}
@end
