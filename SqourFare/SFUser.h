//
//  SFUser.h
//  SqourFare
//
//  Created by Tanner Whyte on 2/24/14.
//  Copyright (c) 2014 whyte.tanner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "SFEvent.h"

@interface SFUser : NSObject

- (instancetype) initWithPFObject:(PFObject *)userObj;
- (instancetype) initWithUserID:(NSString *)userID username:(NSString *)username
              friends:(NSArray *)friends invites:(NSArray *)invites
               events:(NSArray *)events;

- (void) addFriend:(NSString *)userID;
- (void) addFriends:(NSArray *)userIDs;
- (void) confirmEvent:(NSString *)eventID;
- (NSArray *) getFriendsAsObjects;
- (void) inviteToEvent:(NSString *)eventID;
- (void) rejectEvent:(NSString *)eventID;
- (void) removeFriend:(NSString *)userID;
- (void) removeFriends:(NSArray *)userIDs;
- (void) unconfirmEvent:(NSString *)eventID;

- (NSString *) userID;
- (NSString *) username;
- (NSArray *) friends;
- (NSArray *) inviteIDs;
- (NSArray *) confirmedEventIDs;

+ (instancetype) signupUserWithUsername:(NSString *)username password:(NSString *)password;
+ (instancetype) userWithID:(NSString *)userID;
+ (instancetype) userWithUsername:(NSString *)username;
+ (instancetype) userWithUsername:(NSString *)username password:(NSString *)password;
@end
