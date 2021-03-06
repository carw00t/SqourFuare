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
@property (nonatomic, strong) NSArray *inviteIDs;
@property (nonatomic, strong) NSArray *confirmedEventIDs;

@property (nonatomic, strong) PFObject *parseObj;

+ (PFQuery *) cachedQueryWithClassName:(NSString *)name;

@end

@implementation SFUser

+ (PFQuery *) cachedQueryWithClassName:(NSString *)name
{
  PFQuery *query = [PFQuery queryWithClassName:name];
  // query.cachePolicy = kPFCachePolicyCacheElseNetwork;
  query.cachePolicy = kPFCachePolicyNetworkElseCache;
  
  return query;
}

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
    self.inviteIDs = userObj[@"invites"];
    self.confirmedEventIDs = userObj[@"confirmedEvents"];
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
    self.inviteIDs = invites;
    self.confirmedEventIDs = events;
    
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
  PFQuery *dupCheck = [SFUser cachedQueryWithClassName:@"User"];
  [dupCheck whereKey:@"username" equalTo:username];
  [dupCheck whereKey:@"password" equalTo:password];
  NSArray *users = [dupCheck findObjects];

  if ([users count] == 0) {
    PFObject *signupObj = [PFObject objectWithClassName:@"User"];
    [signupObj setObject:username forKey:@"username"];
    [signupObj setObject:password forKey:@"password"];
    [signupObj setObject:[NSArray array] forKey:@"friends"];
    [signupObj setObject:[NSArray array] forKey:@"invites"];
    [signupObj setObject:[NSArray array] forKey:@"confirmedEvents"];
    
    if ([signupObj save]) {
      return [[SFUser alloc] initWithPFObject:signupObj];
    }
    else {
      return nil;
    }
  }
  else {
    return nil;
  }
}

+ (instancetype) userWithID:(NSString *)userID
{
  PFObject *userObj = [PFQuery getObjectOfClass:@"User" objectId:userID];
  return [[SFUser alloc] initWithPFObject:userObj];
}

+ (instancetype) userWithUsername:(NSString *)username
{
  PFQuery *findUser = [SFUser cachedQueryWithClassName:@"User"];
  [findUser whereKey:@"username" equalTo:username];
  
  PFObject *userObj = [findUser getFirstObject];
  return [[SFUser alloc] initWithPFObject:userObj];
}

+ (instancetype) userWithUsername:(NSString *)username password:(NSString *)password
{
  PFQuery *findUser = [SFUser cachedQueryWithClassName:@"User"];
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
  if ([self.inviteIDs containsObject:eventID] && ![self.confirmedEventIDs containsObject:eventID]) {
    
    NSMutableArray *muteInvites = [NSMutableArray arrayWithArray:self.inviteIDs];
    [muteInvites removeObject:eventID];
    self.inviteIDs = [NSArray arrayWithArray:muteInvites];
    self.confirmedEventIDs = [self.confirmedEventIDs arrayByAddingObject:eventID];
    
    [self.parseObj removeObject:eventID forKey:@"invites"];
    [self.parseObj addObject:eventID forKey:@"confirmedEvents"];
    [self.parseObj saveInBackground];
  }
}

- (NSArray *) getFriendsAsObjects
{
  PFQuery *friendQuery = [SFUser cachedQueryWithClassName:@"User"];
  [friendQuery whereKey:@"objectId" containedIn:self.friends];
  NSArray *friendPFObjects = [friendQuery findObjects];
  
  NSMutableArray *friendUsers = [NSMutableArray arrayWithCapacity:[friendPFObjects count]];
  [friendPFObjects enumerateObjectsUsingBlock:^(PFObject *obj, NSUInteger idx, BOOL *stop) {
    friendUsers[idx] = [[SFUser alloc] initWithPFObject:obj];
  }];
  
  return friendUsers;
}

- (void) inviteToEvent:(NSString *)eventID
{
  if (![self.inviteIDs containsObject:eventID]) {
    self.inviteIDs = [self.inviteIDs arrayByAddingObject:eventID];
    [self.parseObj addObject:eventID forKey:@"invites"];
    [self.parseObj saveInBackground];
  }
}

- (void) rejectEvent:(NSString *)eventID
{
  if ([self.inviteIDs containsObject:eventID]) {
    NSMutableArray *muteInvites = [NSMutableArray arrayWithArray:self.inviteIDs];
    [muteInvites removeObject:eventID];
    self.inviteIDs = [NSArray arrayWithArray:muteInvites];
    
    [self.parseObj removeObject:eventID forKey:@"invites"];
  }
  else if ([self.confirmedEventIDs containsObject:eventID]) {
    NSMutableArray *muteConfirms = [NSMutableArray arrayWithArray:self.confirmedEventIDs];
    [muteConfirms removeObject:eventID];
    self.confirmedEventIDs = [NSArray arrayWithArray:muteConfirms];
    
    [self.parseObj removeObject:eventID forKey:@"confirmedEvents"];
  }
  
  [self.parseObj saveInBackground];
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
  if ([self.confirmedEventIDs containsObject:eventID] && ![self.inviteIDs containsObject:eventID]) {
    
    NSMutableArray *muteConfirms = [NSMutableArray arrayWithArray:self.confirmedEventIDs];
    [muteConfirms removeObject:eventID];
    self.confirmedEventIDs = [NSArray arrayWithArray:muteConfirms];
    self.inviteIDs = [self.inviteIDs arrayByAddingObject:eventID];
    
    [self.parseObj removeObject:eventID forKey:@"confirmedEvents"];
    [self.parseObj addObject:eventID forKey:@"invites"];
    [self.parseObj saveInBackground];
  }
}

@end
