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
@property (strong, nonatomic) NSMutableArray *possibleEventTimes;

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
  
  self.timeChooserOutlet.selectedSegmentIndex = 2;
  
  self.possibleEventTimes = [NSMutableArray array];
  NSInteger timeIncrement = 30;
  for (NSInteger i = -2; i < 3; i++) {
    NSDate *displayDate = [self.event.date dateByAddingTimeInterval:60*timeIncrement*i];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm"];
    NSString *stringFromDate = [dateFormatter stringFromDate:displayDate];
    [self.possibleEventTimes addObject:displayDate];
    [self.timeChooserOutlet setTitle:stringFromDate forSegmentAtIndex:i + 2];
  }
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

- (IBAction)acceptInviteButton:(UIButton *)sender
{
  NSDate *selectedDate = [self.possibleEventTimes objectAtIndex:
                          self.timeChooserOutlet.selectedSegmentIndex];
  NSLog(@"%@", selectedDate);
  NSMutableArray *votes = [NSMutableArray array];
  for (NSString *venueID in self.venueIDs) {
    SFVote *vote = [SFVote newVoteWithUserID:self.loggedInUser.userID eventID:self.event.eventID venueID:venueID voteType:[NSNumber numberWithInt:1]];
    if (vote != nil) {
      [votes addObject:vote.voteID];
    }
  }
  
  [self.event addVotes:votes];
  [self.event addTimeVote:[self.possibleEventTimes objectAtIndex: self.timeChooserOutlet.selectedSegmentIndex] userID:self.loggedInUser.userID];
  [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)rejectInviteButton:(UIButton *)sender
{
  [self.navigationController popViewControllerAnimated:YES];
}

@end
