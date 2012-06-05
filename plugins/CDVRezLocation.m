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

-(void)print:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
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

@end

