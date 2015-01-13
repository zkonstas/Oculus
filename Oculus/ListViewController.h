//
//  ResultsTableViewController.h
//  Zplaces
//
//  Created by Zissis Konstas on 3/29/14.
//  Copyright (c) 2014 Acme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InstagramConnection.h"

@interface ListViewController : UITableViewController <InstagramConnectionDelegate>

//Data Source for holding the results
@property(nonatomic, strong)NSMutableArray *instaPhotos;
@property(nonatomic, strong)NSMutableArray *twitterPhotos;
@property CLLocationCoordinate2D location;
@property int distance;

@end
