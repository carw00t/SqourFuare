//
//  SFMapLocation.h
//  SqourFare
//
//  Created by Jacob Van De Weert on 4/30/14.
//  Copyright (c) 2014 whyte.tanner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface SFMapLocation : NSObject <MKAnnotation>

- (instancetype) initWithVenue:(NSString *)venue
                       venueID:(NSString *)vid
                      category:(NSString *)category
                      location:(CLLocationCoordinate2D)coordinate
                          icon:(NSString *)icon;

- (NSString *)icon;
- (NSString *)venueID;

@end
