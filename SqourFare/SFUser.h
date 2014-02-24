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

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSArray *friends;
@property (nonatomic, strong) NSArray *invites;
@property (nonatomic, strong) NSArray *confirmedEvents;

- (id) initWithPFObject:(PFObject *)userObj;
- (id) initWithUserID:(NSString *)userID username:(NSString *)username
              friends:(NSArray *)friends invites:(NSArray *)invites
               events:(NSArray *)events;

+ (SFUser *)signupUserWithUsername:(NSString *)username password:(NSString *)password;
+ (SFUser *)userWithID:(NSString *)userID;
+ (SFUser *)userWithUsername:(NSString *)username password:(NSString *)password;

@end
