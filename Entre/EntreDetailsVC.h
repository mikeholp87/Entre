//
//  EntreCheckinVC.h
//  Entre
//
//  Created by Michael Holp on 7/11/14.
//  Copyright (c) 2014 Fovnders. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

typedef void (^ReverseGeoCompletionBlock)(NSString *city, NSString *state);

@interface EntreDetailsVC : UIViewController<MKMapViewDelegate, UIWebViewDelegate>

@property(assign) NSString *placeName;
@property(assign) NSString *address;
@property(assign) NSString *phone;
@property(assign) NSString *hours;
@property(assign) NSString *type;
@property(assign) NSString *protips;
@property(assign) NSString *excerpt;
@property(assign) NSString *content;
@property(assign) CLLocationCoordinate2D placeCoord;

@property(nonatomic,retain) NSURL *imageUrl;

@property(nonatomic,retain) IBOutlet UILabel *nameLabel;
@property(nonatomic,retain) IBOutlet UILabel *phoneLabel;
@property(nonatomic,retain) IBOutlet UILabel *hoursLabel;
@property(nonatomic,retain) IBOutlet UIWebView *webView;
@property(nonatomic,retain) IBOutlet MKMapView *mapView;

@end
