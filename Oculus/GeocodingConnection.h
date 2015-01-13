//
//  GeocodingConnection.h
//  HotSpot
//
//  Created by Dimitris Paidarakis on 4/30/14.
//  Copyright (c) 2014 Oculus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InstaPhoto.h"
@import CoreLocation;

@protocol GeocodingConnectionDelegate
@optional
//  Implement the delegate methods to receive the data from the call to the Instagram API
- (void) geocodingConnectiondidFinishLoadingWithResult:(NSString *)location;
- (void) geocodingConnectiondidFailWithError:(NSError *)error;


@end

@interface GeocodingConnection : NSObject

@property (nonatomic, weak) id <GeocodingConnectionDelegate> delegate;
//  Implement this method to get the location string
//  -(NSString *)getClosestLocation:(CLLocation *)location;
-(void)getClosestLocation:(CLLocation *)location;
@end
