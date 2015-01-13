//
//  ProfileViewController.h
//  Oculus
//
//  Created by Zissis Konstas on 5/4/14.
//  Copyright (c) 2014 Acme. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController

//Outlets
@property (strong, nonatomic) IBOutlet UIImageView *profilePic;
@property (strong, nonatomic) IBOutlet UILabel *name;

//Actions
- (IBAction)logout:(id)sender;


@end
