//
//  SFHomeViewController.m
//  SqourFare
//
//  Created by Tanner Whyte on 2/19/14.
//  Copyright (c) 2014 whyte.tanner. All rights reserved.
//

#import "SFHomeViewController.h"

static const NSInteger confirmedSection = 0;
static const NSInteger invitedSection = 1;
static NSString *goingEventName = @"Going Events";
static NSString *invitedEventName = @"Invited Events";

@interface SFHomeViewController() <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray *userFriends;
@end

@implementation SFHomeViewController
- (void) userLoggedIn:(SFUser *)user
{
  self.loggedInUser = user;
  self.userFriends = [NSMutableArray arrayWithArray:[self.loggedInUser getFriendsAsObjects]];
  
  [self.navigationController popToRootViewControllerAnimated:YES];
  [self.navigationController setNavigationBarHidden:NO animated:NO];
  NSLog(@"User %@ logged in", user.username);
  
  [self.homeTableView reloadData];
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
  
  self.title = @"All Events";
  self.homeTableView.delegate = self;
  self.homeTableView.dataSource = self;
  
  UIBarButtonItem *newMealButton = [[UIBarButtonItem alloc] initWithTitle:@"New Meal" style:UIBarButtonItemStylePlain target:self action:@selector(newMeal:)];
  self.navigationItem.rightBarButtonItem = newMealButton;
  
  UIBarButtonItem *profileButton = [[UIBarButtonItem alloc] initWithTitle:@"You" style:UIBarButtonItemStylePlain target:self action:@selector(viewProfile:)];
  self.navigationItem.leftBarButtonItem = profileButton;
  
  [self.homeTableView registerNib:[UINib nibWithNibName:@"SFHomeViewTableCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"HomeCell"];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  [self.homeTableView reloadData];
}

-(void)viewProfile:(id)sender
{
  SFProfileViewController *vc = [[SFProfileViewController alloc] initWithUser:self.loggedInUser];
  [self.navigationController pushViewController:vc animated:YES];
}

-(void)newMeal:(id)sender
{
  SFNewEventViewController *viewController = [[SFNewEventViewController alloc] initWithUser:self.loggedInUser userFriends:self.userFriends];
  [self.navigationController pushViewController:viewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  SFHomeViewTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCell"];
  if (!cell) {
    cell = [[SFHomeViewTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HomeCell"];
  }
  
  SFEvent *event = nil;
  
  switch (indexPath.section) {
    case confirmedSection:
      event = [SFEvent eventWithID:[self.loggedInUser.confirmedEventIDs objectAtIndex:indexPath.row]];
      break;
      
    case invitedSection:
      event = [SFEvent eventWithID:[self.loggedInUser.inviteIDs objectAtIndex:indexPath.row]];
      break;
      
    default:
      break;
  }
  
  // Get the dates to display
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"hh:mm"];
  NSString *eventTime = [dateFormatter stringFromDate:event.date];
  [dateFormatter setDateFormat:@"EEE"];
  NSString *eventDay = [dateFormatter stringFromDate:event.date];
  
  cell.restaurantNameLabel.text = event.name;
  cell.dayLabel.text = eventDay;
  cell.timeLabel.text = eventTime;
  return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  switch (section) {
    case confirmedSection:
      return [self.loggedInUser.confirmedEventIDs count];
      break;
      
    case invitedSection:
      return [self.loggedInUser.inviteIDs count];
      break;
      
    default:
      return -1;
      break;
  }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  switch (section) {
    case confirmedSection:
      return goingEventName;
      break;
      
    case invitedSection:
      return invitedEventName;
      break;
      
    default:
      return nil;
      break;
  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  SFEvent *event = nil;
  
  // TODO(jacob) this could not be the expected event if for example the user has received
  // an invite to an event after the table was loaded. one way to fix this would be to
  // store the eventIDs as a private field
  switch (indexPath.section) {
    case confirmedSection:
      event = [SFEvent eventWithID:[self.loggedInUser.confirmedEventIDs objectAtIndex:indexPath.row]];
      break;
      
    case invitedSection:
      event = [SFEvent eventWithID:[self.loggedInUser.inviteIDs objectAtIndex:indexPath.row]];
      break;
      
    default:
      break;
  }

  NSLog(@"Selected event: %@", event.name);

  // check if event is less than 30 minutes from now
  if ([event.date timeIntervalSinceNow] < 30*60) {
    SFEventOverviewViewController *eventOverview = [[SFEventOverviewViewController alloc] initWithEvent:event];
    [self.navigationController pushViewController:eventOverview animated:YES];
  }
  else {
    SFMealInviteViewController *mealVC = [[SFMealInviteViewController alloc] initWithUser:self.loggedInUser event:event];
    [self.navigationController pushViewController:mealVC animated:YES];
  }
}

@end
