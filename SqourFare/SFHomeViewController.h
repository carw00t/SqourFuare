//
//  SFHomeViewController.h
//  SqourFare
//
//  Created by Tanner Whyte on 2/19/14.
//  Copyright (c) 2014 whyte.tanner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFDataSource.h"
#import "SFEvent.h"
#import "SFHomeViewTableCell.h"
#import "SFNewEventViewController.h"
#import "SFMealInviteViewController.h"

@protocol LoginDelegate <NSObject>
- (void)userLoggedIn:(SFUser *)user;
- (id)initWithDataSource: (SFDataSource*) dataSource;
@end

@interface SFHomeViewController : UIViewController <LoginDelegate>
@property (strong, nonatomic) IBOutlet UITableView *homeTableView;
@property (strong, nonatomic) SFUser *loggedInUser;
@end
