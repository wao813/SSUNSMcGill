//
//  SUScheduleViewController.m
//  SSUNS
//
//  Created by James on 2013-08-21.
//  Copyright (c) 2013 James. All rights reserved.
//

#import "SUScheduleViewController.h"
#import "SUWebParser.h"
#import "SUSpinnerView.h"

@interface SUScheduleViewController ()
@property(nonatomic,strong)NSDictionary* scheduleDict;
@end

@implementation SUScheduleViewController
@synthesize scheduleDict;//days, times

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

    // Set left nav bar button to menu icon
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem menuButtonWithAction:^{
        [(SUViewController *)self.navigationController revealMenu];
    }];
    
    self.title = @"Conference Itinerary";
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    SUSpinnerView* spinner = [SUSpinnerView loadSpinnerIntoView:self.view];
    
    [SUWebParser loadItinerarywithResponse:^(NSDictionary *responseBlock) {
        
        [spinner removeFromSuperview];

        scheduleDict = responseBlock;
        [self.tableView reloadData];
    
    }andError:^(NSString *errorBlock) {
        
    }];
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
    return [[scheduleDict objectForKey:@"days"]count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[scheduleDict objectForKey:@"days"]objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[[scheduleDict objectForKey:@"times"]objectAtIndex:section]count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSString* text = [[[scheduleDict objectForKey:@"times"] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    // Get a CGSize for the width and, effectively, unlimited height
    //CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    // Get the size of the text given the CGSize we just made as a constraint
    //CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    // Get the height of our measurement, with a minimum of 44 (standard cell size)
    //CGFloat height = size.height<40.0f?44.0f:size.height+ (CELL_CONTENT_MARGIN * 2);
    CGFloat height = 50.0f;
    // return the height, with a bit of extra padding in
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.numberOfLines = 5;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:FONT_SIZE];
    NSString *details = [[[scheduleDict objectForKey:@"times"] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    //NSArray *detailsArray = [details componentsSeparatedByString: @":"];
    
    NSString *time = nil;
    NSString *event = nil;
    /*NSError *error = NULL;
    NSRegularExpression *regex_time = [NSRegularExpression regularExpressionWithPattern:@"[0-9]+\\:[0-9]+.*[0-9]+\\:[0-9]+" options:0 error:&error];
    //NSArray *matches_time = [regex_time matchesInString:details options:0 range:NSMakeRange(0, [details length])];
    NSRange matches_time = [regex_time rangeOfFirstMatchInString:details options:0 range:NSMakeRange(0, [details length])];
    if (!NSEqualRanges(matches_time, NSMakeRange(NSNotFound, 0))) {
        NSString *time = [details substringWithRange:matches_time];
    }
    NSRegularExpression *regex_event = [NSRegularExpression regularExpressionWithPattern:@"[^:]+" options:0 error:&error];
    //NSArray *matches_event = [regex_event matchesInString:details options:0 range:NSMakeRange(0, [details length])];
    NSRange matches_event = [regex_event rangeOfFirstMatchInString:details options:0 range:NSMakeRange(0, [details length])];
    if (!NSEqualRanges(matches_event, NSMakeRange(NSNotFound, 0))) {
        NSString *event = [details substringWithRange:matches_event];
    }*/
    //NSString *time = matches_time[0];
    //NSString *event = [matches_event lastObject];
    NSArray *detailArray = [details componentsSeparatedByString: @": "];
    @try{
        time = detailArray[0];
        event = detailArray[1];
        
    }
    @catch (NSException *exception){
        event = @"Error";
    }
    cell.textLabel.text = event;
    cell.detailTextLabel.text = time;
    cell.userInteractionEnabled = NO;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
     
}
/*
-(NSDictionary *)parseItinerarywithData{
    NSArray *dayArray = [NSArray arrayWithObjects: @"Thursday, November 7, 2013", @"Friday, November 8, 2013", @"Saturday, November 9, 2013",
                         @"Sunday, November 10, 2013", nil];
    NSArray *thursday = [NSArray arrayWithObjects: @"14:00 – 15:30,McGill Tours",
                         @"16:00 – 17:30,Model United Nations Training Workshop",
                         @"17:40 – 18:30,SSUNS Walkway",
                         @"18:30 – 19:45,Opening Ceremonies",
                         @"19:45 – 21:00,SSUNS Walkway",
                         @"20:00 – 20:30,Faculty Advisor/Head Delegate Meeting",
                         @"20:30 – 21:30,Committee Session I (except GAs)", nil];
    
    
    NSArray *friday = [NSArray arrayWithObjects: @"09:00 – 12:15,Committee Session II",
                       @"12:15 – 14:00,Lunch",
                       @"13:30 – 14:00,Faculty Advisor/Head Delegate Meeting",
                       @"14:00 – 17:15,Committee Session III",
                       @"14:30 – 16:00,Faculty Advisor Crisis (Mezzanine Level)",
                       @"17:15 – 19:00,Dinner",
                       @"19:00 – 21:15,Committee Session IV", nil];
    
    NSArray *saturday = [NSArray arrayWithObjects: @"09:00 – 12:00,Discover Montreal", @"12:15 – 14:30,Committee Session V",
                         @"14:30 – 15:00,Break", @"14:30 – 15:00,Faculty Advisor/Head Delegate Meeting",
                         @"15:15 – 17:30,Committee Session VI",
                         @"15:30 – 17:00,Curriculum Component Reception",
                         @"18:00 – 21:15,Free Time",
                         @"21:30 – 00:00,SSUNS Gala", nil];
    
    NSArray *sunday = [NSArray arrayWithObjects: @"09:00 – 11:30,Committee Session VII",
                       @"11:45 – 13:15,Lunch",
                       @"13:15 – 14:15,Closing Ceremonies", nil];
    
    NSArray* timeArray = [NSArray arrayWithObjects: thursday, friday, saturday, sunday, nil];
    NSDictionary* retDict = [[NSDictionary alloc]initWithObjectsAndKeys:dayArray,@"days",timeArray,@"times", nil];
    return retDict;
}
*/

@end
