//
//  SFHomeViewController.m
//  SqourFare
//
//  Created by Tanner Whyte on 2/19/14.
//  Copyright (c) 2014 whyte.tanner. All rights reserved.
//

#import "SFHomeViewController.h"
#import "SFEvent.h"
#import "SFHomeViewTableCell.h"

@interface SFHomeViewController() <UITableViewDataSource, UITableViewDelegate>
- (NSMutableDictionary *)getEvents;
@property (nonatomic, strong) NSMutableDictionary *allEvents;
@end

NSString * const SFGoingEvents = @"Going Events";
NSString * const SFInvitedEvents = @"Invited Events";
NSString * const SFWentEvents = @"Went Events";

@implementation SFHomeViewController
- (id)init
{
  if (self = [super initWithNibName:@"SFHomeViewController" bundle:nil]) {
    
  }
  return self;
}

- (void)userLoggedInWithUsername:(NSString *) username password: (NSString *) password
{
  [self.navigationController popToRootViewControllerAnimated:YES];
  [self.navigationController setNavigationBarHidden:NO animated:NO];
  NSLog(@"User %@ logged in with password %@", username, password);
  self.username = username;
  self.allEvents = [self getEvents];
  NSArray *goingEvents = [self.allEvents objectForKey:SFInvitedEvents];
  NSLog(@"%@", goingEvents);
  [self.homeTableView reloadData];
}

/**
 * Returns an dictionary of arrays. The inner arrays are arrays of events you've been
 * invited to, events you're going to, and events you've been to.
 */
- (NSMutableDictionary *)getEvents
{
  NSArray *invitedEvents = [NSArray arrayWithObject:[[SFEvent alloc] initWithName:@"Union Grill" date:[NSDate date]]];
  NSArray *goingEvents = [NSArray arrayWithObject:[[SFEvent alloc] initWithName:@"Chipotle" date:[NSDate date]]];
  NSMutableDictionary *allEvents = [[NSMutableDictionary alloc] init];
  [allEvents setValue:invitedEvents forKey:SFInvitedEvents];
  [allEvents setValue:goingEvents forKey:SFGoingEvents];
  [allEvents setValue:[[NSArray alloc] init] forKey:SFWentEvents];
  return allEvents;
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
  
  [self.homeTableView registerNib:[UINib nibWithNibName:@"SFHomeViewTableCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"HomeCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)getKeyForSection: (NSInteger) section
{
  NSString *eventsKey;
  switch (section) {
    case 0:
      eventsKey = SFGoingEvents;
      break;
    case 1:
      eventsKey = SFInvitedEvents;
      break;
    case 2:
      eventsKey = SFWentEvents;
      break;
    default:
      eventsKey = @"error";
      break;
  }
  return eventsKey;
}

- (NSMutableArray *)getEventsForTableGroup:(NSInteger) groupNum
{
  return [self.allEvents objectForKey:[self getKeyForSection:groupNum]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [[self getEventsForTableGroup:section] count];
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
  NSMutableArray *events = [self getEventsForTableGroup: indexPath.section];
  SFEvent *event = [events objectAtIndex:(NSUInteger) indexPath.row];
  
  // Get the dates to display
  NSDateComponents *currComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:[NSDate date]];
  NSInteger currDay = [currComponents day];
  
  NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:event.date];
  NSInteger eventDay = [components day];
  NSInteger eventHour = [components hour];
  NSInteger eventMinute = [components minute];
  
  cell.restaurantNameLabel.text = event.name;
  cell.dayLabel.text = [NSString stringWithFormat:@"+%d", (eventDay - currDay)];
  cell.timeLabel.text = [NSString stringWithFormat:@"%d:%d", eventHour, eventMinute];
  return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return [self.allEvents count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  return [self getKeyForSection:section];
}

@end
