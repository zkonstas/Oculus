//
//  GooglePlacesConnection.h
//  Oculus
//
//  Created by Dimitris Paidarakis on 4/24/14.
//  Copyright (c) 2014 Oculus. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GooglePlacesConnectionDelegate
@optional
//  Implement the delegate methods to receive the AUTOCOMPLETE RESULTS from the call to the Google Places API
- (void) googlePlacesConnectiondidFinishLoadingWithResults:(NSMutableArray *)results;
//  Implement the delegate methods to receive the DETAILS from the call to the Google Places API
- (void) googlePlacesConnectiondidFinishLoadingWithDetails:(NSDictionary *)location;
@end

@interface GooglePlacesConnection : NSObject

@property (nonatomic, weak) id <GooglePlacesConnectionDelegate> delegate;
//  Implement this method to trigger the call to the Google Places API for autocomplete results
-(void)getGooglePlacesAutoCompleteSuggestionsForQuery:(NSString *)query;
//  Implement this method to trigger the call to the Google Places API for the details of a place
-(void)getGooglePlaceDetailsForPlaceWithReference:(NSString *)reference;
@end
