//
//  SecondViewController.m
//  Oculus
//
//  Created by Dimitris Paidarakis on 4/14/14.
//  Copyright (c) 2014 Oculus. All rights reserved.
//

#import "MapViewController.h"
#import "InstagramConnection.h"
#import "TwitterConnection.h"
#import "InstaPhoto.h"
#import "TwitterPhoto.h"
#import "GooglePlacesConnection.h"
#import "SuggestionsTableViewCell.h"
#import "ListViewController.h"
#import "GeocodingConnection.h"
#import "GridViewController.h"
@import CoreLocation;
@import QuartzCore;
@import Social;


@interface MapViewController () {
    NSURLConnection *getTokenConnection;
    NSURLConnection *getWoeidConnection;
    NSURLConnection *getTagsConnection;
    NSURLConnection *getTweetsConnection;
    GooglePlacesConnection *googlePlacesConnection;
    ListViewController *listViewController;
    GridViewController *gridViewController;
    
    NSMutableData *responseData;
    NSDictionary *results;
    NSString *bearerToken;
    NSString *woeid;
    int distance;
    NSMutableArray *suggestionsDataSource;
    NSString *geocodingLocation;
    CLLocation *loc;
    
    //Property to hold latest photo timestamp
    NSString *latestTimestamp;
    
    NSString *searchLocation;
    CLLocationCoordinate2D coord2D;
}

@property(nonatomic, strong)CLLocationManager *locationManager;


@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //  Do any additional setup after loading the view.
    
    [self setTextField];
    
    [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    
    //  Allocate and initialize the location manager
    self.locationManager = [CLLocationManager new];
    
    //  Allocate and initialize the NSMutableData
    responseData = [NSMutableData new];
    
    //  Set delegate for the location manager
    self.locationManager.delegate = self;
    
    //  Start updating location
    [self.locationManager startUpdatingLocation];
    
    //  Set the distance
    distance = 5000; //maximum distance
    
    //  Add a target method to the search text field
    [self.searchTextField addTarget:self action:@selector(searchTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    //  Allocate and initialize the googlePlacesConnection
    googlePlacesConnection = [GooglePlacesConnection new];
    
    //  Allocate and initialize the datasource
    suggestionsDataSource = [NSMutableArray new];
    
    // searchTextField things...
    self.searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.searchTextField setReturnKeyType:UIReturnKeyGo];
    
    //  tableview things...
    self.suggestionsTableView.delegate = self;
    self.suggestionsTableView.dataSource = self;
    
    //  Set the delegate for the connection
    googlePlacesConnection.delegate = self;
    
    
    //Obtain pointer to ListViewController
    UITabBarController *tabBarController = self.tabBarController;
    UINavigationController *listViewNavController = tabBarController.viewControllers[1];
    listViewController = listViewNavController.viewControllers[0];
    
    //Obtain pointer to GridViewController
    UINavigationController *gridViewNavController = tabBarController.viewControllers[2];
    gridViewController = gridViewNavController.viewControllers[0];
    
    //  Add a gesture recognizer for when the textfield is not first responder
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissResponder)];
    
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}

//  Hide keyboard when tap in the background
-(void)dismissResponder {
    [self.searchTextField resignFirstResponder];
    self.mapView.hidden = NO;
}

//  Detect when search input changes
-(void)searchTextFieldDidChange:(BOOL)didChange{
    self.mapView.hidden = YES;
    NSString *input = self.searchTextField.text;
    if(!([input isEqual:@""])){
        [googlePlacesConnection getGooglePlacesAutoCompleteSuggestionsForQuery:input];
    } else {
        [suggestionsDataSource removeAllObjects];
        [self.suggestionsTableView reloadData];
        self.mapView.hidden = NO;
    }
}

#pragma mark - Google Places Autocomplete Delegate methods

-(void)googlePlacesConnectiondidFinishLoadingWithResults:(NSMutableArray *)results2{
    suggestionsDataSource = [results2 mutableCopy];
    [self.suggestionsTableView reloadData];
}

