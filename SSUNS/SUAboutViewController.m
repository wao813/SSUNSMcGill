//
//  SUAboutViewController.m
//  SSUNS
//
//  Created by James on 2013-08-21.
//  Copyright (c) 2013 James. All rights reserved.
//

#import "SUAboutViewController.h"

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
    
    NSURL *targetURL = [NSURL URLWithString:@"http://www.ssuns.org/static/files/SSUNS-Brochure.pdf"];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [webView loadRequest:request];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
