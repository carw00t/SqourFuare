//
//  SFEventOverviewViewController.h
//  SqourFare
//
//  Created by Jacob Van De Weert on 3/5/14.
//  Copyright (c) 2014 whyte.tanner. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "SFEvent.h"
#import <UIKit/UIKit.h>

@interface SFEventOverviewViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *venueLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UITableView *attendingTableView;

- (instancetype)initWithEvent:(SFEvent *)event;

@end
