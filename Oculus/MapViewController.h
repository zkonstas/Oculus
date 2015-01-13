//
//  SecondViewController.h
//  Oculus
//
//  Created by Dimitris Paidarakis on 4/14/14.
//  Copyright (c) 2014 Oculus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InstagramConnection.h"
#import "TwitterConnection.h"
#import "GooglePlacesConnection.h"
@import MapKit;

@interface MapViewController : UIViewController<CLLocationManagerDelegate, InstagramConnectionDelegate, TwitterConnectionDelegate, GooglePlacesConnectionDelegate,UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, MKMapViewDelegate,GeocodingConnectionDelegate>

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
- (IBAction)searchIsChanging:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *suggestionsTableView;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end
