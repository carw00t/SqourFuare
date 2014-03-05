//
//  SFEvent.m
//  SqourFare
//
//  Created by Tanner Whyte on 2/19/14.
//  Copyright (c) 2014 whyte.tanner. All rights reserved.
//

#import "SFEvent.h"
#import <Parse/Parse.h>

NSString * const SFGoingEventName = @"Going Events";
NSString * const SFInvitedEventName = @"Invited Events";
NSString * const SFWentEventName = @"Went Events";

@interface SFEvent ()

@property (strong, nonatomic) NSString *eventID;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *hostUserID;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSString *venueID;
@property (strong, nonatomic) NSArray *proposedVenues;
@property (strong, nonatomic) NSArray *invited;
@property (strong, nonatomic) NSArray *confirmedMembers;
@property (strong, nonatomic) NSArray *votes;
@property (strong, nonatomic) PFObject *parseObj;

@end

@implementation SFEvent

// init with a parse db object for convenience
- (instancetype) initWithPFObject:(PFObject *)eventObj
{
  if (eventObj == nil) {
    return nil;
  }
  
  if (self = [super init]) {
    self.eventID = eventObj.objectId;
    self.name = eventObj[@"name"];
    self.hostUserID = eventObj[@"host"];
    self.date = eventObj[@"date"];
    self.venueID = eventObj[@"venueID"];
    self.proposedVenues = eventObj[@"proposedVenues"];
    self.invited = eventObj[@"invited"];
    self.confirmedMembers = eventObj[@"confirmedMembers"];
    self.votes = eventObj[@"votes"];
    self.parseObj = eventObj;
  }
  
  return self;
}

- (instancetype) initWithEventID:(NSString *)eventID name:(NSString*)name
                            host:(NSString *)hostID date:(NSDate*)date
                           venue:(NSString *)venueID proposedVenues:(NSArray *)proposed
                    invitedUsers:(NSArray *)invited confirmedMembers:(NSArray *)confirmed
                           votes:(NSArray *)votes
{
  if (self = [super init]) {
    self.eventID = eventID;
    self.name = name;
    self.hostUserID = hostID;
    self.date = date;
    self.venueID = venueID;
    self.proposedVenues = proposed;
    self.invited = invited;
    self.confirmedMembers = confirmed;
    self.votes = votes;
    
    self.parseObj = [PFObject objectWithClassName:@"Event"];
    self.parseObj.objectId = eventID;
    [self.parseObj setObject:name forKey:@"name"];
    [self.parseObj setObject:hostID forKey:@"host"];
    [self.parseObj setObject:date forKey:@"date"];
    [self.parseObj setObject:venueID forKey:@"venueID"];
    [self.parseObj setObject:proposed forKey:@"proposedVenues"];
    [self.parseObj setObject:invited forKey:@"invited"];
    [self.parseObj setObject:confirmed forKey:@"confirmedMembers"];
    [self.parseObj setObject:votes forKey:@"votes"];
    
    [self.parseObj saveInBackground];
  }
  
  return self;
}

+ (instancetype) createEventWithName:(NSString *)name date:(NSDate *)date host:(NSString *)hostID
{
  PFObject *eventObj = [PFObject objectWithClassName:@"Event"];
  [eventObj setObject:name forKey:@"name"];
  [eventObj setObject:hostID forKey:@"host"];
  [eventObj setObject:date forKey:@"date"];
  [eventObj setObject:[NSArray array] forKey:@"proposedVenues"];
  [eventObj setObject:[NSArray array] forKey:@"invited"];
  [eventObj setObject:[NSArray array] forKey:@"confirmedMembers"];
  [eventObj setObject:[NSArray array] forKey:@"votes"];
  
  [eventObj save];
  
  PFQuery *dupCheck = [PFQuery queryWithClassName:@"Event"];
  [dupCheck whereKey:@"name" equalTo:name];
  [dupCheck whereKey:@"host" equalTo:hostID];
  [dupCheck whereKey:@"date" equalTo:date];
  NSArray *events = [dupCheck findObjects];
  
  if ([events count] == 0) {
    return nil;
  }
  else if ([events count] == 1) {
    return [[SFEvent alloc] initWithPFObject:events[0]];
  }
  else {  //duplicates
    PFObject *earliest;
    NSDate *earliestDate;
    
    for (PFObject *event in events) {
      if (earliest == nil || [earliestDate compare:event.createdAt] == NSOrderedAscending) {
        earliest = event;
        earliestDate = event.createdAt;
      }
    }
    
    NSMutableArray *muteEvents = [NSMutableArray arrayWithArray:events];
    [muteEvents removeObjectIdenticalTo:earliest];
    [PFObject deleteAllInBackground:muteEvents];
    
    return nil;
  }
}

+ (instancetype) eventWithID:(NSString *)eventID
{
  PFObject *eventObj = [PFQuery getObjectOfClass:@"Event" objectId:eventID];
  return [[SFEvent alloc] initWithPFObject:eventObj];
}

+ (instancetype) eventWithName:(NSString *)name date:(NSDate *)date host:(NSString *)hostID
{
  PFQuery *findEvent = [PFQuery queryWithClassName:@"Event"];
  [findEvent whereKey:@"name" equalTo:name];
  [findEvent whereKey:@"host" equalTo:hostID];
  [findEvent whereKey:@"date" equalTo:date];
  
  PFObject *eventObj = [findEvent getFirstObject];
  return [[SFEvent alloc] initWithPFObject:eventObj];
}

