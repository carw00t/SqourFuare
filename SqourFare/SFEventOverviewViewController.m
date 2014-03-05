//
//  SFEventOverviewViewController.m
//  SqourFare
//
//  Created by Jacob Van De Weert on 3/4/14.
//  Copyright (c) 2014 whyte.tanner. All rights reserved.
//

#import "SFEventOverviewViewController.h"
#import "SFUser.h"

static NSInteger confirmedSection = 0;
static NSInteger invitedSection = 1;

@interface SFEventOverviewViewController ()

@property (strong, nonatomic) SFEvent *event;

@end

@implementation SFEventOverviewViewController

- (instancetype)initWithEvent:(SFEvent *)event
{
  self = [super init];
  if (self) {
    self.event = event;
//    self.guests = [NSMutableArray arrayWithCapacity:[[guests count]];
//    
//    // TODO(jacob) add a helper method to SFUser to do this already
//    [self.guests enumerateObjectsUsingBlock:^(NSString *userID, NSUInteger idx, BOOL *stop) {
//      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [self.guests replaceObjectAtIndex:idx withObject:[SFUser userWithID:userID]];
//      });
//    }];
    
    if (self.event.venueID == nil) {
      [self.event tallyVotes];
    }
    
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.title = self.event.name;
  
  self.venueLabel.text = self.event.venueID;
  self.dateLabel.text = [self.event.date description];

  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;

  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if (section == confirmedSection)
    return [self.event.confirmedMembers count];
  else if (section == invitedSection)
    return [self.event.invited count];
  else
    return -1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:CellIdentifier];
  }
  
  if (indexPath.section == confirmedSection)
    cell.textLabel.text = [SFUser userWithID:[self.event.confirmedMembers objectAtIndex:indexPath.row]].username;
  else if (indexPath.section == invitedSection)
    cell.textLabel.text = [SFUser userWithID:[self.event.invited objectAtIndex:indexPath.row]].username;
  
  return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  if (section == confirmedSection)
    return @"Confirmed";
  else if (section == invitedSection)
    return @"Also Invited";
  else
    return nil;
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

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];

    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
 
 */

@end
