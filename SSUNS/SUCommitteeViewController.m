//
//  SUCommitteeViewController.m
//  SSUNS
//
//  Created by James on 2013-08-21.
//  Copyright (c) 2013 James. All rights reserved.
//
#import "SUWebParser.h"
#import "SUCommitteeViewController.h"
#import "SUCommDetailViewController.h"
#import "SUSpinnerView.h"
@interface SUCommitteeViewController ()
@property (nonatomic,strong)NSDictionary* communityList;
@end

@implementation SUCommitteeViewController
@synthesize communityList;//categories ,groups

-(void)processImageDataWithURLString:(NSString *)urlString andBlock:(void (^)(NSData *imageData))processImage
{
    NSURL *url = [NSURL URLWithString:urlString];
    
    dispatch_queue_t callerQueue = dispatch_get_current_queue();
    dispatch_queue_t downloadQueue = dispatch_queue_create("com.ssuns", NULL);
    dispatch_async(downloadQueue, ^{
        NSData * imageData = [NSData dataWithContentsOfURL:url];
        
        dispatch_async(callerQueue, ^{
            processImage(imageData);
        });
    });
//    dispatch_release(downloadQueue);
}


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
    
    self.title = @"Committees";
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    SUSpinnerView* spinner = [SUSpinnerView loadSpinnerIntoView:self.view];

    [SUWebParser loadCommitteesListWithResponse:^(NSDictionary *responseBlock) {
        [spinner removeFromSuperview];

        communityList = responseBlock;
        [self.tableView reloadData];
    } andError:^(NSString *errorBlock) {
        
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
    return [[communityList objectForKey:@"categories"] count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[communityList objectForKey:@"categories"] objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[[communityList objectForKey:@"groups"]objectAtIndex:section]count];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary* dict =[[[communityList objectForKey:@"groups"]objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];

    NSString* text = [dict valueForKey:@"text"];
    // Get a CGSize for the width and, effectively, unlimited height
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    // Get the size of the text given the CGSize we just made as a constraint
    CGSize size = [text sizeWithFont:[UIFont boldSystemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    // Get the height of our measurement, with a minimum of 44 (standard cell size)
    CGFloat height = size.height<40.0f?44.0f:size.height+ (CELL_CONTENT_MARGIN * 2);
    // return the height, with a bit of extra padding in
    return height;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    NSDictionary* dict =[[[communityList objectForKey:@"groups"]objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];

    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.numberOfLines = 5;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:FONT_SIZE];
    cell.textLabel.text = [dict valueForKey:@"text"];
    
//    
//    [self processImageDataWithURLString:[dict objectForKey:@"img"] andBlock:^(NSData *imageData) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (self.view.window) {
//                UIImage* originalImage =[UIImage imageWithData:imageData];
//                CGFloat scale = 50/[originalImage size].width;
//                cell.imageView.image =[UIImage imageWithCIImage:originalImage.CIImage scale:scale orientation:originalImage.imageOrientation];
//                
//            }
//
//        });
//        
//    }];

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dict =[[[communityList objectForKey:@"groups"]objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];

    SUCommDetailViewController* detailViewController = [[SUCommDetailViewController alloc]initWithDictionary:dict];
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
