//
//  SFEvent.m
//  SqourFare
//
//  Created by Tanner Whyte on 2/19/14.
//  Copyright (c) 2014 whyte.tanner. All rights reserved.
//

#import "SFEvent.h"

@implementation SFEvent
-(instancetype) initWithName: (NSString*)name date:(NSDate*)date
{
  if (self = [super init]) {
    self.name = name;
    self.date = date;
  }
  return self;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"Event | name : %@ date %@", self.name, self.date];
}
@end
