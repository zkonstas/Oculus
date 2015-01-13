//
//  InstagramConnection.h
//  Oculus
//
//  Created by Dimitris Paidarakis on 4/14/14.
//  Copyright (c) 2014 Oculus. All rights reserved.
//
//  Implement the public method to trigger the call to the instagram API,
//  Implement the delegate methods to receive the data from the call to the Instagram API


#import <Foundation/Foundation.h>
#import "GeocodingConnection.h"
@import CoreLocation;

@protocol InstagramConnectionDelegate
@optional
//  Implement the delegate methods to receive the data from the call to the Instagram API
- (void) instagramConnectiondidFinishLoadingWithPhotos:(NSMutableArray *)data;
- (void) instagramConnectiondidFailWithErrorType:(NSString *)error_type andErrorCode:(NSString *)error_code  andErrorMessage:(NSString *)error_message;

@end

@interface InstagramConnection : NSObject<CLLocationManagerDelegate, GeocodingConnectionDelegate>

@property (nonatomic, weak) id <InstagramConnectionDelegate> delegate;
//  Implement this method to trigger the call to the instagram API
-(void)getInstagramPhotosWithCoordinates:(CLLocationCoordinate2D)coords
                          withinDistance:(int)dist;
@end
