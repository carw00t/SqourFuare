//
//  SFLoginViewController.m
//  SqourFare
//
//  Created by Tanner Whyte on 2/19/14.
//  Copyright (c) 2014 whyte.tanner. All rights reserved.
//

#import "SFLoginViewController.h"
#import <Parse/Parse.h>

@interface SFLoginViewController ()
@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
- (IBAction)signUpButton:(id)sender;
- (IBAction)loginButton:(id)sender;

@end

@implementation SFLoginViewController

- (id)init
{
  if (self = [super initWithNibName:@"SFLoginViewController" bundle:nil]) {
    
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

- (IBAction)signUpButton:(id)sender {
  
  if ([self.usernameTextField.text isEqualToString:@"Username"] ||
      [self.usernameTextField.text isEqualToString:@""] ||
      [self.passwordTextField.text isEqualToString:@"Password"] ||
      [self.passwordTextField.text isEqualToString:@""]) {
    NSLog(@"Oh, real original (put an alert to enter something valid here)");
  }
  else {
    PFObject *signupObj = [PFObject objectWithClassName:@"User"];
    [signupObj setObject:self.usernameTextField.text forKey:@"username"];
    [signupObj setObject:self.passwordTextField.text forKey:@"password"];
    [signupObj save];
    
    PFQuery *dupCheck = [PFQuery queryWithClassName:@"User"];
    [dupCheck whereKey:@"username" equalTo:self.usernameTextField.text];
    [dupCheck whereKey:@"password" equalTo:self.passwordTextField.text];
    NSArray *users = [dupCheck findObjects];
    
    if ([users count] == 0) {
      NSLog(@"Error signing up. Try again later. (popup message)");
    }
    else if ([users count] == 1) {
      [self.loginDelegate userLoggedInWithUsername:self.usernameTextField.text
                                          password:self.passwordTextField.text];
    }
    else if ([users count] > 1) {
      NSLog(@"Duplicate user (should also be a popup message");
      PFObject *earliest;
      NSDate *earliestDate;
      
      for (PFObject *user in users) {
        if (earliest == nil || [earliestDate compare:user[@"createdAt"]] == NSOrderedAscending) {
          earliest = user;
          earliestDate = user[@"createdAt"];
        }
      }

      NSMutableArray *muteUsers = [NSMutableArray arrayWithArray:users];
      [muteUsers removeObjectIdenticalTo:earliest];
      [PFObject deleteAllInBackground:muteUsers];
    }
  }
}

- (IBAction)loginButton:(id)sender {
  
  if ([self.usernameTextField.text isEqualToString:@"Username"] ||
      [self.usernameTextField.text isEqualToString:@""] ||
      [self.passwordTextField.text isEqualToString:@"Password"] ||
      [self.passwordTextField.text isEqualToString:@""]) {
    NSLog(@"Oh, real original (put an alert to enter something valid here)");
  }
  else {
    PFQuery *findUser = [PFQuery queryWithClassName:@"User"];
    [findUser whereKey:@"username" equalTo:self.usernameTextField.text];
    [findUser whereKey:@"password" equalTo:self.passwordTextField.text];
    
    if ([findUser getFirstObject]) {
      [self.loginDelegate userLoggedInWithUsername:self.usernameTextField.text
                                          password:self.passwordTextField.text];
    }
    else {
      NSLog(@"Invalid password or user not found. (popup)");
    }
  }
}

@end
