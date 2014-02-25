//
//  SFMealInviteViewController.m
//  SqourFare
//
//  Created by Tanner Whyte on 2/24/14.
//  Copyright (c) 2014 whyte.tanner. All rights reserved.
//

#import "SFMealInviteViewController.h"

@interface SFMealInviteViewController ()

@end

@implementation SFMealInviteViewController

- (instancetype) initWithEvent:(SFEvent *)event
{
  if (self = [super init]) {
    self.event = event;
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

- (IBAction)timeChooser:(UISegmentedControl *)sender {
  
  NSLog(@"selected segments: %d", [sender selectedSegmentIndex]);
}

- (IBAction)chooseRestaurantButton:(UIButton *)sender {
}

- (IBAction)acceptInviteButton:(UIButton *)sender {
}

- (IBAction)rejectInviteButton:(UIButton *)sender {
}
@end
