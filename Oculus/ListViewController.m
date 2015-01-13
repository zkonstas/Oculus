//
//  ResultsTableViewController.m
//  Zplaces
//
//  Created by Zissis Konstas on 3/29/14.
//  Copyright (c) 2014 Acme. All rights reserved.
//

#import "ListViewController.h"
#import "PhotoListItem.h"
#import "InstaPhoto.h"
#import "UIImageView+WebCache.h"
#import "DetailViewController.h"
#import "InstagramConnection.h"

@interface ListViewController () {
    BOOL gotOffset;
    BOOL reloadingData;
    CGFloat initialPosition;
}

//Property to hold the selected Venue data
@property(assign)NSIndexPath *pathTapped;
@property MBProgressHUD *hud;

@end

@implementation ListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Assign gotOffset
    gotOffset = NO;
    reloadingData = NO;
    
}


- (void)viewWillAppear:(BOOL)animated
{
    if( (!self.instaPhotos || self.instaPhotos.count==0) && (!self.twitterPhotos || self.twitterPhotos.count==0) ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No results yet!"
                                                        message:@"Switch to the search tab and try again."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.instaPhotos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"InstaPhoto";
    
        
    //dequeue cell so we can modify it
    PhotoListItem *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
    //match the datasource to the indexpath of the TableView
    InstaPhoto *photo = self.instaPhotos[indexPath.row];
        
    //Assign Time Taken
    NSString *time_created = photo.photo_created_time;
    cell.time_taken.text = [Utilities  timeAgo:time_created photoObject:photo];
    
    //Retrieve closest location and assign it
    cell.location_name.text = photo.geoCodingLocation;
    
    //Assign username
    cell.username.text = photo.username;
    
    //Assign user photo
    [cell.profile_pic setImageWithURL:[NSURL URLWithString:photo.profile_picture_link] placeholderImage:[UIImage imageNamed:@"user_male2-32.png"] options:SDWebImageRefreshCached];
    
    //Assign main photo
    [cell.image setImageWithURL:[NSURL URLWithString:photo.low_res_url] placeholderImage:[UIImage imageNamed:@"background.png"]];
        
    return cell;
}


#pragma mark - TableCell delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.pathTapped = indexPath;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"fromList" sender:self];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView_
{
    CGFloat reloadOffset = 130;
    CGFloat actualPosition = scrollView_.contentOffset.y;
    
    //NSLog(@"%f", actualPosition);
    
    if(!gotOffset) {
        gotOffset = YES;
        initialPosition = scrollView_.contentOffset.y;
    }
    
    if ( !reloadingData && (initialPosition - actualPosition) > reloadOffset) {
        //  Make the call to Instagram
        
        InstagramConnection *instaConnection = [InstagramConnection new];
        instaConnection.delegate = self;
        [instaConnection getInstagramPhotosWithCoordinates:self.location withinDistance:self.distance];
        
        //Update reloading ui
        //Show updating location activity indicator
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.hud.mode = MBProgressHUDModeIndeterminate;
        self.hud.labelText = @"Updating Results...";
        
        reloadingData = YES;
    }
    
    if (actualPosition == initialPosition)
        reloadingData = NO;
}

#pragma mark - Instagram Connection Delegate
-(void)instagramConnectiondidFinishLoadingWithPhotos:(NSMutableArray *)data {
    NSLog(@"Instagram Photos Reloaded Successfully!");
    
    self.instaPhotos = data;
    
    [self.hud hide:YES];
    
    [self.tableView reloadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    
    if ([segue.identifier isEqualToString:@"fromList"]) {
        
        InstaPhoto *photo = self.instaPhotos[self.pathTapped.row];
        
        DetailViewController *receiver = segue.destinationViewController;
        receiver.photo = photo;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
