//
//  SFHomeViewController.h
//  SqourFare
//
//  Created by Tanner Whyte on 2/19/14.
//  Copyright (c) 2014 whyte.tanner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFEvent.h"
#import "SFEventOverviewViewController.h"
#import "SFHomeViewTableCell.h"
#import "SFNewEventViewController.h"
#import "SFMealInviteViewController.h"
#import "SFEvent.h"
#import "SFProfileViewController.h"

@protocol LoginDelegate <NSObject>
- (void)userLoggedIn:(SFUser *)user;
@end

@interface SFHomeViewController : UIViewController <LoginDelegate>

@property (strong, nonatomic) IBOutlet UITableView *homeTableView;
@property (strong, nonatomic) SFUser *loggedInUser;
@end
