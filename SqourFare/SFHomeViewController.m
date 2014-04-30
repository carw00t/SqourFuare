//
//  SFHomeViewController.m
//  SqourFare
//
//  Created by Tanner Whyte on 2/19/14.
//  Copyright (c) 2014 whyte.tanner. All rights reserved.
//

#import "SFHomeViewController.h"

static const NSInteger comingUpSection = 0;
static const NSInteger confirmedSection = 1;
static const NSInteger invitedSection = 2;
static NSString *comingUpEventName = @"Coming Up Soon";
static NSString *goingEventName = @"Confirmed";
static NSString *invitedEventName = @"Invited";

@interface SFHomeViewController() <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray *userFriends;
@property (strong, nonatomic) NSArray *comingUpEvents;
@property (strong, nonatomic) NSArray *confirmedEvents;
@property (strong, nonatomic) NSArray *invitedEvents;
@end

@implementation SFHomeViewController

- (void) userLoggedIn:(SFUser *)user
{
  self.loggedInUser = user;
  NSMutableArray *friends = [[NSMutableArray alloc] init];
  [friends setArray:[self.loggedInUser getFriendsAsObjects]];
  self.userFriends = friends;
  
  NSArray *controllers = [self.navigationController viewControllers];
  UIView *loginView = ((UIViewController *)controllers[1]).view;
  UIView *homeView = ((UIViewController *)controllers[0]).view;
  
  [self refreshData];
  
  [self.navigationController popViewControllerAnimated:NO];
  [self.navigationController setNavigationBarHidden:NO animated:YES];
  [UIView transitionFromView:loginView
                      toView:homeView
                    duration:0.5
                     options:UIViewAnimationOptionTransitionCrossDissolve
                  completion:^(BOOL finished) {}];
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
  
  self.title = @"Events";
  self.homeTableView.delegate = self;
  self.homeTableView.dataSource = self;
  
  UIBarButtonItem *newMealButton = [[UIBarButtonItem alloc] initWithTitle:@"+" style:UIBarButtonItemStylePlain target:self action:@selector(newMeal:)];
  self.navigationItem.rightBarButtonItem = newMealButton;
  
  UIBarButtonItem *profileButton = [[UIBarButtonItem alloc] initWithTitle:@"You" style:UIBarButtonItemStylePlain target:self action:@selector(viewProfile:)];
  self.navigationItem.leftBarButtonItem = profileButton;
  
  [self.homeTableView registerNib:[UINib nibWithNibName:@"SFHomeViewTableCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"HomeCell"];
  
  UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
  [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
  [self.homeTableView addSubview:refreshControl];
}

- (void)refresh:(UIRefreshControl *)refreshControl
{
  [PFQuery clearAllCachedResults];
  [self refreshData];
  [refreshControl endRefreshing];
}

- (void)refreshData
{
  NSMutableArray *comingUpEvents = [NSMutableArray array];
  NSMutableArray *confirmedEvents = [NSMutableArray array];
  /*
  for (NSString *confirmedEventID in self.loggedInUser.confirmedEventIDs) {
    SFEvent *event = [SFEvent eventWithID:confirmedEventID];
    if ([event.date timeIntervalSinceNow] < 30*60) {
      [comingUpEvents addObject:event];
    } else {
      [confirmedEvents addObject:event];
    }
  }
  for (NSString *invitedEventID in self.loggedInUser.inviteIDs) {
    [invitedEvents addObject:[SFEvent eventWithID:invitedEventID]];
  }
   */
  for (SFEvent *event in [SFEvent currentEventsWithIDs:self.loggedInUser.confirmedEventIDs]) {
    if ([event.date timeIntervalSinceNow] < 30*60) {
      [comingUpEvents addObject:event];
    } else {
      [confirmedEvents addObject:event];
    }
  }
  
  self.comingUpEvents = comingUpEvents;
  self.confirmedEvents = confirmedEvents;
  self.invitedEvents = [SFEvent currentEventsWithIDs:self.loggedInUser.inviteIDs];
  
  [self.homeTableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  self.userFriends = [self.loggedInUser getFriendsAsObjects];
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
    case comingUpSection:
      event = [self.comingUpEvents objectAtIndex:indexPath.row];
      break;
    case confirmedSection:
      event = [self.confirmedEvents objectAtIndex:indexPath.row];
      break;
    case invitedSection:
      event = [self.invitedEvents objectAtIndex:indexPath.row];
      break;
    default:
      break;
  }
  
  // Get the dates to display
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"h:mm"]; //gives the hour and minute
  NSString *eventHourMinutes = [dateFormatter stringFromDate:event.date];
  [dateFormatter setDateFormat:@"HH"];
  NSString *eventTime;
  NSString *eventHourString = [dateFormatter stringFromDate:event.date];
  NSInteger eventHour = [eventHourString integerValue];
  if (eventHour >= 5 && eventHour < 11) {
    eventTime = @"Breakfast";
  } else if (eventHour >= 11 && eventHour < 16) {
    eventTime = @"Lunch";
  } else {
    eventTime = @"Dinner";
  }

  [dateFormatter setDateFormat:@"EEE"];
  NSString *eventDay = [dateFormatter stringFromDate:event.date];
  eventDay = [eventDay stringByAppendingString:@" "];
  eventDay = [eventDay stringByAppendingString:eventHourMinutes];
  cell.restaurantNameLabel.text = event.name;
  cell.dayLabel.text = eventDay;
  cell.timeLabel.text = eventTime;
  return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  switch (section) {
    case comingUpSection:
      return (NSUInteger)[self.comingUpEvents count];
      break;
      
    case confirmedSection:
      return (NSUInteger)[self.confirmedEvents count];
      break;
      
    case invitedSection:
      return (NSUInteger)[self.invitedEvents count];
      break;
      
    default:
      return -1;
      break;
  }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  switch (section) {
    case comingUpSection:
      return comingUpEventName;
      break;
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
  switch (indexPath.section) {
    case comingUpSection:{
      // load the event overview
      event = [self.comingUpEvents objectAtIndex:indexPath.row];
      SFEventOverviewViewController *eventOverview = [[SFEventOverviewViewController alloc] initWithEvent:event];
      [self.navigationController pushViewController:eventOverview animated:YES];
      return;
      break;
    }
    case confirmedSection:
      event = [self.confirmedEvents objectAtIndex:indexPath.row];
      break;
      
    case invitedSection:
      event = [self.invitedEvents objectAtIndex:indexPath.row];
      break;
      
    default:
      break;
  }

  SFMealInviteViewController *mealVC = [[SFMealInviteViewController alloc] initWithUser:self.loggedInUser event:event];
  [self.navigationController pushViewController:mealVC animated:YES];
}

@end
