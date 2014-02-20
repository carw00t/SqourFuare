//
//  SFHomeViewController.m
//  SqourFare
//
//  Created by Tanner Whyte on 2/19/14.
//  Copyright (c) 2014 whyte.tanner. All rights reserved.
//

#import "SFHomeViewController.h"

@interface SFHomeViewController ()
- (NSDictionary *)getEvents;
@end

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
}
/**
 * Returns an dictionary of arrays. The inner arrays are arrays of events you've been
 * invited to, events you're going to, and events you've been to.
 */
- (NSDictionary *)getEvents
{
  //TODO
  return nil;
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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
