//
//  SFNewEventViewController.m
//  SqourFare
//
//  Created by Tanner Whyte on 2/27/14.
//  Copyright (c) 2014 whyte.tanner. All rights reserved.
//

#import "SFNewEventViewController.h"

@interface SFNewEventViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSArray *users;
@end

@implementation SFNewEventViewController
- (id)initWithUser:(SFUser *)user userFriends:(NSArray *)friends
{
  if (self = [super initWithNibName:@"SFNewEventViewController" bundle:nil]) {
    self.loggedInUser = user;
    self.users = friends;
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  UIBarButtonItem *inviteButton = [[UIBarButtonItem alloc] initWithTitle:@"Invite" style:UIBarButtonItemStylePlain target:self action:@selector(inviteFriends:)];
  self.navigationItem.rightBarButtonItem = inviteButton;
  
  self.title = @"New Event?";
  
  self.friendTableView.delegate = self;
  self.friendTableView.dataSource = self;
  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;
  
  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)inviteFriends:(id)sender
{
  NSArray *indexPaths = [self.friendTableView indexPathsForSelectedRows];
  SFEvent *newEvent = [SFEvent createEventWithName:self.eventNameField.text date:self.datePicker.date host:self.loggedInUser.userID];
  NSMutableArray *invitedUsers = [[NSMutableArray alloc] initWithObjects:self.loggedInUser.userID, nil];
  [[self loggedInUser] inviteToEvent:newEvent.eventID];
  for (NSIndexPath *indexPath in indexPaths) {
    SFUser *user = [self.users objectAtIndex:indexPath.row];
    NSLog(@"%@", user.username);
    [invitedUsers addObject: user.userID];
    [user inviteToEvent:newEvent.eventID];
  }
  [newEvent inviteUsers:invitedUsers];
  
  NSLog(@"Users invited to the event: %@", newEvent.invited);

  [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  // TODO later: 1st section is recommended friends, 2nd is the rest
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [self.users count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  
  SFUser *user = [[self.loggedInUser getFriends] objectAtIndex:indexPath.row];
  cell.textLabel.text = user.username;
  
  return cell;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
