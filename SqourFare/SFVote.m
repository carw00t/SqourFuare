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

@end

@implementation SFVote

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

@end
