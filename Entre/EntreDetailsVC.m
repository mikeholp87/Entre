//
//  EntreCheckinVC.m
//  Entre
//
//  Created by Michael Holp on 7/11/14.
//  Copyright (c) 2014 Fovnders. All rights reserved.
//

#import "EntreDetailsVC.h"
#import "MapPoint.h"
#import "EntreCheckinVC.h"
#import "ASIFormDataRequest.h"
#import <QuartzCore/QuartzCore.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>

@implementation EntreDetailsVC

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
    
    UIView *logoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 21)];
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120, 21)];
    logo.image = [UIImage imageNamed:@"entre-logo.png"];
    [self.view addSubview:logoView];
    [logoView addSubview:logo];
    self.navigationItem.titleView = logoView;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:173/255.0 green:216/255.0 blue:199/255.0 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UIButton *checkinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [checkinBtn setFrame:CGRectMake(34, 270, 252, 42)];
    [checkinBtn addTarget:self action:@selector(checkinNow:) forControlEvents:UIControlEventTouchUpInside];
    checkinBtn.backgroundColor = [UIColor colorWithRed:173/255.0 green:216/255.0 blue:199/255.0 alpha:1.0];
    if([self.type isEqualToString:@"Renew"])
        [checkinBtn setTitle:@"I'M HERE TO RENEW" forState:UIControlStateNormal];
    else
        [checkinBtn setTitle:@"I'M HERE TO WORK" forState:UIControlStateNormal];
    checkinBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
    checkinBtn.titleLabel.textColor = [UIColor blackColor];
    checkinBtn.layer.cornerRadius = 10.0;
    checkinBtn.layer.masksToBounds = TRUE;
    [self.view addSubview:checkinBtn];
    
    self.nameLabel.text = self.placeName;
    self.phoneLabel.text = self.phone.length == 0 ? @"PHONE: Not available" : [NSString stringWithFormat:@"PHONE: %@",self.phone];
    self.hoursLabel.text = self.hours.length == 0 ? @"HOURS: Not available" : [NSString stringWithFormat:@"HOURS: %@",self.hours];
    [self.webView loadHTMLString:self.excerpt baseURL:[NSURL URLWithString:@"www.entre.co"]];
    
    [self setPlaceLocation];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = @"";
}

- (void)checkinNow:(id)sender
{
    //[self postToTwitterInBackground];
    
    EntreCheckinVC *checkin = [self.storyboard instantiateViewControllerWithIdentifier:@"EntreCheckin"];
    checkin.content = self.content;
    [self.navigationController pushViewController:checkin animated:YES];
}

- (void)setPlaceLocation
{
    [self fetchCoordinateFromAddress:self.address];
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    [mapView selectAnnotation:[[mapView annotations] lastObject] animated:YES];
}

- (void)fetchCoordinateFromAddress:(NSString *)address
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:address completionHandler:^(NSArray* placemarks, NSError* error){
        if (placemarks && placemarks.count > 0) {
            CLPlacemark *topResult = [placemarks objectAtIndex:0];
            MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:topResult];
            
            MKCoordinateRegion region;
            region.center.latitude = placemark.coordinate.latitude;
            region.center.longitude = placemark.coordinate.longitude;
            region.span.latitudeDelta = 0.05;
            region.span.longitudeDelta = 0.05;
            region = [self.mapView regionThatFits:region];
            [self.mapView setRegion:region animated:NO];
            
            MapPoint *annotation = [[MapPoint alloc] initWithCoordinate:placemark.coordinate title:address];
            [self.mapView addAnnotation:annotation];
        }
    }];
}

- (void)postToTwitterInBackground {
    // Create an account store object.
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    
    // Create an account type that ensures Twitter accounts are retrieved.
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    // Request access from the user to use their Twitter accounts.
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        if(granted) {
            // Get the list of Twitter accounts.
            NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
            
            if ([accountsArray count] > 0) {
                // Grab the initial Twitter account to tweet from.
                ACAccount *twitterAccount = [accountsArray objectAtIndex:0];
                SLRequest *postRequest = nil;
                
                // Post Text
                //NSDictionary *message = @{@"status": @"Success: This is an automatic tweet when user enters a certain region inside @entreapp RT @atx @seobrien"};
                NSDictionary *message = @{@"status": @"Testing"};
                
                // URL
                NSURL *requestURL = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/update.json"];
                
                // Request
                postRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:requestURL parameters:message];
                
                // Set Account
                postRequest.account = twitterAccount;
                
                // Post
                [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    NSLog(@"Twitter HTTP response: %li", (long)[urlResponse statusCode]);
                }];
            }
        }
    }];
}

@end
