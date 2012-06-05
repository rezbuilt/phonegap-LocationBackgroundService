/* IOS LOCATION PLUGIN
 * PhoneGap is available under *either* the terms of the modified BSD license *or* the
 * MIT License (2008). See http://opensource.org/licenses/alphabetical for full text.
 *
 * Copyright 2012 Michael Rzeznik. All rights reserved.
 * Copyright (c) 2012, Rezbuilt
 */

#import "CDVRezLocation.h"
#import "JSON.h"

@implementation CDVRezLocation

@synthesize callbackID;
@synthesize locationManager;

char *sqliteError;

NSString *tableName    =   @"user_position";
NSString  *insertStatement;

-(void)getPoints:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
NSLog(@"getPoints");
self.callbackID = [arguments pop];
	NSMutableArray *array = [[NSMutableArray alloc] init];
	NSMutableArray *curRow;
    NSString *sql   = [[NSString alloc]initWithFormat:@"SELECT * FROM '%@'",tableName];
    sqlite3_stmt *sqlStatement;
    sqliteFileName  =   [self getDatabaseFullPath];

    if(sqlite3_open([sqliteFileName UTF8String], &database)==SQLITE_OK)
    {	
    if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &sqlStatement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(sqlStatement)==SQLITE_ROW)
        {
			curRow = [NSMutableArray array];

            double  latitudeData    =  sqlite3_column_double(sqlStatement, 1);
            double  longitudeData   =  sqlite3_column_double(sqlStatement, 2);
            
            NSString *returnLat    =   [NSString stringWithFormat:@"%f", latitudeData];
            NSString *returnLon    =   [NSString stringWithFormat:@"%f", longitudeData];
			
			[curRow addObject:returnLat];
			[curRow addObject:returnLon];
			[array addObject:curRow];

				
        }
	}
		
    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus: CDVCommandStatus_OK
                               messageAsArray: array
                               ];
    NSString* js = [result toSuccessCallbackString:self.callbackID];
    
    [self writeJavascript:js];		 

    }
}

-(void)stop:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
NSLog(@"stop");
    [locationManager stopUpdatingLocation];
}

-(void)start:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    if (nil == locationManager){
        locationManager = [[CLLocationManager alloc] init];
	}



    locationManager.delegate = self;

    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;

 

    // Set a movement threshold for new events.

    locationManager.distanceFilter = 250;

 	sqliteFileName  =   [self getDatabaseFullPath];

    [locationManager startUpdatingLocation];


    self.callbackID = [arguments pop];
    NSString *stringObtainedFromJavascript = [arguments objectAtIndex:0];
    NSMutableString *stringToReturn = [NSMutableString stringWithString: @"StringRecieved:"];
    [stringToReturn appendString: stringObtainedFromJavascript];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: [stringToReturn stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    if([stringObtainedFromJavascript isEqualToString:@"HelloWorld"] == YES){
        [self writeJavascript: [pluginResult toSuccessCallbackString:self.callbackID]];
    } else {
        [self writeJavascript: [pluginResult toErrorCallbackString:self.callbackID]];
    }
	
}
-(NSString *) getDatabaseFullPath
{
    NSArray *directoryPath      =   NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,TRUE);
    NSString *documentsDirectory =   [directoryPath objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"location.db"];
}


- (void)locationManager:(CLLocationManager *)manager

    didUpdateToLocation:(CLLocation *)newLocation

    fromLocation:(CLLocation *)oldLocation

{
NSLog(@"inside");
    NSString *newLatitude   =   [[NSString alloc]initWithFormat:@"%g",newLocation.coordinate.latitude];
    NSString *newLongitude  =   [[NSString alloc]initWithFormat:@"%g",newLocation.coordinate.longitude];
    sqliteFileName  =   [self getDatabaseFullPath];

    if(sqlite3_open([sqliteFileName UTF8String], &database)==SQLITE_OK)
    {
        NSLog(@"sqlite ok");
        NSString *sql   =   [[NSString alloc]initWithFormat:@"CREATE  TABLE  IF NOT EXISTS '%@' ('position_id' INTEGER PRIMARY KEY,'latitude' DOUBLE, 'longitude' DOUBLE, 'placeName' VARCHAR)",tableName];
        NSLog(@"after table");
        if(sqlite3_exec(database, [sql UTF8String], NULL, NULL, &sqliteError)==SQLITE_OK)
        {
		NSLog(@"executed");
            insertStatement   =  [[NSString alloc]initWithFormat:@"INSERT OR REPLACE INTO '%@'('%@','%@') VALUES('%@','%@')",tableName,@"latitude",@"longitude",newLatitude,newLongitude];
            if(sqlite3_exec(database, [insertStatement UTF8String], NULL, NULL, &sqliteError)==SQLITE_OK)
            {
                 NSLog(@"Location Inserted"); 
            }
        }
		
    }
	
// If it's a relatively recent event, turn off updates to save power
//    NSDate* eventDate = newLocation.timestamp;
//
//    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
//
//    if (abs(howRecent) < 15.0)
//
//    {
//
//        NSLog(@"latitude %+.6f, longitude %+.6f\n",
//
//                newLocation.coordinate.latitude,
//
//                newLocation.coordinate.longitude);
//  }
// else skip the event and process the next one.

}




@end

