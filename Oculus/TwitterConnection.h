//
//  TwitterConnection.h
//  Oculus
//
//  Created by Dimitris Paidarakis on 4/18/14.
//  Copyright (c) 2014 Oculus. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;

@protocol TwitterConnectionDelegate
@optional
//  Implement the delegate methods to receive the data from the call to the Twitter API
- (void) twitterConnectiondidFinishLoadingWithPhotos:(NSMutableArray *)data;

@end

@interface TwitterConnection : NSObject<CLLocationManagerDelegate>

@property (nonatomic, weak) id <TwitterConnectionDelegate> delegate;
//  Implement this method to trigger the call to the Twitter API
-(void)getTwitterPhotosWithCoordinates:(CLLocationCoordinate2D)coords;

@end
