//
//  SFHomeViewController.m
//  SqourFare
//
//  Created by Tanner Whyte on 2/19/14.
//  Copyright (c) 2014 whyte.tanner. All rights reserved.
//

#import "SFHomeViewController.h"

@interface SFHomeViewController() <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) SFDataSource *dataSource;
@end

@implementation SFHomeViewController
- (id)initWithDataSource: (SFDataSource*) dataSource
{
  if (self = [super initWithNibName:@"SFHomeViewController" bundle:nil]) {
    self.dataSource = dataSource;
  }
  return self;
}

- (void) userLoggedIn:(SFUser *)user
{
  [self.navigationController popToRootViewControllerAnimated:YES];
  [self.navigationController setNavigationBarHidden:NO animated:NO];
  NSLog(@"User %@ logged in", user.username);
  
  // TODO(jacob) deprecate this
  NSMutableDictionary *allEvents = [self.dataSource getEvents];
  NSArray *goingEvents = [allEvents objectForKey:SFInvitedEvents];
  NSLog(@"%@", goingEvents);
  
  [self.homeTableView reloadData];
}

/**
 * Returns an dictionary of arrays. The inner arrays are arrays of events you've been
 * invited to, events you're going to, and events you've been to.
 */

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
  
  UIBarButtonItem *newReminderButton = [[UIBarButtonItem alloc] initWithTitle:@"New Meal" style:UIBarButtonItemStylePlain target:self action:@selector(newMeal:)];
  self.navigationItem.rightBarButtonItem = newReminderButton;
  
  [self.homeTableView registerNib:[UINib nibWithNibName:@"SFHomeViewTableCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"HomeCell"];
}

-(void)newMeal:(id)sender
{
  SFNewEventViewController *viewController = [[SFNewEventViewController alloc] initWithStyle:UITableViewStylePlain];
  [self.navigationController pushViewController:viewController animated:YES];
  //TRReminderTableViewController *tableView = [[TRReminderTableViewController alloc] initWithStyle:UITableViewStylePlain];
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
  NSMutableArray *events = [self.dataSource getEventsForTableGroup: indexPath.section];
  SFEvent *event = [events objectAtIndex:(NSUInteger) indexPath.row];
  
  // Get the dates to display
  NSDateComponents *currComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:[NSDate date]];
  NSInteger currDay = [currComponents day];
  
  NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:event.date];
  NSInteger eventDay = [components day];
  NSInteger eventHour = [components hour];
  NSInteger eventMinute = [components minute];
  
  cell.restaurantNameLabel.text = event.name;
  cell.dayLabel.text = [NSString stringWithFormat:@"+%ld", (eventDay - currDay)];
  cell.timeLabel.text = [NSString stringWithFormat:@"%d:%d", (int)eventHour, (int)eventMinute];
  return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [[self.dataSource getEventsForTableGroup:section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

  return [[self.dataSource getEvents] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  return [self.dataSource getKeyForSection:section];
}



@end
