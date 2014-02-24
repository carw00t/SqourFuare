//
//  SFMealInviteViewController.h
//  SqourFare
//
//  Created by Tanner Whyte on 2/24/14.
//  Copyright (c) 2014 whyte.tanner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFMealInviteViewController : UIViewController
- (IBAction)timeChooser:(UISegmentedControl *)sender;
- (IBAction)chooseRestaurantButton:(UIButton *)sender;
- (IBAction)acceptInviteButton:(UIButton *)sender;
- (IBAction)rejectInviteButton:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UITableView *inviteeTableView;

@end
