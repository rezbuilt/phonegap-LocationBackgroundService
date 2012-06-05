/* IOS LOCATION PLUGIN
 * PhoneGap is available under *either* the terms of the modified BSD license *or* the
 * MIT License (2008). See http://opensource.org/licenses/alphabetical for full text.
 *
 * Copyright 2012 Michael Rzeznik. All rights reserved.
 * Copyright (c) 2012, Rezbuilt
 */

#import <Foundation/Foundation.h>
#import "CoreLocation/CoreLocation.h"
#import <sqlite3.h>
#ifdef CORDOVA_FRAMEWORK
    #import <Cordova/CDVPlugin.h>
    #import <Cordova/CDVPluginResult.h>
#else
    #import "CDVPlugin.h"
    #import "CDVPluginResult.h"
#endif


@interface CDVRezLocation : CDVPlugin {
    NSString* callbackID;
    CLLocationManager *locationManager;
    NSString   *message;
    sqlite3    *database;
    NSString   *sqliteFileName;
}
    
@property (nonatomic, copy) NSString* callbackID;
    - (void) print:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
    - (void) getPoints:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
    - (void) stop:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
@property(assign,nonatomic) CLLocationManager *locationManager;

-(NSString *) getDatabaseFullPath;

@end
