//
//  GeocodingConnection.m
//  HotSpot
//
//  Created by Dimitris Paidarakis on 4/30/14.
//  Copyright (c) 2014 Oculus. All rights reserved.
//

#import "GeocodingConnection.h"
@import CoreLocation;

@implementation GeocodingConnection{
    NSURLConnection *nsUrlConnection;
    NSMutableData *responseData;
    
}

//Google Places API call to get the closest location
-(void)getClosestLocation:(CLLocation *)location {
    
    //  __block NSString *neighborhood = nil;
    
    NSString *key = @"";
    
    NSString *latitude = [[NSString alloc] initWithFormat:@"%f", location.coordinate.latitude];
    NSString *longitude = [[NSString alloc] initWithFormat:@"%f", location.coordinate.longitude];
    
    NSString *url_string = [[NSString alloc] initWithFormat:
                            @"https://maps.googleapis.com/maps/api/geocode/json?latlng=%@,%@&location_type=ROOFTOP&result_type=street_address&sensor=false&key=%@",
                            latitude, longitude, key];
    
    NSURL *url = [[NSURL alloc] initWithString:url_string];
    
    //  Set the NSURLRequest
    NSURLRequest *nsUrlRequest = [NSURLRequest requestWithURL:url];
    
    //  Allocate and initialize responseData
    responseData = [NSMutableData new];
    
    //  Make the call to Instagram API and get the response asynchronously
    nsUrlConnection = [[NSURLConnection alloc] initWithRequest:nsUrlRequest delegate:self startImmediately:YES];
    
    //  Release the responseData
    if (!nsUrlConnection) {
        responseData = nil;
        NSLog(@"nsUrlConnection failed");
    }
    
    
    
    
    
    /*
     
     //Perform asynchronous GET request to the API
     dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
     
     dispatch_async(queue, ^{
     
     NSString *jsonString = [self performStoreRequestWithURL:url];
     //NSLog(@"%@", jsonString);
     
     if (jsonString == nil) {
     dispatch_async(dispatch_get_main_queue(), ^{
     NSLog(@"Network Error");
     });
     return;
     }
     
     NSDictionary *results = [self parseJSON:jsonString];
     //  NSLog(@"results:%@", results);
     
     neighborhood = [self getNeighborhood:results];
     NSLog(@"neighborhood:%@", neighborhood);
     
     [self.delegate geocodingConnectiondidFinishLoadingWithResult:neighborhood];
     
     });
     
     //  return neighborhood;
     
     */
}

#pragma mark - NSURLConnection Delegate
- (void)connection:(NSURLConnection *)conn didReceiveResponse:(NSURLResponse *)response
{
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data
{
    
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error
{
    //  Release the connection and the data object
    nsUrlConnection = nil;
    responseData = nil;
    NSLog(@"Connection didfailwitherror%@", error);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn
{
    NSString *location = @"";
    
    //  The error for the JSON parsing
    NSError *error = nil;
    
    //  The NSDictionary from the parsed JSON
    NSDictionary *parsedJSON = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    
    if([parsedJSON[@"status"] isEqualToString:@"OK"]){
        for(NSDictionary *result in parsedJSON[@"results"][0][@"address_components"]) {
            //Append area
            if( [(NSString *)result[@"types"][0] isEqualToString:@"neighborhood"]) {
                location = [location stringByAppendingFormat:@"%@, ", result[@"short_name"]];
            }
            
            //Append area2
            if( [(NSString *)result[@"types"][0] isEqualToString:@"sublocality"]) {
                location = [location stringByAppendingFormat:@"%@, ", result[@"short_name"]];
            }
            
            //Append city
            if( [(NSString *)result[@"types"][0] isEqualToString:@"administrative_area_level_1"]) {
                location = [location stringByAppendingFormat:@"%@", result[@"short_name"]];
            }
        }
        //NSLog(@"geocodinglocationL%@", location);
        [self.delegate geocodingConnectiondidFinishLoadingWithResult:location];
    }else if([parsedJSON[@"status"] isEqualToString:@"ZERO_RESULTS"]){
        [self.delegate geocodingConnectiondidFinishLoadingWithResult:nil];
        NSLog(@"Geocoding unsuccesful");
    } else{
        [self.delegate geocodingConnectiondidFailWithError:error];
    }
    
}
/*
 - (NSDictionary *)parseJSON:(NSString *)jsonString {
 
 NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
 NSError *error;
 id resultObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
 
 if (resultObject == nil) {
 NSLog(@"JSON Error: %@", error);
 return nil;
 }
 return resultObject;
 }
 
 -(NSString *)getNeighborhood:(NSDictionary *)results {
 NSString *location = @"";
 
 if([results[@"results"] count] > 0){
 for(NSDictionary *result in results[@"results"][0][@"address_components"]) {
 //NSLog(@"%@", result[@"types"][0]);
 //Append area
 if( [(NSString *)result[@"types"][0] isEqualToString:@"neighborhood"]) {
 location = [location stringByAppendingFormat:@"%@, ", result[@"short_name"]];
 }
 
 //Append area2
 if( [(NSString *)result[@"types"][0] isEqualToString:@"sublocality"]) {
 location = [location stringByAppendingFormat:@"%@, ", result[@"short_name"]];
 }
 
 //Append city
 if( [(NSString *)result[@"types"][0] isEqualToString:@"administrative_area_level_1"]) {
 location = [location stringByAppendingFormat:@"%@", result[@"short_name"]];
 }
 }
 }
 return location;
 }
 
 -(NSString *)performStoreRequestWithURL:(NSURL *)url {
 NSError *error;
 NSString *resultString = [NSString stringWithContentsOfURL:url
 encoding:NSUTF8StringEncoding error:&error];
 if (resultString == nil) {
 
 [self.delegate geocodingConnectiondidFailWithError:error];
 NSLog(@"Download Error: %@", error);
 return nil;
 }
 return resultString;
 }
 */

@end