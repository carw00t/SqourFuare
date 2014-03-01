//
//  SFVenuePickerViewController.h
//  SqourFare
//
//  Created by Jacob Van De Weert on 2/27/14.
//  Copyright (c) 2014 whyte.tanner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface SFVenuePickerViewController : UITableViewController

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UITableView *venueTable;

- (id)initWithUser:(SFUser *)user event:(SFEvent *)event;

@end