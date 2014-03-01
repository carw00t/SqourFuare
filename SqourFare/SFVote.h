//
//  SFVote.h
//  SqourFare
//
//  Created by Jacob Van De Weert on 2/24/14.
//  Copyright (c) 2014 whyte.tanner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface SFVote : NSObject

- (instancetype) initWithPFObject:(PFObject *)voteObj;
- (instancetype) initWithVoteID:(NSString *)voteID userID:(NSString *)userID
                        eventID:(NSString *)eventID venueID:(NSString *)venueID
                       voteType:(NSNumber *)voteType;

- (NSString *) voteID;
- (NSString *) userID;
- (NSString *) eventID;
- (NSString *) venueID;

// TODO(jacob) parse returns NSNumber, but should really be an enum
- (NSNumber *) voteType;

+ (instancetype) voteWithID:(NSString *)voteID;
+ (instancetype) newVoteWithUserID:(NSString *)userID eventID:(NSString *)eventID
                           venueID:(NSString *)venueID voteType:(NSNumber *)voteType;

@end
