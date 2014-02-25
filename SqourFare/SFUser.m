//
//  SFUser.m
//  SqourFare
//
//  Created by Tanner Whyte on 2/24/14.
//  Copyright (c) 2014 whyte.tanner. All rights reserved.
//

#import "SFUser.h"
#import <Parse/Parse.h>

@interface SFUser ()

// invariant: these fields are always in sync with parse
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSArray *friends;
@property (nonatomic, strong) NSArray *invites;
@property (nonatomic, strong) NSArray *confirmedEvents;

@property (nonatomic, strong) PFObject *parseObj;

@end

@implementation SFUser

// init with a parse db object for convenience
- (instancetype) initWithPFObject:(PFObject *)userObj
{
  if (userObj == nil) {
    return nil;
  }
  
  if (self = [super init]) {
    self.userID = userObj.objectId;
    self.username = userObj[@"username"];
    self.friends = userObj[@"friends"];
    self.invites = userObj[@"invites"];
    self.confirmedEvents = userObj[@"confirmedEvents"];
    self.parseObj = userObj;
  }
  
  return self;
}

- (instancetype) initWithUserID:(NSString *)userID username:(NSString *)username
                        friends:(NSArray *)friends invites:(NSArray *)invites
                         events:(NSArray *)events
{
  if (self = [super init]) {
    self.userID = userID;
    self.username = username;
    self.friends = friends;
    self.invites = invites;
    self.confirmedEvents = events;
    
    self.parseObj = [PFObject objectWithClassName:@"User"];
    self.parseObj.objectId = userID;
    [self.parseObj setObject:username forKey:@"username"];
    [self.parseObj setObject:friends forKey:@"friends"];
    [self.parseObj setObject:invites forKey:@"invites"];
    [self.parseObj setObject:events forKey:@"confirmedEvents"];
    
    [self.parseObj saveInBackground];
  }
  
  return self;
}

+ (instancetype) signupUserWithUsername:(NSString *)username
                               password:(NSString *)password
{
  PFObject *signupObj = [PFObject objectWithClassName:@"User"];
  [signupObj setObject:username forKey:@"username"];
  [signupObj setObject:password forKey:@"password"];
  [signupObj setObject:[NSArray array] forKey:@"friends"];
  [signupObj setObject:[NSArray array] forKey:@"invites"];
  [signupObj setObject:[NSArray array] forKey:@"confirmedEvents"];
  
  [signupObj save];
  
  PFQuery *dupCheck = [PFQuery queryWithClassName:@"User"];
  [dupCheck whereKey:@"username" equalTo:username];
  [dupCheck whereKey:@"password" equalTo:password];
  NSArray *users = [dupCheck findObjects];
  
  if ([users count] == 0) {
    return nil;
  }
  else if ([users count] == 1) {
    return [[SFUser alloc] initWithPFObject:users[0]];
  }
  else {  //duplicates
    PFObject *earliest;
    NSDate *earliestDate;
    
    for (PFObject *user in users) {
      if (earliest == nil || [earliestDate compare:user.createdAt] == NSOrderedAscending) {
        earliest = user;
        earliestDate = user.createdAt;
      }
    }
    
    NSMutableArray *muteUsers = [NSMutableArray arrayWithArray:users];
    [muteUsers removeObjectIdenticalTo:earliest];
    [PFObject deleteAllInBackground:muteUsers];
    
    return nil;
  }
}

+ (instancetype) userWithID:(NSString *)userID
{
  PFObject *userObj = [PFQuery getObjectOfClass:@"User" objectId:userID];
  return [[SFUser alloc] initWithPFObject:userObj];
}

+ (instancetype) userWithUsername:(NSString *)username password:(NSString *)password
{
  PFQuery *findUser = [PFQuery queryWithClassName:@"User"];
  [findUser whereKey:@"username" equalTo:username];
  [findUser whereKey:@"password" equalTo:password];
  
  PFObject *userObj = [findUser getFirstObject];
  return [[SFUser alloc] initWithPFObject:userObj];
}

- (void) addFriend:(NSString *)userID
{
  if (![self.friends containsObject:userID]) {
    self.friends = [self.friends arrayByAddingObject:userID];
    [self.parseObj addObject:userID forKey:@"friends"];
    [self.parseObj saveInBackground];
  }
}

- (void) addFriends:(NSArray *)userIDs
{
  // conceptually efficient, if not practically so
  NSArray *updatedFriends = [[NSSet setWithArray:[self.friends arrayByAddingObjectsFromArray:userIDs]] allObjects];
  
  if ([updatedFriends count] != [self.friends count]) {
    self.friends = updatedFriends;
    [self.parseObj setObject:updatedFriends forKey:@"friends"];
    [self.parseObj saveInBackground];
  }
}

- (void) confirmEvent:(NSString *)eventID
{
  if ([self.invites containsObject:eventID] && ![self.confirmedEvents containsObject:eventID]) {
    
    NSMutableArray *muteInvites = [NSMutableArray arrayWithArray:self.invites];
    [muteInvites removeObject:eventID];
    self.invites = [NSArray arrayWithArray:muteInvites];
    self.confirmedEvents = [self.confirmedEvents arrayByAddingObject:eventID];
    
    [self.parseObj removeObject:eventID forKey:@"invites"];
    [self.parseObj addObject:eventID forKey:@"confirmedEvents"];
    [self.parseObj saveInBackground];
  }
}

- (void) inviteToEvent:(NSString *)eventID
{
  if (![self.invites containsObject:eventID]) {
    self.invites = [self.invites arrayByAddingObject:eventID];
    [self.parseObj addObject:eventID forKey:@"invites"];
    [self.parseObj saveInBackground];
  }
}

- (void) removeFriend:(NSString *)userID
{
  if ([self.friends containsObject:userID]) {
    NSMutableArray *muteFriends = [NSMutableArray arrayWithArray:self.friends];
    [muteFriends removeObject:userID];
    self.friends = [NSArray arrayWithArray:muteFriends];
    
    [self.parseObj removeObject:userID forKey:@"friends"];
    [self.parseObj saveInBackground];
  }
}

- (void) removeFriends:(NSArray *)userIDs
{
  NSMutableArray *muteFriends = [NSMutableArray arrayWithArray:self.friends];
  [muteFriends removeObjectsInArray:userIDs];
  
  if ([muteFriends count] != [self.friends count]) {
    self.friends = [NSArray arrayWithArray:muteFriends];
    [self.parseObj removeObjectsInArray:userIDs forKey:@"friends"];
    [self.parseObj saveInBackground];
  }
}

- (void) unconfirmEvent:(NSString *)eventID
{
  if ([self.confirmedEvents containsObject:eventID] && ![self.invites containsObject:eventID]) {
    
    NSMutableArray *muteConfirms = [NSMutableArray arrayWithArray:self.confirmedEvents];
    [muteConfirms removeObject:eventID];
    self.confirmedEvents = [NSArray arrayWithArray:muteConfirms];
    self.invites = [self.invites arrayByAddingObject:eventID];
    
    [self.parseObj removeObject:eventID forKey:@"confirmedEvents"];
    [self.parseObj addObject:eventID forKey:@"invites"];
    [self.parseObj saveInBackground];
  }
}

- (NSArray *) getEventsOfType:(SFEventType) type
{
  NSArray *events;
  switch (type) {
    case SFGoingEvent:
      events = self.confirmedEvents;
      break;
    case SFInvitedEvent:
      events = self.invites;
      break;
    default:
      break;
  }
  return events;
}

@end
