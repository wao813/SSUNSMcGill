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
#import "SUErrorDelegate.h"

@interface SUScheduleViewController ()
@property(nonatomic,strong)NSDictionary* scheduleDict;
@property(nonatomic,strong)SUErrorDelegate *errorDel;
@end

@implementation SUScheduleViewController
@synthesize scheduleDict;//days, times
@synthesize errorDel;

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
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Network Error" message:@"Internet connection timed out!" delegate:errorDel cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
    [SUWebParser loadItinerarywithResponse:^(NSDictionary *responseBlock) {
        
        if(responseBlock!=nil)
        {
        
            [spinner removeFromSuperview];

            scheduleDict = responseBlock;
            [self.tableView reloadData];
        }
        else
        {
            [spinner removeFromSuperview];
            self.view.backgroundColor = [[UIColor alloc] initWithWhite:1.0f alpha:1.0f];
            [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];

        }
    
    }andError:^() {
        NSLog(@"error");
        [spinner removeFromSuperview];
        self.view.backgroundColor = [[UIColor alloc] initWithWhite:1.0f alpha:1.0f];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];

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
    int count = 0;
    NSArray *arr = [[scheduleDict objectForKey:@"times"]objectAtIndex:section];
    for (NSString *details in arr)
    {
        NSArray *detailArray = [details componentsSeparatedByString: @": "];
        if (detailArray.count>1) count++;
    }
    
    //return [[[scheduleDict objectForKey:@"times"]objectAtIndex:section]count];
    return count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* text = [[[scheduleDict objectForKey:@"times"] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    // Get a CGSize for the width and, effectively, unlimited height
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 100000.0f);
    // Get the size of the text given the CGSize we just made as a constraint
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    // Get the height of our measurement, with a minimum of 44 (standard cell size)
    CGFloat height = 60.0f;
    if (size.height<44.0f) height = 40.0f + (CELL_CONTENT_MARGIN * 1.8);
    
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

    NSArray *detailArray = [details componentsSeparatedByString: @": "];
    @try{
        time = detailArray[0];
        event = detailArray[1];
    }
    @catch (NSException *exception){
        event = @"None";
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
@end
