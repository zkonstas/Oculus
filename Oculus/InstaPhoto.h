//
//  InstaPhoto.h
//  Oculus
//
//  Created by Dimitris Paidarakis on 4/15/14.
//  Copyright (c) 2014 Oculus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InstaComment.h"
@import CoreLocation;

@interface InstaPhoto : NSObject

@property(strong, nonatomic)NSString *attribution;
@property(strong, nonatomic)NSString *caption_created_time;
@property(strong, nonatomic)NSString *full_name;
@property(strong, nonatomic)NSString *user_id;
@property(strong, nonatomic)NSString *profile_picture_link;
@property(strong, nonatomic)NSString *username;
@property(strong, nonatomic)NSString *caption_id;
@property(strong, nonatomic)NSString *caption_text;
@property(strong, nonatomic)NSArray *comments;
@property(strong, nonatomic)NSString *photo_created_time;
@property(strong, nonatomic)NSString *filter;
@property(strong, nonatomic)NSString *photo_id;
@property(strong, nonatomic)NSString *low_res_height;
@property(strong, nonatomic)NSString *low_res_url;
@property(strong, nonatomic)NSString *low_res_width;
@property(strong, nonatomic)NSString *standard_res_height;
@property(strong, nonatomic)NSString *standard_res_url;
@property(strong, nonatomic)NSString *standard_res_width;
@property(strong, nonatomic)NSString *thumbnail_res_height;
@property(strong, nonatomic)NSString *thumbnail_res_url;
@property(strong, nonatomic)NSString *thumbnail_res_width;
@property(strong, nonatomic)NSArray *likes;
@property(strong, nonatomic)NSString *post_url;
@property(strong, nonatomic)CLLocation *location;
@property(strong, nonatomic)NSArray *tags;
@property(strong, nonatomic)NSString *type;
@property(strong, nonatomic)NSArray *users_in_photo;
@property(strong, nonatomic)NSString *geoCodingLocation;
@property(strong, nonatomic)NSString *time;
@property(strong, nonatomic)NSString *locationString;

@end
