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
@property (nonatomic) NSNumber *voteType;
@property (strong, nonatomic) PFObject *parseObj;

+ (PFQuery *) cachedQueryWithClassName:(NSString *)name;

@end

@implementation SFVote

+ (PFQuery *) cachedQueryWithClassName:(NSString *)name
{
  PFQuery *query = [PFQuery queryWithClassName:name];
  query.cachePolicy = kPFCachePolicyCacheElseNetwork;
  
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
  PFObject *voteObj = [PFObject objectWithClassName:@"Vote"];
  [voteObj setObject:userID forKey:@"userID"];
  [voteObj setObject:eventID forKey:@"eventID"];
  [voteObj setObject:venueID forKey:@"venueID"];
  [voteObj setObject:voteType forKey:@"voteType"];
  
  [voteObj save];
  
  PFQuery *dupCheck = [SFVote cachedQueryWithClassName:@"Vote"];
  [dupCheck whereKey:@"userID" equalTo:userID];
  [dupCheck whereKey:@"eventID" equalTo:eventID];
  [dupCheck whereKey:@"venueID" equalTo:venueID];
  NSArray *votes = [dupCheck findObjects];
  
  if ([votes count] == 0) {
    return nil;
  }
  else if ([votes count] == 1) {
    return [[SFVote alloc] initWithPFObject:votes[0]];
  }
  else {  //duplicates
    PFObject *earliest;
    NSDate *earliestDate;
    
    for (PFObject *vote in votes) {
      if (earliest == nil || [earliestDate compare:vote.createdAt] == NSOrderedAscending) {
        earliest = vote;
        earliestDate = vote.createdAt;
      }
    }
    
    NSMutableArray *muteVotes = [NSMutableArray arrayWithArray:votes];
    [muteVotes removeObjectIdenticalTo:earliest];
    [PFObject deleteAllInBackground:muteVotes];
    
    return nil;
  }
}

+ (void) deleteVotesForUserID: (NSString *)userID eventID: (NSString *)eventID
{
  NSLog(@"Deleting votes for userID %@ eventID %@", userID, eventID);
  PFQuery *query = [SFVote cachedQueryWithClassName:@"Vote"];
  [query whereKey:@"eventID" equalTo:eventID];
  [query whereKey:@"userID" equalTo:userID];
  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    if (!error) {
      for (PFObject *object in objects) {
        NSLog(@"deleting vote");
        [object deleteInBackground];
      }
    } else {
      // Log details of the failure
      NSLog(@"Error: Could not deleteVotesForEventID. %@ %@", error, [error userInfo]);
    }
  }];
}

@end
