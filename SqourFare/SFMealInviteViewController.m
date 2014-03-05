//
//  SFMealInviteViewController.m
//  SqourFare
//
//  Created by Tanner Whyte on 2/24/14.
//  Copyright (c) 2014 whyte.tanner. All rights reserved.
//

#import "SFMealInviteViewController.h"
#import "SFVenuePickerViewController.h"

typedef enum SFInviteType {
  SFInviteGoing,
  SFInviteInvited
} SFInviteType;

@interface SFMealInviteViewController () <SFVenuePickResponder, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) SFUser *loggedInUser;
@property (strong, nonatomic) NSArray *venueIDs;

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

- (void) userSelectedVenues:(NSArray *)venueIDs
{
  self.venueIDs = venueIDs;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if (section == SFInviteGoing) {
    return [self.event.confirmedMembers count];
  } else if (section == SFInviteInvited) {
    return [self.event.invited count];
  } else {
    NSLog(@"There are more sections than there should be in the SFMealInviteView invited friends table.");
    return 0;
  }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  
  SFUser *user;
  if (indexPath.section == SFInviteGoing) {
    user = [SFUser userWithID:[self.event.confirmedMembers objectAtIndex:indexPath.row]];
  } else {
    user = [SFUser userWithID:[self.event.invited objectAtIndex:indexPath.row]];
  }
  cell.textLabel.text = user.username;
  
  return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  switch (section) {
    case SFInviteGoing:
      return @"Confirmed";
      break;
    case SFInviteInvited:
      return @"Invited";
      break;
    default:
      return @"Error :(";
      break;
  }
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  UIBarButtonItem *voteButton = [[UIBarButtonItem alloc] initWithTitle:@"Vote" style:UIBarButtonItemStylePlain target:self action:@selector(voteForVenues:)];
  self.navigationItem.rightBarButtonItem = voteButton;
  
  self.title = @"Meal Invite";
  
  self.inviteeTableView.dataSource = self;
  self.inviteeTableView.delegate = self;
}

-(void)voteForVenues:(id)sender
{
  SFVenuePickerViewController *venuePicker = [[SFVenuePickerViewController alloc] initWithUser:self.loggedInUser event:self.event];
  venuePicker.venuePickDelegate = self;
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
  // Cast votes for the location
  /*[SFVote newVoteWithUserID:self.loggedInUser.userID eventID:self.event.eventID
                    venueID:[self.venues objectAtIndex:indexPath.row][@"id"]
                   voteType:[NSNumber numberWithInt:1]];
   */
}

- (IBAction)rejectInviteButton:(UIButton *)sender
{
}

@end
