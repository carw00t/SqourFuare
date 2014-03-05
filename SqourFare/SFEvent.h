//
//  SFEvent.h
//  SqourFare
//
//  Created by Tanner Whyte on 2/19/14.
//  Copyright (c) 2014 whyte.tanner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface SFEvent : NSObject

- (instancetype) initWithPFObject:(PFObject *)eventObj;
- (instancetype) initWithEventID:(NSString *)eventID name:(NSString*)name
                            host:(NSString *)hostID date:(NSDate*)date
                           venue:(NSString *)venueID proposedVenues:(NSArray *)proposed
                    invitedUsers:(NSArray *)invited confirmedMembers:(NSArray *)confirmed
                           votes:(NSArray *)votes timeVotes:(NSArray *)timeVotes;

- (void) addTimeVote:(NSDate *)time userID:(NSString *)userID;
- (void) addVote:(NSString *)voteID;
- (void) addVotes:(NSArray *)voteIDs;
- (void) confirmMember:(NSString *)userID;
- (void) inviteUser:(NSString *)userID;
- (void) inviteUsers:(NSArray *)userIDs;
- (void) proposeVenue:(NSString *)venueID;
- (void) proposeVenues:(NSArray *)venueIDs;
- (void) removeUser:(NSString *)userID;
- (void) setVenue:(NSString *)venueID;
- (void) tallyVotes;

- (NSString *) eventID;
- (NSString *) name;
- (NSString *) hostUserID;
- (NSDate *) date;
- (NSString *) venueID;
- (NSArray *) proposedVenues;
- (NSArray *) invited;
- (NSArray *) confirmedMembers;
- (NSArray *) votes;
- (NSArray *) timeVotes;

+ (instancetype) eventWithID:(NSString *)eventID;
+ (instancetype) eventWithName:(NSString *)name date:(NSDate *)date host:(NSString *)hostID;
// TODO(jacob) this should be an initializer
+ (instancetype) createEventWithName:(NSString *)name date:(NSDate *)date host:(NSString *)hostID;


@end
