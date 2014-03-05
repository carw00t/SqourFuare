//
//  SFEventOverviewViewController.m
//  SqourFare
//
//  Created by Jacob Van De Weert on 3/5/14.
//  Copyright (c) 2014 whyte.tanner. All rights reserved.
//

#import "SFEventOverviewViewController.h"
#import "SFUser.h"

static const NSInteger confirmedSection = 0;
static const NSInteger invitedSection = 1;
static NSString *confirmedHeader = @"Confirmed";
static NSString *invitedHeader = @"Also Invited";

@interface SFEventOverviewViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) SFEvent *event;

@end

@implementation SFEventOverviewViewController

- (instancetype)initWithEvent:(SFEvent *)event
{
  self = [super init];
  if (self) {
    self.event = event;
    
    if (self.event.venueID == nil) {
      [self.event tallyVotes];
    }
  }
  
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.attendingTableView.delegate = self;
  self.attendingTableView.dataSource = self;
  
  self.title = self.event.name;
  if (self.event.venueID == NULL) {
    self.venueLabel.text = @"Nobody voted!";
  }
  else {
    NSLog(@"venueID: %@", self.event.venueID);
    self.venueLabel.text = self.event.venueID;
  }
  self.dateLabel.text = [self.event.date description];
  
  [self.attendingTableView reloadData];
  
  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;
  
  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  switch (section) {
    case confirmedSection:
      return [self.event.confirmedMembers count];
      break;
      
    case invitedSection:
      return [self.event.invited count];
      break;
      
    default:
      return -1;
      break;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:CellIdentifier];
  }
  
  if (indexPath.section == confirmedSection)
    cell.textLabel.text = [SFUser userWithID:[self.event.confirmedMembers objectAtIndex:indexPath.row]].username;
  else if (indexPath.section == invitedSection)
    cell.textLabel.text = [SFUser userWithID:[self.event.invited objectAtIndex:indexPath.row]].username;
  
  return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  switch (section) {
    case confirmedSection:
      return confirmedHeader;
      break;
      
    case invitedSection:
      return invitedHeader;
      break;
      
    default:
      return nil;
      break;
  }
}

@end
