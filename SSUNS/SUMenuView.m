//
//  SUMenuView.m
//  SSUNS
//
//  Created by James on 2013-08-21.
//  Copyright (c) 2013 James. All rights reserved.
//

#import "SUMenuView.h"
#import <ECSlidingViewController.h>
#import "SUViewController.h"
#import "SUWebViewController.h"
@interface SUMenuView ()
@property (nonatomic,strong)NSArray* menuItems;
@end

@implementation SUMenuView
@synthesize menuItems;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // ECSlidingView: make top view visible
    [self.slidingViewController setAnchorRightRevealAmount:280.0f];
    self.slidingViewController.underLeftWidthLayout = ECFullWidth;
    ////
    
    menuItems = @[ @{@"name": @"", @"content": @[
                             @{@"name": @"Twitter", @"viewController": @"twitterWebView"},
                             @{@"name": @"Schedule", @"viewController": @"SUScheduleViewController"},
                             @{@"name": @"Maps", @"viewController": @"SUMapViewController"},
                             @{@"name": @"Committees", @"viewController": @"SUCommitteeViewController"},
                             @{@"name": @"Contact", @"action": @"sendEmail"},
                             @{@"name": @"About", @"viewController": @"SUAboutViewController"}
                             ]}
                   ];

}

-(void)sendEmail{
    
    [self.slidingViewController resetTopView];

    if ([MFMailComposeViewController canSendMail]) {
        // Show the composer
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setSubject:@"SSUNS 2013 Feedback"];
        [controller setMessageBody:@"Hello! \nI have a comment about SSUNS 2013.\n" isHTML:NO];
        [controller setToRecipients:@[@"sg@ssuns.org"]];
        if (controller) [self presentModalViewController:controller animated:YES];
        
    } else {
        // Handle the error
        NSString *url = @"mailto:sg@ssuns.org?subject=SSUNS%202013%20Feedback";
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
    }

}

-(void)displayAbout{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"About" message:@"SSUNS 2013" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [menuItems count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[[menuItems objectAtIndex:section]objectForKey:@"content"]count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    
    NSDictionary* cellConfig = [(NSArray*)[[menuItems objectAtIndex:indexPath.section]objectForKey:@"content"] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [cellConfig valueForKey:@"name"];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)updateActiveViewWithClass:(NSString *)classString {
    id newView;
    if ([classString isEqualToString:@"twitterWebView"]) {
        newView = [[SUWebViewController alloc] initWithUrl:[NSURL URLWithString:@"https://mobile.twitter.com/search?q=%23ssuns&src=typd"] andTitle:@"#SSUNS"];
        
        
    }else if([classString isEqualToString:@"mapWebView"]){
        newView = [[SUWebViewController alloc] initWithUrl:[NSURL URLWithString:@"http://www.ssuns.org/hotel-dir"] andTitle:@"Maps"];
        

    }else if([classString isEqualToString:@"aboutView"]){
        newView = [[SUWebViewController alloc] initWithUrl:[NSURL URLWithString:@"http://www.ssuns.org/static/files/SSUNS-Brochure.pdf"] andTitle:@"SSUNS"];
        
    }else{
        Class viewControllerClass = NSClassFromString(classString);
        newView =[[viewControllerClass alloc]init];
    }
    
    
    if (newView) {
        SUViewController *navController = [[SUViewController alloc] initWithRootViewController:newView andMenuViewController:self];
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = navController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }

}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSDictionary* cellConfig = [(NSArray*)[[menuItems objectAtIndex:indexPath.section]objectForKey:@"content"] objectAtIndex:indexPath.row];
    if([cellConfig valueForKey:@"action"]){
        SEL action = NSSelectorFromString([cellConfig valueForKey:@"action"]);
        [self performSelector:action withObject:nil];
    }else if([[cellConfig valueForKey:@"viewController"] length]>0){
        [self updateActiveViewWithClass:[cellConfig valueForKey:@"viewController"]];
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

}

#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        NSLog(@"It's away!");
    }
    [self dismissModalViewControllerAnimated:YES];
}

@end
