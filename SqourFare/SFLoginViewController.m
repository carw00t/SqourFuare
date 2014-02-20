//
//  SFLoginViewController.m
//  SqourFare
//
//  Created by Tanner Whyte on 2/19/14.
//  Copyright (c) 2014 whyte.tanner. All rights reserved.
//

#import "SFLoginViewController.h"
#import "SFHomeViewController.h"

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
  NSLog(@"User %@ signed up with password %@", self.usernameTextField.text, self.passwordTextField.text);
}

- (IBAction)loginButton:(id)sender {
  NSLog(@"User %@ logged in with password %@", self.usernameTextField.text, self.passwordTextField.text);
  SFHomeViewController *homeViewController = [[SFHomeViewController alloc] init];
  
}
@end
