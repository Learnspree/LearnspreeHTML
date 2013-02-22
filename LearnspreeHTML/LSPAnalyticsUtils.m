//
//  LSPAnalyticsUtils.m
//  ReformCore
//
//  Created by David Jackson on 18/02/2013.
//
//

#import "LSPAnalyticsUtils.h"
#import "GAI.h"

@implementation LSPAnalyticsUtils

// Initialize analytics based on the given unique tracking id
+ (void)setupAnalyticsForTrackingId:(NSString *)trackingId
{
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 15;
    // Optional: set debug to YES for extra debugging information.
    [GAI sharedInstance].debug = YES;
    // Create tracker instance.
    [[GAI sharedInstance] trackerWithTrackingId:trackingId];
}

// Register basic screen impression for given screen
+ (void)registerScreenViewForScreenName:(NSString*)screenName
{
    [[[GAI sharedInstance] defaultTracker] sendView:screenName];
}

// Register general user event
+ (void)registerUserEventWithCategory:(NSString*)category eventName:(NSString*)name eventLabel:(NSString*)label
{
    // default value to 0 - we don't use it
    [[[GAI sharedInstance] defaultTracker] sendEventWithCategory:category
                                                      withAction:name
                                                       withLabel:label
                                                       withValue:0];
}

@end
