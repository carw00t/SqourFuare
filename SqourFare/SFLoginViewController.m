//
//  SFLoginViewController.m
//  SqourFare
//
//  Created by Tanner Whyte on 2/19/14.
//  Copyright (c) 2014 whyte.tanner. All rights reserved.
//

#import "SFLoginViewController.h"
#import "SFUser.h"
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
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Signup Failure"
                          message:@"Didn't anyone ever teach you to create a decent username and password? Be more original next time!"
                          delegate:self
                          cancelButtonTitle:@"Ok..."
                          otherButtonTitles:nil];
    
    [alert show];
  }
  else {
    SFUser *user = [SFUser signupUserWithUsername:self.usernameTextField.text
                                         password:self.passwordTextField.text];
    if (user) {
      [self.loginDelegate userLoggedIn:user];
    }
    else {
      UIAlertView *alert = [[UIAlertView alloc]
                            initWithTitle:@"Signup Failure"
                            message:@"Probably a duplicate username. Be more original next time."
                            delegate:self
                            cancelButtonTitle:@"Dismiss"
                            otherButtonTitles:nil];
      
      [alert show];
    }
  }
}

- (IBAction)loginButton:(id)sender {
  
  SFUser *user = [SFUser userWithUsername:self.usernameTextField.text
                                 password:self.passwordTextField.text];
  if (user) {
    [self.loginDelegate userLoggedIn:user];
  }
  else {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Login Failure"
                          message:@"Unable to log in. Check your typing or try again later."
                          delegate:self
                          cancelButtonTitle:@"Dismiss"
                          otherButtonTitles:nil];
    
    [alert show];
  }
}

@end
