//
//  SFMapLocation.m
//  SqourFare
//
//  Created by Jacob Van De Weert on 4/30/14.
//  Copyright (c) 2014 whyte.tanner. All rights reserved.
//

#import "SFMapLocation.h"

@interface SFMapLocation ()

@property (strong, nonatomic) NSString *venue;
@property (strong, nonatomic) NSString *category;
@property (assign, nonatomic) CLLocationCoordinate2D location;
@property (strong, nonatomic) NSString *iconPath;

@end

@implementation SFMapLocation

- (instancetype) initWithVenue:(NSString *)venue
                      category:(NSString *)category
                      location:(CLLocationCoordinate2D)location
                          icon:(NSString *)iconPath
{
  if (self = [super init]) {
    self.venue = venue;
    self.category = category;
    self.location = location;
    self.iconPath = iconPath;
  }
  
  return self;
}

- (NSString *)title
{
  return self.venue;
}

- (NSString *)subtitle
{
  return self.category;
}

- (CLLocationCoordinate2D)coordinate
{
  return self.location;
}

- (NSString *)icon
{
  return self.iconPath;
}

@end