- (void) addVote:(NSString *)voteID
{
  if (![self.votes containsObject:voteID]) {
    self.votes = [self.votes arrayByAddingObject:voteID];
    [self.parseObj addObject:voteID forKey:@"votes"];
    [self.parseObj saveInBackground];
  }
}

- (void) addVotes:(NSArray *)voteIDs {
  // conceptually efficient, if not practically so
  NSArray *updatedVotes = [[NSSet setWithArray:[self.votes arrayByAddingObjectsFromArray:voteIDs]] allObjects];
  
  if ([updatedVotes count] != [self.votes count]) {
    self.votes = updatedVotes;
    [self.parseObj setObject:updatedVotes forKey:@"votes"];
    [self.parseObj saveInBackground];
  }
}

- (void) confirmMember:(NSString *)userID
{
  if ([self.invited containsObject:userID] && ![self.confirmedMembers containsObject:userID]) {
    
    NSMutableArray *muteInvited = [NSMutableArray arrayWithArray:self.invited];
    [muteInvited removeObject:userID];
    self.invited = [NSArray arrayWithArray:muteInvited];
    self.confirmedMembers = [self.confirmedMembers arrayByAddingObject:userID];
    
    [self.parseObj removeObject:userID forKey:@"invited"];
    [self.parseObj addObject:userID forKey:@"confirmedMembers"];
    [self.parseObj saveInBackground];
  }
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"Event | name : %@ date %@", self.name, self.date];
}

- (void) inviteUser:(NSString *)userID
{
  if (![self.confirmedMembers containsObject:userID] && ![self.invited containsObject:userID]) {
    self.invited = [self.invited arrayByAddingObject:userID];
    [self.parseObj addObject:userID forKey:@"invited"];
    [self.parseObj saveInBackground];
  }
}

- (void) inviteUsers:(NSArray *)userIDs
{
  // conceptually efficient, if not practically so
  NSMutableSet *userSet = [NSMutableSet setWithArray:userIDs];
  [userSet minusSet:[NSSet setWithArray:self.confirmedMembers]];
  NSArray *unconfirmed = [userSet allObjects];
  NSArray *updatedInvited = [[NSSet setWithArray:[self.invited arrayByAddingObjectsFromArray:unconfirmed]] allObjects];
  
  if ([updatedInvited count] != [self.invited count]) {
    self.invited = updatedInvited;
    [self.parseObj setObject:updatedInvited forKey:@"invited"];
    [self.parseObj saveInBackground];
  }
}

- (void) proposeVenue:(NSString *)venueID
{
  if (![self.proposedVenues containsObject:venueID]) {
    self.proposedVenues = [self.proposedVenues arrayByAddingObject:venueID];
    [self.parseObj addObject:venueID forKey:@"proposedVenues"];
    [self.parseObj saveInBackground];
  }
}

- (void) proposeVenues:(NSArray *)venueIDs
{
  // conceptually efficient, if not practically so
  NSArray *updatedVenues = [[NSSet setWithArray:[self.proposedVenues arrayByAddingObjectsFromArray:venueIDs]] allObjects];
  
  if ([updatedVenues count] != [self.proposedVenues count]) {
    self.proposedVenues = updatedVenues;
    [self.parseObj setObject:updatedVenues forKey:@"proposedVenues"];
    [self.parseObj saveInBackground];
  }
}

- (void) setVenue:(NSString *)venueID
{
  if (self.venueID != venueID) {
    self.venueID = venueID;
    [self.parseObj setObject:venueID forKey:@"venueID"];
    [self.parseObj saveInBackground];
  }
}

- (void) tallyVotes
{
  PFQuery *voteQuery = [PFQuery queryWithClassName:@"Vote"];
  [voteQuery whereKey:@"eventID" equalTo:self.eventID];
  NSArray *votes = [voteQuery findObjects];
  NSMutableDictionary *venueDict = [NSDictionary init];
  __block int maxVotes = 0;
  __block NSString *maxVenue = nil;
  
  [votes enumerateObjectsUsingBlock:^(PFObject *obj, NSUInteger idx, BOOL *stop) {
    NSString *venueID = [obj objectForKey:@"venueID"];
    NSNumber *voteCount = [venueDict objectForKey:venueID];
    
    if (voteCount == nil) {
      voteCount = [NSNumber numberWithInt:1];
    }
    else {
      voteCount = [NSNumber numberWithInt:([voteCount intValue] + 1)];
    }
    
    [venueDict setObject:voteCount forKey:venueID];
    if ([voteCount intValue] > maxVotes) {
      maxVotes = [voteCount intValue];
      maxVenue = venueID;
    }
  }];
  
  self.venueID = maxVenue;
}

+ (NSString *)getEventNameFromType: (SFEventType) type
{
  NSString *eventsKey;
  switch (type) {
    case SFGoingEvent:
      eventsKey = SFGoingEventName;
      break;
    case 1:
      eventsKey = SFInvitedEventName;
      break;
    case 2:
      eventsKey = SFWentEventName;
      break;
    default:
      eventsKey = @"error";
      break;
  }
  return eventsKey;
}

@end
