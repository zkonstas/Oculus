//
//  InstagramConnection.m
//  Oculus
//
//  Created by Dimitris Paidarakis on 4/14/14.
//  Copyright (c) 2014 Oculus. All rights reserved.
//

#import "InstagramConnection.h"
#import "InstaPhoto.h"
#import "InstaUser.h"
#import "InstaComment.h"
#import "GeocodingConnection.h"


@implementation InstagramConnection {
    NSURLConnection *nsUrlConnection;
    NSMutableData *responseData;
    NSMutableArray *instaPhotosArray;
    int distance;
    NSString *geoCodingLocation;
    
    NSString *latestTimestamp;
}

-(void)getInstagramPhotosWithCoordinates:(CLLocationCoordinate2D)coords
                          withinDistance:(int)dist {
    
    //NSLog(@"called Instagram API----------");
    //  Set the url for the Instagram call
    NSString *urlString = [NSString stringWithFormat:@"https://api.instagram.com/v1/media/search?lat=%f&lng=%f&distance=%d&client_id=%@", coords.latitude, coords.longitude, dist, @"2e41e7cee3b645d09a392d9a23b0b919"];
        
    //  Set the NSURL
    NSURL *nsURL = [NSURL URLWithString:urlString];
    
    //  Set the NSURLRequest
    NSURLRequest *nsUrlRequest = [NSURLRequest requestWithURL:nsURL];
    
    //  Allocate and initialize responseData
    responseData = [NSMutableData new];
    
    //  Make the call to Instagram API and get the response asynchronously
    nsUrlConnection = [[NSURLConnection alloc] initWithRequest:nsUrlRequest delegate:self startImmediately:YES];
    
    //  Release the responseData
    if (!nsUrlConnection) {
        responseData = nil;
        NSLog(@"nsUrlConnection failed");
    }
    
    //  Make the call for the geocoding results
    /*
    GeocodingConnection *geocodingConnection = [GeocodingConnection new];
    CLLocation *clLocation = [[CLLocation alloc] initWithLatitude:coords.latitude longitude:coords.longitude];
    [geocodingConnection getClosestLocation:clLocation];
     */
}

