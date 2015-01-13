//
//  DetailViewController.m
//  Oculus
//
//  Created by Zissis Konstas on 4/30/14.
//  Copyright (c) 2014 Acme. All rights reserved.
//

#import "DetailViewController.h"
#import "InstaPhoto.h"
#import "UIImageView+WebCache.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

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

    [self updateData];
    
}

#pragma mark - Helpers

-(void)updateData {
    self.location.text = self.photo.geoCodingLocation;
    self.time.text = self.photo.time;
    
    //Assign Time Taken
    NSString *time_created = self.photo.photo_created_time;
    self.time.text = [Utilities timeAgo:time_created photoObject:self.photo];
    
    
    self.username.text = self.photo.username;
    [self.imageLarge setImageWithURL:[NSURL URLWithString:self.photo.standard_res_url] placeholderImage:[UIImage imageNamed:@"background.png"]];

    [self.profilePic setImageWithURL:[NSURL URLWithString:self.photo.profile_picture_link] placeholderImage:[UIImage imageNamed:@"user_male2-32.png"] options:SDWebImageRefreshCached];
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
