//
//  SFMealInviteViewController.m
//  SqourFare
//
//  Created by Tanner Whyte on 2/24/14.
//  Copyright (c) 2014 whyte.tanner. All rights reserved.
//

#import "SFMealInviteViewController.h"
#import "SFVenuePickerViewController.h"

@interface SFMealInviteViewController ()

@property (strong, nonatomic) SFUser *loggedInUser;

@end

@implementation SFMealInviteViewController

- (id) initWithUser:(SFUser *)user event:(SFEvent *)event
{
  if (self = [super init]) {
    self.event = event;
    self.loggedInUser = user;
  }
  return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
      // Custom initialization
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  UIBarButtonItem *voteButton = [[UIBarButtonItem alloc] initWithTitle:@"Vote" style:UIBarButtonItemStylePlain target:self action:@selector(voteForVenues:)];
  self.navigationItem.rightBarButtonItem = voteButton;
  
  self.title = @"Event Overiew";
}

-(void)voteForVenues:(id)sender
{
  SFVenuePickerViewController *venuePicker = [[SFVenuePickerViewController alloc] initWithUser:self.loggedInUser event:self.event];
  [self.navigationController pushViewController:venuePicker animated:YES];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)timeChooser:(UISegmentedControl *)sender
{
  NSLog(@"selected segments: %ld", (long)[sender selectedSegmentIndex]);
}

- (IBAction)acceptInviteButton:(UIButton *)sender
{
}

- (IBAction)rejectInviteButton:(UIButton *)sender
{
}

@end
