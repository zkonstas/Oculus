//
//  DetailViewController.h
//  Oculus
//
//  Created by Zissis Konstas on 4/30/14.
//  Copyright (c) 2014 Acme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InstaPhoto.h"

@interface DetailViewController : UIViewController

//Property to hold the photo
@property (strong, nonatomic) InstaPhoto *photo;

//Outlets
@property (strong, nonatomic) IBOutlet UIImageView *profilePic;
@property (strong, nonatomic) IBOutlet UIImageView *imageLarge;
@property (strong, nonatomic) IBOutlet UILabel *location;
@property (strong, nonatomic) IBOutlet UILabel *username;
@property (strong, nonatomic) IBOutlet UILabel *time;


@end
