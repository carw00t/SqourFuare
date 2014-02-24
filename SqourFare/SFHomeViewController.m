//
//  SFHomeViewController.m
//  SqourFare
//
//  Created by Tanner Whyte on 2/19/14.
//  Copyright (c) 2014 whyte.tanner. All rights reserved.
//

#import "SFHomeViewController.h"

@interface SFHomeViewController() <UITableViewDelegate>
@property (strong, nonatomic) SFDataSource<UITableViewDataSource> *dataSource;
@end

@implementation SFHomeViewController
- (id)initWithDataSource: (SFDataSource<UITableViewDataSource> *) dataSource
{
  if (self = [super initWithNibName:@"SFHomeViewController" bundle:nil]) {
    self.dataSource = dataSource;
  }
  return self;
}

- (void)userLoggedInWithUsername:(NSString *) username password: (NSString *) password
{
  [self.navigationController popToRootViewControllerAnimated:YES];
  [self.navigationController setNavigationBarHidden:NO animated:NO];
  NSLog(@"User %@ logged in with password %@", username, password);
  self.username = username;
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
  self.homeTableView.dataSource = self.dataSource;
  
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

@end