#pragma mark - Location Manager Delegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    //  Stop updating location
    [self.locationManager stopUpdatingLocation];
    //  NSLog(@"latitude, longitude:%f, %f", self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude);
    
    //  Create the CLLocation object
    loc = [[CLLocation alloc]initWithLatitude:self.locationManager.location.coordinate.latitude longitude:self.locationManager.location.coordinate.longitude];
    
    GeocodingConnection *geocodingConnection = [GeocodingConnection new];
    geocodingConnection.delegate = self;
    [geocodingConnection getClosestLocation:loc];
}

#pragma mark - Geocoding delegate

-(void)geocodingConnectiondidFinishLoadingWithResult:(NSString *)location{
    geocodingLocation = location;
    //NSLog(@"geocodingconnection did fininsh :%@", geocodingLocation);
    
    //  Make the call to Instagram
    InstagramConnection *instaConnection = [InstagramConnection new];
    instaConnection.delegate = self;
    [instaConnection getInstagramPhotosWithCoordinates:loc.coordinate withinDistance:distance];
    coord2D = loc.coordinate;
    
    //  Make the call to Twitter
    TwitterConnection *twitterConnection = [TwitterConnection new];
    twitterConnection.delegate = self;
    [twitterConnection getTwitterPhotosWithCoordinates:loc.coordinate];
    
}

#pragma mark - Instagram Connection Delegate
-(void)instagramConnectiondidFinishLoadingWithPhotos:(NSMutableArray *)data {
    
    //Succesfull fetch of Instagram Results
    NSLog(@"Instagram Photos Received Successfully!");
    
    //Pass results
    if(data)
        //  listViewController.instaPhotos = data;
        
        //  NSLog(@"instagram data:%@", data);
        for(InstaPhoto *photo in data){
            
            if(photo.locationString){
                photo.geoCodingLocation = photo.locationString;
            }
            else if(geocodingLocation) {
                photo.geoCodingLocation = geocodingLocation;
            }
            else {
                photo.geoCodingLocation = searchLocation;
            }
            
            
            /*
             NSLog([NSString stringWithFormat:@"attribution:%@", photo.attribution]);
             NSLog([NSString stringWithFormat:@"caption_created_time:%@", photo.caption_created_time]);
             NSLog([NSString stringWithFormat:@"full_name:%@",photo.full_name]);
             NSLog([NSString stringWithFormat:@"user_id:%@", photo.user_id]);
             NSLog([NSString stringWithFormat:@"profile_picture_link:%@", photo.profile_picture_link]);
             NSLog([NSString stringWithFormat:@"username:%@",photo.username]);
             NSLog([NSString stringWithFormat:@"caption_id:%@", photo.caption_id]);
             NSLog([NSString stringWithFormat:@"caption_text:%@", photo.caption_text]);
             NSLog([NSString stringWithFormat:@"comments:%@",photo.comments]);
             NSLog([NSString stringWithFormat:@"photo_created_time:%@", photo.photo_created_time]);
             NSLog([NSString stringWithFormat:@"filter:%@", photo.filter]);
             NSLog([NSString stringWithFormat:@"photo_id:%@",photo.photo_id]);
             NSLog([NSString stringWithFormat:@"likes:%@", photo.likes]);
             NSLog([NSString stringWithFormat:@"post_url:%@", photo.post_url]);
             NSLog([NSString stringWithFormat:@"insta location:%@",photo.location]);
             NSLog([NSString stringWithFormat:@"tags:%@", photo.tags]);
             NSLog([NSString stringWithFormat:@"caption_created_time:%@", photo.caption_created_time]);
             NSLog([NSString stringWithFormat:@"users_in_photo:%@",photo.users_in_photo]);
             
             
             */
        }
    
    //Update latestTimestamp
    latestTimestamp = ( (InstaPhoto *)data[0] ).photo_created_time;
    
    //Pass results to List View and Grid View
    if(data) {
        listViewController.instaPhotos = data;
        gridViewController.instaPhotos = data;
        
        listViewController.location = coord2D;
        listViewController.distance = distance;
        
        gridViewController.location = coord2D;
        gridViewController.distance = distance;
    }
    
}

