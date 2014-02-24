//
//  SFNewEventViewController.h
//  SqourFare
//
//  Created by Tanner Whyte on 2/23/14.
//  Copyright (c) 2014 whyte.tanner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFDataSource.h"
#import "SFUser.h"

@interface SFNewEventViewController : UITableViewController
@property (nonatomic, strong) SFDataSource *dataSource;
@end
