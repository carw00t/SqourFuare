//
//  SFMealInviteViewController.h
//  SqourFare
//
//  Created by Tanner Whyte on 2/24/14.
//  Copyright (c) 2014 whyte.tanner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFEvent.h"

@interface SFMealInviteViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UITableView *inviteeTableView;
@property (strong, nonatomic) SFEvent *event;

- (IBAction)timeChooser:(UISegmentedControl *)sender;
- (IBAction)acceptInviteButton:(UIButton *)sender;
- (IBAction)rejectInviteButton:(UIButton *)sender;
- (instancetype)initWithEvent:(SFEvent *)event;

@end
