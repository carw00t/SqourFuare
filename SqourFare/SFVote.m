//
//  SFVote.m
//  SqourFare
//
//  Created by Jacob Van De Weert on 2/24/14.
//  Copyright (c) 2014 whyte.tanner. All rights reserved.
//

#import "SFVote.h"

@interface SFVote ()

@property (strong, nonatomic) NSString *voteID;
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *eventID;
@property (strong, nonatomic) NSString *venueID;
@property (strong, nonatomic) NSNumber *voteType;
@property (strong, nonatomic) PFObject *parseObj;

+ (PFQuery *) cachedQueryWithClassName:(NSString *)name;

@end

@implementation SFVote

+ (PFQuery *) cachedQueryWithClassName:(NSString *)name
{
  PFQuery *query = [PFQuery queryWithClassName:name];
  // query.cachePolicy = kPFCachePolicyCacheElseNetwork;
  query.cachePolicy = kPFCachePolicyNetworkElseCache;
  
  return query;
}

- (instancetype) initWithPFObject:(PFObject *)voteObj
{
  
  if (voteObj == nil) {
    return nil;
  }
  
  if (self = [super init]) {
    self.voteID = voteObj.objectId;
    self.userID = voteObj[@"userID"];
    self.eventID = voteObj[@"eventID"];
    self.venueID = voteObj[@"venueID"];
    self.voteType = voteObj[@"voteType"];
    self.parseObj = voteObj;
  }
  
  return self;
}

- (instancetype) initWithVoteID:(NSString *)voteID userID:(NSString *)userID
                        eventID:(NSString *)eventID venueID:(NSString *)venueID
                       voteType:(NSNumber *)voteType
{
  if (self = [super init]) {
    self.voteID = voteID;
    self.userID = userID;
    self.eventID = eventID;
    self.venueID = venueID;
    self.voteType = voteType;
    
    self.parseObj = [PFObject objectWithClassName:@"Vote"];
    self.parseObj.objectId = voteID;
    [self.parseObj setObject:userID forKey:@"userID"];
    [self.parseObj setObject:eventID forKey:@"eventID"];
    [self.parseObj setObject:venueID forKey:@"venueID"];
    [self.parseObj setObject:voteType forKey:@"voteType"];
    
    [self.parseObj saveInBackground];
  }
  
  return self;
}

+ (instancetype) voteWithID:(NSString *)voteID
{
  PFObject *voteObj = [PFQuery getObjectOfClass:@"Vote" objectId:voteID];
  return [[SFVote alloc] initWithPFObject:voteObj];
}

+ (instancetype) newVoteWithUserID:(NSString *)userID eventID:(NSString *)eventID
                           venueID:(NSString *)venueID voteType:(NSNumber *)voteType
{
  
  PFQuery *dupCheck = [SFVote cachedQueryWithClassName:@"Vote"];
  [dupCheck whereKey:@"userID" equalTo:userID];
  [dupCheck whereKey:@"eventID" equalTo:eventID];
  [dupCheck whereKey:@"venueID" equalTo:venueID];
  NSArray *votes = [dupCheck findObjects];
  
  if ([votes count] == 0) {
    
    PFObject *voteObj = [PFObject objectWithClassName:@"Vote"];
    [voteObj setObject:userID forKey:@"userID"];
    [voteObj setObject:eventID forKey:@"eventID"];
    [voteObj setObject:venueID forKey:@"venueID"];
    [voteObj setObject:voteType forKey:@"voteType"];
    
    if ([voteObj save]) {
      return [[SFVote alloc] initWithPFObject:voteObj];
    }
    else {
      return nil;
    }
    
  }
  else {
    return nil;
  }
}

+ (void) deleteVotesForUserID: (NSString *)userID eventID: (NSString *)eventID
{
  NSLog(@"Deleting votes for userID %@ eventID %@", userID, eventID);
  PFQuery *query = [SFVote cachedQueryWithClassName:@"Vote"];
  [query whereKey:@"eventID" equalTo:eventID];
  [query whereKey:@"userID" equalTo:userID];
  NSArray *pfVotes = [query findObjects];
  for (PFObject *pfVote in pfVotes) {
    [pfVote delete];
  }
}

+ (NSArray *) votesForUser:(NSString *)userID Event:(NSString *)eventID
{
  PFQuery *findEvent = [SFVote cachedQueryWithClassName:@"Vote"];
  [findEvent whereKey:@"userID" equalTo:userID];
  [findEvent whereKey:@"eventID" equalTo:eventID];
  
  NSArray *parseVoteObjects = [findEvent findObjects];
  NSMutableArray *votes = [NSMutableArray arrayWithCapacity:parseVoteObjects.count];
  for (PFObject *parseVote in parseVoteObjects) {
    [votes addObject:[[SFVote alloc] initWithPFObject:parseVote]];
  }
  return votes;
}

@end
