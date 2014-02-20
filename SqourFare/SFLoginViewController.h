//
//  SFLoginViewController.h
//  SqourFare
//
//  Created by Tanner Whyte on 2/19/14.
//  Copyright (c) 2014 whyte.tanner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFHomeViewController.h"

@interface SFLoginViewController : UIViewController
@property (strong, nonatomic) id<LoginDelegate> loginDelegate;
@end
