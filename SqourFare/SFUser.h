//
//  SFUser.h
//  SqourFare
//
//  Created by Tanner Whyte on 2/24/14.
//  Copyright (c) 2014 whyte.tanner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface SFUser : NSObject

// invariant: these fields are always in sync with parse
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSArray *friends;
@property (nonatomic, strong) NSArray *invites;
@property (nonatomic, strong) NSArray *confirmedEvents;

- (id) initWithPFObject:(PFObject *)userObj;
- (id) initWithUserID:(NSString *)userID username:(NSString *)username
              friends:(NSArray *)friends invites:(NSArray *)invites
               events:(NSArray *)events;

- (void) addFriend:(NSString *)userID;
- (void) addFriends:(NSArray *)userIDs;
- (void) confirmEvent:(NSString *)eventID;
- (void) inviteToEvent:(NSString *)eventID;
- (void) removeFriend:(NSString *)userID;
- (void) removeFriends:(NSArray *)userIDs;
- (void) unconfirmEvent:(NSString *)eventID;

+ (SFUser *)signupUserWithUsername:(NSString *)username password:(NSString *)password;
+ (SFUser *)userWithID:(NSString *)userID;
+ (SFUser *)userWithUsername:(NSString *)username password:(NSString *)password;

@end
