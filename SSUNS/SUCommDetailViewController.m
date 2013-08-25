//
//  SUCommDetailViewController.m
//  SSUNS
//
//  Created by James on 2013-08-21.
//  Copyright (c) 2013 James. All rights reserved.
//

#import "SUCommDetailViewController.h"
#import "SUWebParser.h"
#import "SUSpinnerView.h"
@interface SUCommDetailViewController ()
@property (nonatomic,strong)NSDictionary* detailDectionary;
@property (nonatomic,strong)UIWebView* webView;
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
    CGRect frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height-self.navigationController.navigationBar.frame.size.height);
    
    webView = [[UIWebView alloc] initWithFrame:frame];
    [self.view addSubview:webView];

	// Do any additional setup after loading the view.
    self.title = [detailDectionary valueForKey:@"text"];

    SUSpinnerView* spinner = [SUSpinnerView loadSpinnerIntoView:self.view];
    [SUWebParser loadCommittee:[detailDectionary valueForKey:@"href"] withResponse:^(NSDictionary *responseBlock) {
        [spinner removeFromSuperview];
        //title, content
        NSString* htmlString = [[NSString alloc]initWithFormat:@"<body><img border='0' src='%@' height='100' style='margin-top:50px;margin-left:auto;margin-right:auto;display:block;' /><div style='margin-top:50px;margin-left:20px;margin-right:20px;'><p style='font-family:Helvetica'>'%@'</p></div></body>",[detailDectionary valueForKey:@"img"],[responseBlock valueForKey:@"content"]];
        [webView loadHTMLString:htmlString baseURL:nil];

    } andError:^(NSString *errorBlock) {
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
