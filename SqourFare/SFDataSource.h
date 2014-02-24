//
//  SFDataSource.h
//  SqourFare
//
//  Created by Tanner Whyte on 2/23/14.
//  Copyright (c) 2014 whyte.tanner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFHomeViewTableCell.h"
#import "SFEvent.h"

extern NSString * const SFGoingEvents;
extern NSString * const SFInvitedEvents;
extern NSString * const SFWentEvents;

@interface SFDataSource : NSObject <UITableViewDataSource>
- (void) reloadData;
- (NSMutableDictionary *)getEvents;
@property (nonatomic, strong) NSMutableDictionary *allEvents;
@end
