//
//  GridViewController.h
//  Zplaces
//
//  Created by Zissis Konstas on 4/29/14.
//  Copyright (c) 2014 Acme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InstagramConnection.h"

@interface GridViewController : UICollectionViewController <InstagramConnectionDelegate>

@property (strong, nonatomic) NSMutableArray *instaPhotos;
@property(nonatomic, strong)NSMutableArray *twitterPhotos;
@property CLLocationCoordinate2D location;
@property int distance;

@end
