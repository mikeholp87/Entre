//
//  EntreGeofence.h
//  Entre
//
//  Created by Michael Holp on 7/11/14.
//  Copyright (c) 2014 Fovnders. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface EntreGeofence : NSObject<CLLocationManagerDelegate>

+ (EntreGeofence *)geofence;

@property(nonatomic,retain) CLLocationManager *locationManager;
@property(nonatomic,retain) NSArray *regionArray;

@end