#pragma mark - Twitter Connection Delegate
-(void)twitterConnectiondidFinishLoadingWithPhotos:(NSMutableArray *)data{
    //  No error so handle the tweets with the photos
    if (data != nil){
        //  Twitter photos are there
        if(data.count > 0){
            //  NSLog(@"twitter data:%@", data);
            
            for (TwitterPhoto *twitterPhoto in data){
                //  NSLog(@"user:%@", twitterPhoto.user);
                //  NSLog(@"metadata:%@", twitterPhoto.metadata);
                //  NSLog(@"source:%@", twitterPhoto.tweet_source);
                //NSLog(@"coordinates:%@", twitterPhoto.coordinates);
                //  NSLog(@"place:%@", twitterPhoto.place);
                //  NSLog(@"entities:%@", twitterPhoto.entities);
                //  NSLog(@"favorite_count:%@", twitterPhoto.favorite_count);
                //  NSLog(@"hashtags:%@", twitterPhoto.hashtags);
                //  NSLog(@"created_at:%@", twitterPhoto.created_at);
                if([twitterPhoto.coordinates valueForKey:@"coordinates"] != [NSNull null]){
                    //NSLog(@"twitter latitude:%@", [[twitterPhoto.coordinates valueForKey:@"coordinates"] objectAtIndex:0]);
                }
            }
            
        } else {
            NSLog(@"0 twitterPhotos");
        }
    }
    if(data) {
        listViewController.twitterPhotos = data;
        gridViewController.twitterPhotos = data;
    }
}


-(void)instagramConnectiondidFailWithErrorType:(NSString *)error_type andErrorCode:(NSString *)error_code andErrorMessage:(NSString *)error_message{
    NSLog(@"from delegate error_type:%@ and error_code:%@ and error_message:%@", error_type, error_code, error_message);
}

#pragma mark - UITableView Delegate methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [suggestionsDataSource count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"SuggestionsTableViewCell";
    SuggestionsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.indexpath = indexPath;
    searchLocation = suggestionsDataSource[indexPath.row][@"description"];
    cell.suggestionsLabel.text = suggestionsDataSource[indexPath.row][@"description"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //  Get the data from the row
    NSDictionary *data = suggestionsDataSource[indexPath.row];
    //  Get the reference
    NSString *reference = data[@"reference"];
    
    self.searchTextField.text = data[@"description"];
    
    if (reference){
        //  NSLog(@"reference:%@", reference);
        
        //  Make the new call for the place details
        [googlePlacesConnection getGooglePlaceDetailsForPlaceWithReference:reference];
    }
}

# pragma mark - Delegate for the call for the place details

-(void)googlePlacesConnectiondidFinishLoadingWithDetails:(NSDictionary *)location{
    //  NSLog(@"second VC location lat, lng:%@, %@", location[@"lat"], location[@"lng"]);
    NSString *lat = location[@"lat"];
    NSString *lng = location[@"lng"];
    
    //  Create the CLLocation object
    loc = [[CLLocation alloc]initWithLatitude:[lat doubleValue] longitude:[lng doubleValue]];
    
    GeocodingConnection *geocodingConnection = [GeocodingConnection new];
    geocodingConnection.delegate = self;
    [geocodingConnection getClosestLocation:loc];
}

-(void) setTextField {
    UIImage *glass = [UIImage  imageNamed : @"Eye.png" ];
    
    UIImageView * myView = [[ UIImageView  alloc ]  initWithImage :
                            glass];
    //Resize frame so that it fits exactly
    myView.frame = CGRectMake(0, 0, 34, 34);
    myView.contentMode = UIViewContentModeScaleToFill;
    
    [self.searchTextField  setLeftView :myView];
    [self.searchTextField   setLeftViewMode:UITextFieldViewModeAlways];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)searchIsChanging:(id)sender {
}
@end
