//
//  GridViewController.m
//  Zplaces
//
//  Created by Zissis Konstas on 4/29/14.
//  Copyright (c) 2014 Acme. All rights reserved.
//

#import "GridViewController.h"
#import "GridCell.h"
#import "UIImageView+WebCache.h"
#import "InstaPhoto.h"
#import "DetailViewController.h"
#import "InstagramConnection.h"

@interface GridViewController (){
    BOOL gotOffset;
    BOOL reloadingData;
    CGFloat initialPosition;
}

@property(assign)NSIndexPath *pathTapped;
@property MBProgressHUD *hud;

@end

@implementation GridViewController

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

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.instaPhotos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"PhotoCell";
    
    GridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    //match the datasource to the indexpath of the TableView
    InstaPhoto *photo = self.instaPhotos[indexPath.row];

    [cell.cellImage setImageWithURL:[NSURL URLWithString:photo.low_res_url] placeholderImage:[UIImage imageNamed:@"background.png"]];
    
    return cell;
}

#pragma mark - Table View UI Methods

- (void)collectionView:(UITableView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.pathTapped = indexPath;
    //[collectionView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"fromGrid" sender:self];
    
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
    
    [self.collectionView reloadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    
    if ([segue.identifier isEqualToString:@"fromGrid"]) {
        
        InstaPhoto *photo = self.instaPhotos[self.pathTapped.row];
        
        DetailViewController *receiver = segue.destinationViewController;
        receiver.photo = photo;
    }
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

@end
