//
//  SFDataSource.m
//  SqourFare
//
//  Created by Tanner Whyte on 2/23/14.
//  Copyright (c) 2014 whyte.tanner. All rights reserved.
//

#import "SFDataSource.h"

NSString * const SFGoingEvents = @"Going Events";
NSString * const SFInvitedEvents = @"Invited Events";
NSString * const SFWentEvents = @"Went Events";

@implementation SFDataSource

-(void)reloadData
{
  self.allEvents = [self getEvents];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  SFHomeViewTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCell"];
  if (!cell) {
    cell = [[SFHomeViewTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HomeCell"];
  }
  NSMutableArray *events = [self getEventsForTableGroup: indexPath.section];
  SFEvent *event = [events objectAtIndex:(NSUInteger) indexPath.row];
  
  // Get the dates to display
  NSDateComponents *currComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:[NSDate date]];
  NSInteger currDay = [currComponents day];
  
  NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:event.date];
  NSInteger eventDay = [components day];
  NSInteger eventHour = [components hour];
  NSInteger eventMinute = [components minute];
  
  cell.restaurantNameLabel.text = event.name;
  cell.dayLabel.text = [NSString stringWithFormat:@"+%d", (eventDay - currDay)];
  cell.timeLabel.text = [NSString stringWithFormat:@"%d:%d", eventHour, eventMinute];
  return cell;
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
  return [self.allEvents objectForKey:[self getKeyForSection:groupNum]];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [[self getEventsForTableGroup:section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  [self reloadData];
  return [self.allEvents count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  return [self getKeyForSection:section];
}

@end