#pragma mark - GeocodingConnection delegate
/*
-(void)geocodingConnectiondidFinishLoadingWithResult:(NSString *)location{
    geoCodingLocation = location;
}
*/

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
    
    //  The error for the JSON parsing
    NSError *jsonError = nil;

    //  The NSDictionary from the parsed JSON
    NSDictionary *parsedJSON = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&jsonError];
        //  NSLog(@"parseJSON:%@", parsedJSON);
    
    //  Get the values for keys from the parsed JSON
    int responseCode = [[[parsedJSON objectForKey:@"meta"] objectForKey:@"code"] intValue];
    
    //  Get data when no error
    if (responseCode == 200) {
        NSDictionary *dictData = [parsedJSON objectForKey:@"data"];
        instaPhotosArray = [NSMutableArray arrayWithCapacity:dictData.count];
        if (dictData.count > 0) {
            //  Add each photo object to the mutable array
            for (NSDictionary *photo in dictData) {
                //  Check for nulls
                if(photo){
                    //  Allocate and initialize a new InstaPhoto
                    InstaPhoto *instaPhoto = [InstaPhoto new];
                    
                    //  Set the geocoding location
                    instaPhoto.geoCodingLocation = geoCodingLocation;
                    
                    //  Create the InstaPhoto
                    instaPhoto.attribution = [photo objectForKey:@"attribution"];
                    //  Check for nulls
                    if([photo objectForKey:@"caption"] != [NSNull null]){
                        instaPhoto.caption_created_time = [[photo objectForKey:@"caption"] objectForKey:@"created_time"];
                        instaPhoto.caption_text = [[photo objectForKey:@"caption"] objectForKey: @"caption_text"];
                        instaPhoto.full_name = [[[photo objectForKey:@"caption"] objectForKey: @"from"] objectForKey:@"full_name"];
                        instaPhoto.user_id = [[[photo objectForKey:@"caption"] objectForKey: @"from"] objectForKey:@"id"];
                        instaPhoto.profile_picture_link = [[[photo objectForKey:@"caption"] objectForKey: @"from"] objectForKey:@"profile_picture"];
                        instaPhoto.username = [[[photo objectForKey:@"caption"] objectForKey: @"from"] objectForKey:@"username"];
                        instaPhoto.caption_id = [[photo objectForKey:@"caption"] objectForKey: @"id"];
                    }
                    instaPhoto.comments = [photo objectForKey:@"comments"];
                    instaPhoto.photo_created_time = [photo objectForKey:@"created_time"];
                    instaPhoto.filter = [photo objectForKey:@"filter"];
                    instaPhoto.photo_id = [photo objectForKey:@"id"];
                    instaPhoto.low_res_height = [[[photo objectForKey:@"images"] objectForKey: @"low_resolution"] objectForKey:@"height"];
                    instaPhoto.low_res_url = [[[photo objectForKey:@"images"] objectForKey: @"low_resolution"] objectForKey:@"url"];
                    instaPhoto.low_res_width = [[[photo objectForKey:@"images"] objectForKey: @"low_resolution"] objectForKey:@"width"];
                    instaPhoto.standard_res_height = [[[photo objectForKey:@"images"] objectForKey: @"standard_resolution"] objectForKey:@"height"];
                    instaPhoto.standard_res_url = [[[photo objectForKey:@"images"] objectForKey: @"standard_resolution"] objectForKey:@"url"];
                    instaPhoto.standard_res_width = [[[photo objectForKey:@"images"] objectForKey: @"standard_resolution"] objectForKey:@"width"];
                    instaPhoto.thumbnail_res_height = [[[photo objectForKey:@"images"] objectForKey: @"thumbnail"] objectForKey:@"height"];
                    instaPhoto.thumbnail_res_url = [[[photo objectForKey:@"images"] objectForKey: @"thumbnail"] objectForKey:@"url"];
                    instaPhoto.thumbnail_res_width = [[[photo objectForKey:@"images"] objectForKey: @"thumbnail"] objectForKey:@"width"];
                    instaPhoto.likes = [photo objectForKey:@"likes"];
                    instaPhoto.post_url = [photo objectForKey:@"link"];
                    
                    if ([[photo objectForKey:@"location"] objectForKey:@"name"]) {
                        instaPhoto.locationString = [[photo objectForKey:@"location"] objectForKey:@"name"];
                    }
                    else
                        instaPhoto.locationString = nil;
                    
                    //Create a new CLLocation
                    NSString *latitude = photo[@"location"][@"latitude"];
                    NSString *longitude = photo[@"location"][@"longitude"];
                    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude.doubleValue longitude:longitude.doubleValue];
                    instaPhoto.location = location;
                    
                    
                    
                    instaPhoto.tags = [photo objectForKey:@"tags"];
                    instaPhoto.type = [photo objectForKey:@"type"];
                    instaPhoto.users_in_photo = [photo objectForKey:@"users_in_photo"];
                    
                    //  Add the instaPhoto to the NSMutableArray to be returned
                    [instaPhotosArray addObject:instaPhoto];
                }
                
                //  Allocate and initialize a new InstaUser
                InstaUser *instaUser = [InstaUser new];
                
                //  Create the InstaUser
                instaUser.full_name = [[photo objectForKey:@"user"] objectForKey: @"full_name"];
                instaUser.user_id = [[photo objectForKey:@"user"] objectForKey: @"id"];
                instaUser.profile_picture_link = [[photo objectForKey:@"user"] objectForKey: @"profile_picture"];
                instaUser.username = [[photo objectForKey:@"user"] objectForKey: @"username"];
                
                //TODO: do something with the user
                
                //  Retrieve the comments for the photo
                int count = (int)[[photo objectForKey:@"comments"] objectForKey: @"count"];
                if (count > 0){
                    for (NSDictionary *data in [[photo objectForKey:@"comments"] objectForKey: @"data"]){
                        if (data){
                            InstaComment *comment = [InstaComment new];
                            comment.created_time = [data objectForKey:@"created_time"];
                            comment.comment_id = [data objectForKey:@"id"];
                            comment.text = [data objectForKey:@"text"];
                            comment.full_name = [[data objectForKey:@"from"] objectForKey:@"full_name"];
                            comment.user_id = [[data objectForKey:@"from"] objectForKey:@"id"];
                            comment.profile_picture_link = [[data objectForKey:@"from"] objectForKey:@"profile_picture"];
                            comment.username = [[data objectForKey:@"from"] objectForKey:@"username"];
                        }
                    }
                    
                    
                    //TODO: do something with the comment
                }
            }
        }else {
            NSLog(@"No results found");
        }
        //  Call delegate to method to pass the array with the photos
        [self.delegate instagramConnectiondidFinishLoadingWithPhotos:instaPhotosArray];
        
    } else if (responseCode == 400) {
        //  NSLog(@"errot_type:%@, error_code:%@, error_message:%@", [[parsedJSON objectForKey:@"meta"] objectForKey:@"error_type"], [[parsedJSON objectForKey:@"meta"] objectForKey:@"code"], [[parsedJSON objectForKey:@"meta"] objectForKey:@"error_message"]);
        NSString *error_type = [[parsedJSON objectForKey:@"meta"] objectForKey:@"error_type"];
        NSString *error_code = [[parsedJSON objectForKey:@"meta"] objectForKey:@"code"];
        NSString *error_message = [[parsedJSON objectForKey:@"meta"] objectForKey:@"error_message"];
        
        //  Call delegate to method to pass the error
        [self.delegate instagramConnectiondidFailWithErrorType:error_type andErrorCode:error_code andErrorMessage:error_message];
    }
    
    //  Release the connection and the data object
    nsUrlConnection = nil;
    responseData = nil;
    
}


@end

