//
//  InstaComment.h
//  Oculus
//
//  Created by Dimitris Paidarakis on 4/15/14.
//  Copyright (c) 2014 Oculus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InstaComment : NSObject
@property(strong, nonatomic)NSDate *created_time;
@property(strong, nonatomic)NSString *full_name;
@property(strong, nonatomic)NSString *user_id;
@property(strong, nonatomic)NSString *profile_picture_link;
@property(strong, nonatomic)NSString *username;
@property(strong, nonatomic)NSString *comment_id;
@property(strong, nonatomic)NSString *text;



@end
