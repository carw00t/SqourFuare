//
//  SFVenuePickerTableCellTableViewCell.h
//  SqourFare
//
//  Created by Tanner Whyte on 4/30/14.
//  Copyright (c) 2014 whyte.tanner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFVenuePickerTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *venueName;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end
