//
//  SFVenuePickerTableCellTableViewCell.m
//  SqourFare
//
//  Created by Tanner Whyte on 4/30/14.
//  Copyright (c) 2014 whyte.tanner. All rights reserved.
//

#import "SFVenuePickerTableViewCell.h"

@implementation SFVenuePickerTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Initialization code
  }
  return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
