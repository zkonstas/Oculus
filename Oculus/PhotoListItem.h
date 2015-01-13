//
//  PlaceCell.h
//  Zplaces
//
//  Created by Zissis Konstas on 3/29/14.
//  Copyright (c) 2014 Acme. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoListItem : UITableViewCell

//List item outlets
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *location_name;
@property (weak, nonatomic) IBOutlet UILabel *time_taken;
@property (weak, nonatomic) IBOutlet UIImageView *profile_pic;
@property (weak, nonatomic) IBOutlet UILabel *username;


@end
