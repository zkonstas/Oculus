//
//  TwitterConnection.m
//  Oculus
//
//  Created by Dimitris Paidarakis on 4/18/14.
//  Copyright (c) 2014 Oculus. All rights reserved.
//

#import "TwitterConnection.h"
#import "TwitterPhoto.h"

@implementation TwitterConnection {
    CLLocationCoordinate2D coordinates;
    NSURLConnection *getTokenConnection;
    NSURLConnection *getWoeidConnection;
    NSURLConnection *getTagsConnection;
    NSURLConnection *getTweetsConnection;
    NSMutableData *responseData;
    NSDictionary *results;
    NSString *bearerToken;
    NSString *woeid;
    NSString *trendsString;
    int radius;
    NSMutableArray *twitterPhotosArray;
}

//  The method to be called to get photos from Twitter
-(void)getTwitterPhotosWithCoordinates:(CLLocationCoordinate2D)coords{
    //  Set the coords
    coordinates = coords;
    
    //  Set the radius in miles
    radius = 2;
    
    //  Initialize the trends string
    trendsString = @"";
    
    //  Allocate and initialize the NSMutableData
    responseData = [NSMutableData new];
    
    //  The consumer key for our app
    NSString *key = @"";
    
    //  RFC 1738 encoded consumer key
    NSString *rfc1738key = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //  The consumer secret for our app
    NSString *secret = @"";
    
    //  RFC 1738 encoded consumer secret
    NSString *rfc1738secret = [secret stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //  Concatenate the two strings, having a ":" between
    NSString *concat = [NSString stringWithFormat:@"%@:%@", rfc1738key, rfc1738secret];
    
    //  Base64 encoded string
    NSString *enc = [[concat dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0]; // base64 encoded value of concat
    
    //  The NSURL
    NSURL *theURL = [NSURL URLWithString:@"https://api.twitter.com/oauth2/token"];
    
    //  The NSMutableURLRequest
    NSMutableURLRequest *getToken = [NSMutableURLRequest requestWithURL:theURL];
    
    //  Add the Content-Type header
    [getToken addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //  Wrapped authorization header
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", enc];
    
    //  Add the Authorization header
    [getToken addValue:authValue forHTTPHeaderField:@"Authorization"];
    
    //  The type of the body of the request
    NSString *post = @"grant_type=client_credentials";
    
    //  The body of the request
    NSData *body = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    // The HTTPMethod
    [getToken setHTTPMethod:@"POST"];
    
    //  Set the Content-Length
    [getToken setValue:[NSString stringWithFormat:@"%u", (unsigned int)[body length]] forHTTPHeaderField:@"Content-Length"];
    
    //  Set the body of the request
    [getToken setHTTPBody:body];
    
    //  Allocate and initialize the NSURLConnection
    getTokenConnection = [[NSURLConnection alloc] initWithRequest:getToken delegate:self startImmediately:YES];
    
    //  Release the responseData
    if (!getTokenConnection) {
        responseData = nil;
        NSLog(@"nsUrlConnection failed");
    }
}

#pragma mark - NSURL delegate methods
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
    getTokenConnection = nil;
    responseData = nil;
    NSLog(@"Connection didfailwitherror%@", error);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn
{
    //  Check which connection finished loading and retrieve data
    //  If it is the connection for the bearer token retrieve its value and get the woeid
    //  by calling /trends/closest.json
    if(conn == getTokenConnection){
        NSError *error;
        if (![responseData length] == 0) {
            results = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
        } else{
            results = nil;
            NSLog(@"Error. No data\n");
        }
        //NSLog(@"token results:%@", results);
        if([results valueForKey:@"access_token"] && [[results valueForKey:@"token_type"] isEqualToString:@"bearer"]){
            bearerToken = [[NSString alloc] initWithString:[results valueForKey:@"access_token"]];
            //  [self getWoeid]; // call a method to request relevant tweets.
            [self getTweets]; // call a method to request relevant tweets.
        }
        return;
    }
    /*
     //  If it is the connection for the woeid retrieve the woeid and get tags around that area
     //  by calling /trends/place.json
     if(conn == getWoeidConnection){
     NSError *error;
     if (![responseData length] == 0) {
     results = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
     } else{
     results = nil;
     NSLog(@"Error. No data\n");
     }
     //  NSLog(@"twitter woeid results:%@", results);
     if ([results valueForKey:@"woeid"]){
     woeid = [[results valueForKey:@"woeid"] objectAtIndex:0];
     [self getTags];
     }
     }
     
     //  If it is the connection for the tags retrieve the tags and get the tweets for them
     //  by calling the search/tweets/json
     if(conn == getTagsConnection){
     NSError *error;
     NSMutableArray *trends = [NSMutableArray new];
     if (![responseData length] == 0) {
     results = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
     } else{
     results = nil;
     NSLog(@"Error. No data\n");
     return;
     }
     //  NSLog(@"twitter tags results:%@", results);
     NSDictionary *trendResults = [results valueForKey:@"trends"];
     NSArray *names = [trendResults valueForKey:@"name"];
     NSArray *names2 = [names objectAtIndex:0];
     for (NSString *name in names2){
     if ([[name substringToIndex:1] isEqual: @"#"]){
     trendsString = [[trendsString stringByAppendingString:@"%23"] stringByAppendingString: [[name substringFromIndex:1] stringByAppendingString:@"+"]];
     [trends addObject:name];
     }
     }
     NSLog(@"trendsString:%@", trendsString);
     if (trends.count > 0){
     [self getTweets];
     }
     }
     */
    //  If it is the connection for the tweets retrieve the tweets
    if(conn == getTweetsConnection){
        //  The error to use
        NSError *error;
        //  Check for length of response
        if (![responseData length] == 0) {
            //  Create the JSON object
            results = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
            //  Initialize the array for the tweets with photos
            twitterPhotosArray = [NSMutableArray arrayWithCapacity:results.count];
            
            //      NSLog(@"twitter tweets results:%@", results);
            // Retrieve the tweets
            for (NSDictionary *tweet in [results valueForKey:@"statuses"]){
                //  NSLog(@"*******************************tweet**********************************");
                for(NSDictionary *field in tweet){
                    // Photos, if there, are in the entities tag...
                    if([field  isEqual: @"entities"]){
                        for(NSDictionary *entity in [tweet valueForKey:@"entities"]){
                            //  ...in the media tag...
                            if([entity isEqual:@"media"]){
                                for(NSDictionary *medium in [[tweet valueForKey:@"entities"] valueForKey:@"media"]){
                                    //  if type == photo, allocate, initialize and then set the TwitterPhoto
                                    if([medium[@"type"]  isEqual: @"photo"]){
                                        //  Create the Twitter photo object
                                        TwitterPhoto *twitterPhoto = [TwitterPhoto new];
                                        
                                        twitterPhoto.entities = [tweet valueForKey:@"entities"];
                                        twitterPhoto.hashtags = [[tweet valueForKey:@"entities"] valueForKey:@"hashtags"];
                                        twitterPhoto.media_url = medium[@"media_url"];
                                        twitterPhoto.tweet_url = medium[@"url"];
                                        
                                        twitterPhoto.user = [tweet valueForKey:@"user"];
                                        twitterPhoto.user_description = [[tweet valueForKey:@"user"] valueForKey:@"description"];
                                        twitterPhoto.username = [[tweet valueForKey:@"user"] valueForKey:@"name"];
                                        twitterPhoto.user_profile_image_url = [[tweet valueForKey:@"user"] valueForKey:@"profile_image_url"];
                                        twitterPhoto.screenname = [[tweet valueForKey:@"user"] valueForKey:@"screen_name"];
                                        
                                        twitterPhoto.place = [tweet valueForKey:@"place"];
                                        twitterPhoto.place_full_name = [[tweet valueForKey:@"place"] valueForKey:@"full_name"];
                                        twitterPhoto.place_country = [[tweet valueForKey:@"place"] valueForKey:@"country"];
                                        
                                        twitterPhoto.coordinates = [tweet valueForKey:@"coordinates"];
                                        twitterPhoto.tweet_id = [tweet valueForKey:@"id"];
                                        twitterPhoto.text = [tweet valueForKey:@"text"];
                                        twitterPhoto.created_at = [tweet valueForKey:@"created_at"];
                                        twitterPhoto.favorite_count = [tweet valueForKey:@"favorite_count"];
                                        twitterPhoto.retweet_count = [tweet valueForKey:@"retweet_count"];
                                        twitterPhoto.tweet_source = [tweet valueForKey:@"source"];
                                        
                                        //  Add the TwitterPhoto object to the array to be returned
                                        [twitterPhotosArray addObject:twitterPhoto];
                                    }
                                }
                            }
                        }
                    }
                }
            }
            //  Delegate method to be implemented for array with tweets containing photos to be received
            [self.delegate twitterConnectiondidFinishLoadingWithPhotos:twitterPhotosArray];
            
        } else{
            results = nil;
            NSLog(@"Error. No data\n");
            // Delegate method for error handling
            [self.delegate twitterConnectiondidFinishLoadingWithPhotos:nil];
        }
    }
}

#pragma mark - The methods for retrieving tweets for closest trends
/* Not used right now, we just retrieve tweets within a certain radius from the user
 -(void)getWoeid{
 //  The url for closest trends
 NSString *closest = [NSString stringWithFormat:@"https://api.twitter.com/1.1/trends/closest.json?lat=%f&long=%f", coordinates.latitude, coordinates.longitude];
 
 //  The NSURL
 NSURL *url = [NSURL URLWithString:closest];
 
 //  The NSMutableURLRequest
 NSMutableURLRequest *twitterrequest = [NSMutableURLRequest requestWithURL:url];
 
 // The twitterrequest
 [twitterrequest addValue:[NSString stringWithFormat:@"Bearer %@",bearerToken] forHTTPHeaderField:@"Authorization"];
 [twitterrequest setHTTPMethod:@"GET"];
 
 //  Allocate and initialize the twitter connection
 getWoeidConnection = [[NSURLConnection alloc] initWithRequest:twitterrequest delegate:self startImmediately:YES];
 }
 
 -(void)getTags{
 //  The url for getting the tags for the closest trends
 NSString *place = [NSString stringWithFormat:@"https://api.twitter.com/1.1/trends/place.json?id=%@", woeid];
 
 //  The NSURL
 NSURL *url = [NSURL URLWithString:place];
 
 //  The NSMutableURLRequest
 NSMutableURLRequest *twitterrequest = [NSMutableURLRequest requestWithURL:url];
 
 // The twitterrequest
 [twitterrequest addValue:[NSString stringWithFormat:@"Bearer %@",bearerToken] forHTTPHeaderField:@"Authorization"];
 [twitterrequest setHTTPMethod:@"GET"];
 
 //  Allocate and initialize the twitter connection
 getTagsConnection = [[NSURLConnection alloc] initWithRequest:twitterrequest delegate:self startImmediately:YES];
 }
 */
-(void)getTweets{
    //  The url for getting the tweets for the tags of the closest trends
    //  NSString *tweets = [NSString stringWithFormat:@"https://api.twitter.com/1.1/search/tweets.json?q=%@", trendsString ];
    NSString *tweets = [NSString stringWithFormat:@"https://api.twitter.com/1.1/search/tweets.json?q=&geocode=%f,%f,%dmi", coordinates.latitude, coordinates.longitude, 2];
    
    //  The NSURL
    NSURL *url = [NSURL URLWithString:tweets];
    
    //  The NSMutableURLRequest
    NSMutableURLRequest *twitterrequest = [NSMutableURLRequest requestWithURL:url];
    
    // The twitterrequest
    [twitterrequest addValue:[NSString stringWithFormat:@"Bearer %@",bearerToken] forHTTPHeaderField:@"Authorization"];
    [twitterrequest setHTTPMethod:@"GET"];
    
    //  Allocate and initialize the twitter connection
    getTweetsConnection = [[NSURLConnection alloc] initWithRequest:twitterrequest delegate:self startImmediately:YES];
    
    //  Release the responseData
    if (!getTweetsConnection) {
        responseData = nil;
        NSLog(@"nsUrlConnection failed");
    }
}

@end
