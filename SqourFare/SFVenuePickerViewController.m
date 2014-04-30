//
//  SFVenuePickerViewController.m
//  SqourFare
//
//  Created by Jacob Van De Weert on 2/27/14.
//  Copyright (c) 2014 whyte.tanner. All rights reserved.
//

#import "SFEvent.h"
#import "SFMapLocation.h"
#import "SFUser.h"
#import "SFVote.h"
#import "SFVenuePickerViewController.h"

static NSString * const clientId = @"42SYZZI4H5NZHFFI0UNEGW51INGXKDUUG2OQCDLMRV3IJKHQ";
static NSString * const clientSecret = @"RBHL3IV51VYYGDNJZ2HSS2IFGRPB4AH3QVFXGUU2OCDEAZTV";
static NSString * const foursquareEndpoint = @"https://api.foursquare.com/v2/venues/explore";

@interface SFVenuePickerViewController () <MKMapViewDelegate>

@property (strong, nonatomic) SFEvent *event;
@property (strong, nonatomic) SFUser *loggedInUser;
@property (strong, nonatomic) NSArray *venues;
@property (strong, nonatomic) NSArray *pastVotes;

@end

@implementation SFVenuePickerViewController

- (id)initWithUser:(SFUser *)user event:(SFEvent *)event pastVotes:(NSArray *)pastVotes
{
  self = [super init];
  if (self) {
    self.event = event;
    self.loggedInUser = user;
    self.venues = [self getVenues];
    self.pastVotes = pastVotes;
  }
  return self;
}

//- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
//{
//  MKCoordinateRegion mapRegion;
//  mapRegion.center = mapView.userLocation.coordinate;
//  mapRegion.span.latitudeDelta = 0.2;
//  mapRegion.span.longitudeDelta = 0.2;
//  
//  [mapView setRegion:mapRegion animated:YES];
//  //[mapView setCenterCoordinate:userLocation.coordinate animated:YES];
//}

- (NSArray *) getVenues
{
  // Gates
//  CLLocationDegrees lat = 40.4437566;
//  CLLocationDegrees lng = -79.9444789;
  
// not ready yet
//  CLLocationCoordinate2D loc = self.mapView.userLocation.coordinate;
  
  
  NSString *endpoint = [NSString stringWithFormat:@"%@?ll=%.5f,%.5f&client_id=%@&client_secret=%@&section=food&v=20140227",
                        foursquareEndpoint,
                        // loc.latitude,
                        // loc.longitude,
//                        lat,
//                        lng,
                        self.event.location.latitude,
                        self.event.location.longitude,
                        clientId,
                        clientSecret];
  
  NSData *result = [NSData dataWithContentsOfURL:[NSURL URLWithString:endpoint]];
  NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:result options:0 error:nil];
  
  // this is right. trust me
  NSArray *venues = [[[[resultDict objectForKey:@"response"] objectForKey:@"groups"] objectAtIndex:0] objectForKey:@"items"];
  NSMutableArray *venueDicts = [NSMutableArray arrayWithCapacity:venues.count];
  
  [venues enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
    
    NSMutableDictionary *idxDict = [NSMutableDictionary dictionary];
    NSDictionary *venue = [dict objectForKey:@"venue"];
    NSDictionary *category = [[venue objectForKey:@"categories"] objectAtIndex:0];
    
    idxDict[@"name"] = [venue objectForKey:@"name"];
    idxDict[@"id"] = [venue objectForKey:@"id"];
    idxDict[@"lat"] = [[venue objectForKey:@"location"] objectForKey:@"lat"];
    idxDict[@"lng"] = [[venue objectForKey:@"location"] objectForKey:@"lng"];
    idxDict[@"category"] = [category objectForKey:@"name"];
    idxDict[@"icon"] = [NSString stringWithFormat:@"%@%@", [category objectForKey:@"id"], [[category objectForKey:@"icon"] objectForKey:@"suffix"]];
    
    venueDicts[idx] = idxDict;
  }];

  return venueDicts;
}

- (void) placeVotes:(id)sender
{
  NSArray *indexPaths = [self.venueTable indexPathsForSelectedRows];
  NSMutableArray *venueIDs = [NSMutableArray array];
  
  NSLog(@"Recording votes...");
  for (NSIndexPath *indexPath in indexPaths) {
    [venueIDs addObject:[self.venues objectAtIndex:indexPath.row][@"id"]];
    NSLog(@"%@", [self.venues objectAtIndex:indexPath.row][@"name"]);
  }
  [self.venuePickDelegate userSelectedVenues: venueIDs];
  [self.navigationController popViewControllerAnimated:YES];
}

// TODO(jacob) figure out the map curl-down
//- (void)viewDidAppear:(BOOL)animated
//{
//  [super viewDidAppear:animated];
//  
//  [UIView transitionFromView:self.view
//                      toView:self.mapView
//                    duration:0.5
//                     options:UIViewAnimationOptionTransitionCurlDown
//                  completion:^(BOOL finished) {}];
//}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  UIBarButtonItem *voteButton = [[UIBarButtonItem alloc] initWithTitle:@"Place Votes" style:UIBarButtonItemStylePlain target:self action:@selector(placeVotes:)];
  self.navigationItem.rightBarButtonItem = voteButton;
  self.title = @"Pick some places";
  
  self.mapView.delegate = self;
  self.mapView.showsUserLocation = YES;
  
  for (NSDictionary *venue in self.venues) {
    
    NSNumber *lat = [venue objectForKey:@"lat"];
    NSNumber *lng = [venue objectForKey:@"lng"];
    CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(lat.doubleValue, lng.doubleValue);
    
    SFMapLocation *point = [[SFMapLocation alloc] initWithVenue:[venue objectForKey:@"name"] category:[venue objectForKey:@"category"] location:loc icon:[venue objectForKey:@"icon"]];
    [self.mapView addAnnotation:point];
    
  }
  
  MKCoordinateRegion mapRegion;
  mapRegion.center = self.event.location;
  mapRegion.span.latitudeDelta = 0.2;
  mapRegion.span.longitudeDelta = 0.2;
  [self.mapView setRegion:mapRegion animated:YES];
  
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
  
  if (self.pastVotes.count > 0) {
    // need to check if user voted before to higlight venues
    for (SFVote *vote in self.pastVotes) {
      NSString *venueID = [self.venues objectAtIndex:indexPath.row][@"id"];
      if ([vote.venueID isEqualToString:venueID]) {
        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
      }
    }
  }
  cell.textLabel.text = [self.venues objectAtIndex:indexPath.row][@"name"];
  
  return cell;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
  NSLog(@"view selected");
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
  static NSString *identifier = @"VenueLocation";
  
  if ([annotation isKindOfClass:[SFMapLocation class]]) {
    
    SFMapLocation *anno = (SFMapLocation *)annotation;
    MKAnnotationView *annoView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    if (annoView == nil) {
      
      annoView = [[MKAnnotationView alloc] initWithAnnotation:anno reuseIdentifier:identifier];
      annoView.enabled = YES;
      annoView.canShowCallout = YES;
      annoView.image = [UIImage imageNamed:anno.icon];
      NSLog(@"icon: %@, image: %@", anno.icon, annoView.image);
    }
    else {
      annoView.annotation = anno;
    }
    
    return annoView;
  }
  else {
    return nil;
  }
  
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
