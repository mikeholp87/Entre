//
//  EntreGeofence.m
//  Entre
//
//  Created by Michael Holp on 7/11/14.
//  Copyright (c) 2014 Fovnders. All rights reserved.
//

#import "EntreGeofence.h"

@implementation EntreGeofence

+ (EntreGeofence *)geofence {
    static EntreGeofence *geofence = nil;
    if (geofence == nil)
        geofence = [[EntreGeofence alloc] init];
    return geofence;
}

- (id)init
{
    self = [super init];
    if(self) {
        [self initializeLocationManager];
        NSArray *geofences = [self buildGeofenceData];
        [self initializeRegionMonitoring:geofences];
        [self initializeLocationUpdates];
    }
    return self;
}

- (void)initializeLocationManager {
    // Check to ensure location services are enabled
    if(![CLLocationManager locationServicesEnabled]) {
        [self showAlertWithMessage:@"You need to enable location services to use this app."];
        return;
    }
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
}


- (void)initializeRegionMonitoring:(NSArray*)geofences {
    
    if (_locationManager == nil) {
        [NSException raise:@"Location Manager Not Initialized" format:@"You must initialize location manager first."];
    }
    
    if(![CLLocationManager regionMonitoringAvailable]) {
        [self showAlertWithMessage:@"This app requires region monitoring features which are unavailable on this device."];
        return;
    }
    
    for(CLRegion *geofence in geofences) {
        [_locationManager startMonitoringForRegion:geofence];
    }
    
}

- (NSArray *)buildGeofenceData {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"regions" ofType:@"plist"];
    _regionArray = [NSArray arrayWithContentsOfFile:plistPath];
    
    NSMutableArray *geofences = [NSMutableArray array];
    for(NSDictionary *regionDict in _regionArray) {
        CLRegion *region = [self mapDictionaryToRegion:regionDict];
        [geofences addObject:region];
    }
    
    return [NSArray arrayWithArray:geofences];
}

- (CLCircularRegion *)mapDictionaryToRegion:(NSDictionary*)dictionary {
    NSString *title = [dictionary valueForKey:@"title"];
    
    CLLocationDegrees latitude = [[dictionary valueForKey:@"latitude"] doubleValue];
    CLLocationDegrees longitude =[[dictionary valueForKey:@"longitude"] doubleValue];
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
    
    CLLocationDistance regionRadius = [[dictionary valueForKey:@"radius"] doubleValue];
    
    return [[CLCircularRegion alloc] initWithCenter:centerCoordinate radius:regionRadius identifier:title];
}

- (void)initializeLocationUpdates {
    [_locationManager startUpdatingLocation];
}

#pragma mark - Location Manager - Region Task Methods

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSLog(@"Entered Region - %@", region.identifier);
    [self showRegionAlert:@"Entering Region" forRegion:region.identifier];
    [self sendLocalNotification];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSLog(@"Exited Region - %@", region.identifier);
    [self showRegionAlert:@"Exiting Region" forRegion:region.identifier];
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    NSLog(@"Started monitoring %@ region", region.identifier);
}

#pragma mark - Location Manager - Standard Task Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"%@",[NSString stringWithFormat:@"%f,%f",newLocation.coordinate.latitude, newLocation.coordinate.longitude]);
}
#pragma mark - Alert Methods

- (void)showRegionAlert:(NSString *)alertText forRegion:(NSString *)regionIdentifier {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:alertText message:regionIdentifier delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [message show];
}

- (void)showAlertWithMessage:(NSString*)alertText {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Location Services Error" message:alertText delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
}

- (void)sendLocalNotification
{
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    localNotif.fireDate = nil;
    localNotif.timeZone = [NSTimeZone systemTimeZone];
    localNotif.alertBody = @"You are Here";
    localNotif.alertAction = @"Checkin Now";
    localNotif.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
}

@end
