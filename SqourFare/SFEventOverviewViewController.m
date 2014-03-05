//
//  SFEventOverviewViewController.m
//  SqourFare
//
//  Created by Jacob Van De Weert on 3/5/14.
//  Copyright (c) 2014 whyte.tanner. All rights reserved.
//

#import "SFEventOverviewViewController.h"
#import "SFUser.h"

static NSInteger confirmedSection = 0;
static NSInteger invitedSection = 1;

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
  self.venueLabel.text = self.event.venueID;
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
  if (section == confirmedSection)
    return [self.event.confirmedMembers count];
  else if (section == invitedSection)
    return [self.event.invited count];
  else
    return -1;
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
  if (section == confirmedSection)
    return @"Confirmed";
  else if (section == invitedSection)
    return @"Also Invited";
  else
    return nil;
}

@end