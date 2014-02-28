//
//  SFVenuePickerViewController.m
//  SqourFare
//
//  Created by Jacob Van De Weert on 2/27/14.
//  Copyright (c) 2014 whyte.tanner. All rights reserved.
//

#import "SFVenuePickerViewController.h"

static NSString * const clientId = @"42SYZZI4H5NZHFFI0UNEGW51INGXKDUUG2OQCDLMRV3IJKHQ";
static NSString * const clientSecret = @"RBHL3IV51VYYGDNJZ2HSS2IFGRPB4AH3QVFXGUU2OCDEAZTV";
static NSString * const foursquareEndpoint = @"https://api.foursquare.com/v2/venues/search";

@interface SFVenuePickerViewController ()

@property (strong, nonatomic) NSArray *venues;

@end

@implementation SFVenuePickerViewController

- (id)initWithStyle:(UITableViewStyle)style
{
  self = [super initWithStyle:style];
  if (self) {
    self.venues = [self getVenues];
  }
  return self;
}

- (NSArray *) getVenues
{
  // Gates
  CLLocationDegrees lat = 40.4437566;
  CLLocationDegrees lng = -79.9444789;
  NSString *endpoint = [NSString stringWithFormat:@"%@?ll=%.5f,%.5f&client_id=%@&client_secret=%@&intent=browse&radius=1000&v=20140227",
                        foursquareEndpoint,
                        lat,
                        lng,
                        clientId,
                        clientSecret];
  
  NSData *result = [NSData dataWithContentsOfURL:[NSURL URLWithString:endpoint]];
  NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
  NSLog(@"results: %@", resultDict);
  
  NSArray *venues = [[resultDict objectForKey:@"response"] objectForKey:@"venues"];
  // TODO(jacob) may eventually want to store more info than just a name
  NSMutableArray *venueNames = [NSMutableArray arrayWithCapacity:venues.count];
  [venues enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
    venueNames[idx] = [dict objectForKey:@"name"];
  }];

  return venueNames;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.title = @"What's good?";
  
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
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [self.venues count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  
  cell.textLabel.text = [self.venues objectAtIndex:indexPath.row];
  
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
