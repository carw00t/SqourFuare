//
//  SFUser.m
//  SqourFare
//
//  Created by Tanner Whyte on 2/24/14.
//  Copyright (c) 2014 whyte.tanner. All rights reserved.
//

#import "SFUser.h"
#import <Parse/Parse.h>

@implementation SFUser

// init with a parse db object for convenience
- (id) initWithPFObject:(PFObject *)userObj
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
  }
  
  return self;
}

- (id) initWithUserID:(NSString *)userID username:(NSString *)username
              friends:(NSArray *)friends invites:(NSArray *)invites
               events:(NSArray *)events
{
  if (self = [super init]) {
    self.username = username;
    self.userID = nil;
    self.friends = friends;
    self.invites = invites;
    self.confirmedEvents = events;
  }
  
  return self;
}

+ (SFUser *) signupUserWithUsername:(NSString *)username password:(NSString *)password
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
  else {  //duplicate
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

+ (SFUser *) userWithID:(NSString *)userID
{
  PFObject *userObj = [PFQuery getObjectOfClass:@"User" objectId:userID];
  return [[SFUser alloc] initWithPFObject:userObj];
}

+ (SFUser *) userWithUsername:(NSString *)username password:(NSString *)password
{
  PFQuery *findUser = [PFQuery queryWithClassName:@"User"];
  [findUser whereKey:@"username" equalTo:username];
  [findUser whereKey:@"password" equalTo:password];
  
  PFObject *userObj = [findUser getFirstObject];
  return [[SFUser alloc] initWithPFObject:userObj];
}

@end
