//
//  GooglePlacesConnection.m
//  Oculus
//
//  Created by Dimitris Paidarakis on 4/24/14.
//  Copyright (c) 2014 Oculus. All rights reserved.
//

#import "GooglePlacesConnection.h"

@implementation GooglePlacesConnection{
    NSURLConnection *autocompleteConnection;
    NSURLConnection *detailsConnection;
    NSMutableData *responseData;
    NSMutableArray *predictions;
}

-(void)getGooglePlacesAutoCompleteSuggestionsForQuery:(NSString *)query{
/*    //  Check for live connection
    if(autocompleteConnection){
        [autocompleteConnection cancel];
        autocompleteConnection = nil;
        responseData = nil;
    }
*/    
    //  Encode the string
    NSString *encQuery = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //  Initialize the url for the connection
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&sensor=true&key=AIzaSyDuZ_gcFkuPK7F3DdTCSLrLtvcd8zFiB4g", encQuery];
    
    //  Set the NSURL
    NSURL *nsURL = [NSURL URLWithString:urlString];
    
    //  Set the NSURLRequest
    NSURLRequest *nsUrlRequest = [NSURLRequest requestWithURL:nsURL];
    
    //  Allocate and initialize responseData
    responseData = [NSMutableData new];
    
    //  Make the call to Instagram API and get the response asynchronously
    autocompleteConnection = [[NSURLConnection alloc] initWithRequest:nsUrlRequest delegate:self startImmediately:YES];
    
    //  Release the responseData
    if (!autocompleteConnection) {
        responseData = nil;
        NSLog(@"nsUrlConnection for autocomplete results failed");
    }
}

-(void)getGooglePlaceDetailsForPlaceWithReference:(NSString *)reference{
    //  Initialize the url for the connection
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?reference=%@&sensor=true&key=AIzaSyDuZ_gcFkuPK7F3DdTCSLrLtvcd8zFiB4g", reference];
    
    //  Set the NSURL
    NSURL *nsURL = [NSURL URLWithString:urlString];
    
    //  Set the NSURLRequest
    NSURLRequest *nsUrlRequest = [NSURLRequest requestWithURL:nsURL];
    
    //  Allocate and initialize responseData
    responseData = [NSMutableData new];
    
    //  Make the call to Instagram API and get the response asynchronously
    detailsConnection = [[NSURLConnection alloc] initWithRequest:nsUrlRequest delegate:self startImmediately:YES];
    
    //  Release the responseData
    if (!detailsConnection) {
        responseData = nil;
        NSLog(@"nsUrlConnection failed");
    }
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
    if(conn == autocompleteConnection){
        //  Release the connection and the data object
        autocompleteConnection = nil;
        responseData = nil;
        NSLog(@"Connection for autocomplete results didfailwitherror%@", error);
    } else if (conn == detailsConnection){
        //  Release the connection and the data object
        detailsConnection = nil;
        responseData = nil;
        NSLog(@"Connection for details didfailwitherror%@", error);
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn
{
    if(conn == autocompleteConnection){
        //  The error for the JSON parsing
        NSError *jsonError = nil;
        
        //  The NSDictionary from the parsed JSON
        NSDictionary *parsedJSON = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&jsonError];
        
        NSString *responseStatus = [NSString stringWithFormat:@"%@",[parsedJSON objectForKey:@"status"]];
        
        if ([responseStatus isEqualToString:@"OK"])
        {
            //  NSLog(@"predictions:%@", [parsedJSON objectForKey: @"predictions"]);
            NSDictionary *results  = [parsedJSON objectForKey: @"predictions"];
            predictions = [NSMutableArray arrayWithCapacity:[[parsedJSON objectForKey:@"predictions"] count]];
            
            for (NSDictionary *prediction in results)
            {
                [predictions addObject:prediction];
            }
            
        }
        
        // Call the delegate method
        [self.delegate googlePlacesConnectiondidFinishLoadingWithResults:predictions];
        
        //  Release the connection and the data object
        autocompleteConnection = nil;
        responseData = nil;
    } else if(conn == detailsConnection){
        //  The error for the JSON parsing
        NSError *jsonError = nil;
        NSDictionary *location;
        
        //  The NSDictionary from the parsed JSON
        NSDictionary *parsedJSON = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&jsonError];
        
        if ([parsedJSON objectForKey:@"result"])
        {
            location = [[[parsedJSON objectForKey:@"result"] objectForKey:@"geometry"] objectForKey:@"location"];
        }
        
        // Call the delegate method
        [self.delegate googlePlacesConnectiondidFinishLoadingWithDetails:location];
        
        //  Release the connection and the data object
        detailsConnection = nil;
        responseData = nil;
    }
}

@end
