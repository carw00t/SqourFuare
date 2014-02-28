//
//  SFNewEventViewController.h
//  SqourFare
//
//  Created by Tanner Whyte on 2/27/14.
//  Copyright (c) 2014 whyte.tanner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFUser.h"

@interface SFNewEventViewController : UIViewController
@property (strong, nonatomic) SFUser *loggedInUser;
@property (strong, nonatomic) IBOutlet UITableView *friendTableView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UITextField *eventNameField;

- (id)initWithUser: (SFUser *) user;
@end
