//
//  SFDataSource.m
//  SqourFare
//
//  Created by Tanner Whyte on 2/23/14.
//  Copyright (c) 2014 whyte.tanner. All rights reserved.
//

#import "SFDataSource.h"
#import "SFUser.h"

NSString * const SFGoingEvents = @"Going Events";
NSString * const SFInvitedEvents = @"Invited Events";
NSString * const SFWentEvents = @"Went Events";

@interface SFDataSource ()
@property (strong, nonatomic) NSMutableArray *users;
@end

@implementation SFDataSource

- (instancetype) init
{
  self = [super init];
  if (self) {
    self.users = [NSMutableArray array];
    SFUser *user1 = [[SFUser alloc] init];
    user1.username = @"Dorufin";
    SFUser *user2 = [[SFUser alloc] init];
    user2.username = @"Whalu";
    [self.users addObject:user1];
    [self.users addObject:user2];
  }
  return self;
}

- (NSMutableDictionary *)getEvents
{
  NSArray *invitedEvents = [NSArray arrayWithObject:[[SFEvent alloc] initWithName:@"Union Grill" date:[NSDate date]]];
  NSArray *goingEvents = [NSArray arrayWithObject:[[SFEvent alloc] initWithName:@"Chipotle" date:[NSDate date]]];
  NSMutableDictionary *allEvents = [[NSMutableDictionary alloc] init];
  [allEvents setValue:invitedEvents forKey:SFInvitedEvents];
  [allEvents setValue:goingEvents forKey:SFGoingEvents];
  [allEvents setValue:[[NSArray alloc] init] forKey:SFWentEvents];
  return allEvents;
}

- (NSMutableArray *)getEventsForTableGroup:(NSInteger) groupNum
{
  return [[self getEvents] objectForKey:[self getKeyForSection:groupNum]];
}

- (NSString *)getKeyForSection: (NSInteger) section
{
  NSString *eventsKey;
  switch (section) {
    case 0:
      eventsKey = SFGoingEvents;
      break;
    case 1:
      eventsKey = SFInvitedEvents;
      break;
    case 2:
      eventsKey = SFWentEvents;
      break;
    default:
      eventsKey = @"error";
      break;
  }
  return eventsKey;
}

- (NSMutableArray *)getUsers
{
  return self.users;
}

@end
