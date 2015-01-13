//
//  PlaceCell.m
//  Zplaces
//
//  Created by Zissis Konstas on 3/29/14.
//  Copyright (c) 2014 Acme. All rights reserved.
//

#import "PhotoListItem.h"

@implementation PhotoListItem

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
