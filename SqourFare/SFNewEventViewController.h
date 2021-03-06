//
//  SFNewEventViewController.h
//  SqourFare
//
//  Created by Jacob Van De Weert on 3/5/14.
//  Copyright (c) 2014 whyte.tanner. All rights reserved.
//

#import "SFUser.h"
#import <UIKit/UIKit.h>

@interface SFNewEventViewController : UIViewController

@property (strong, nonatomic) SFUser *loggedInUser;
@property (strong, nonatomic) IBOutlet UITableView *friendTableView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UITextField *eventNameField;

- (id)initWithUser:(SFUser *)user userFriends:(NSArray *)friends;

@end
