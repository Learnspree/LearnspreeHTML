//
//  LSPAnalyticsUtils.h
//  ReformCore
//
//  Created by David Jackson on 18/02/2013.
//
//

#import <Foundation/Foundation.h>

@interface LSPAnalyticsUtils : NSObject

+ (void)setupAnalyticsForTrackingId:(NSString*)trackingId;
+ (void)registerScreenViewForScreenName:(NSString*)screenName;
+ (void)registerUserEventWithCategory:(NSString*)category eventName:(NSString*)name eventLabel:(NSString*)label;

@end
