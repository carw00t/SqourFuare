//
//  SFProfileViewController.h
//  SqourFare
//
//  Created by Tanner Whyte on 3/1/14.
//  Copyright (c) 2014 whyte.tanner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFUser.h"

@interface SFProfileViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *friendUsernameField;
@property (strong, nonatomic) IBOutlet UILabel *loggedInUserLabel;
@property (strong, nonatomic) IBOutlet UILabel *addFriendStatus;

- (IBAction)addFriend:(UIButton *)sender;
- (id)initWithUser: (SFUser *)user;
@end
