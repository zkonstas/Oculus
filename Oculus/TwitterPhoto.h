//
//  TwittetPhoto.h
//  Oculus
//
//  Created by Dimitris Paidarakis on 4/22/14.
//  Copyright (c) 2014 Oculus. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;

@interface TwitterPhoto : NSObject

@property(strong, nonatomic)NSDictionary *entities;
@property(strong, nonatomic)NSDictionary *hashtags;
@property(strong, nonatomic)NSString *media_url;
@property(strong, nonatomic)NSString *tweet_url;

@property(strong, nonatomic)NSDictionary *user;
@property(strong, nonatomic)NSString *user_description;
@property(strong, nonatomic)NSString *username;
@property(strong, nonatomic)NSString *user_profile_image_url;
@property(strong, nonatomic)NSString *screenname;

@property(strong, nonatomic)NSDictionary *place;
@property(strong, nonatomic)NSString *place_full_name;
@property(strong, nonatomic)NSString *place_country;

@property(strong, nonatomic)CLLocation *coordinates;
@property(strong, nonatomic)NSString *tweet_id;
@property(strong, nonatomic)NSString *text;
@property(strong, nonatomic)NSDate *created_at;
@property(strong, nonatomic)NSString *tweet_source;
@property(strong, nonatomic)NSNumber *favorite_count;
@property(strong, nonatomic)NSNumber *retweet_count;
@property(strong, nonatomic)NSDictionary *metadata;



@end
