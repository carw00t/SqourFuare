//
//  SFNewEventViewController.h
//  SqourFare
//
//  Created by Tanner Whyte on 2/23/14.
//  Copyright (c) 2014 whyte.tanner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFUser.h"

@interface SFNewEventViewController : UITableViewController
- (id)initWithStyle:(UITableViewStyle)style user:(SFUser *) user;
@property (strong, nonatomic) SFUser *loggedInUser;
@end
