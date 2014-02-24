//
//  SFEvent.h
//  SqourFare
//
//  Created by Tanner Whyte on 2/19/14.
//  Copyright (c) 2014 whyte.tanner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFEvent : NSObject
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSDate *date;

-(instancetype) initWithName: (NSString*)name date:(NSDate*)date;
@end
