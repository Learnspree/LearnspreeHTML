//
//  LearnspreeHTMLAppDelegate.m
//  LearnspreeHTML
//
//  Created by James O'Connell on 01/02/2012.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "LearnspreeHTMLAppDelegate.h"
#import "CategoryViewController.h"
//#import "FlurryAnalytics.h"

// private helper methods
@interface LearnspreeHTMLAppDelegate (PrivateMethods)
- (void)createSubViewsFromCommands;
@end

@implementation LearnspreeHTMLAppDelegate


@synthesize controllers;
@synthesize window=_window;

@synthesize tabBarController=_tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // initiate flurry
    //[FlurryAnalytics setSessionReportsOnCloseEnabled:false];
    //[FlurryAnalytics startSession:@"D7W187YTQYI7N6CFYRY3"];
    
    // read the commands (.plist) file and create/populate sub-views based on the contents
	[self createSubViewsFromCommands];
    [self.tabBarController setViewControllers:self.controllers animated:YES];
    
    // add navigation controller to flurry
    //[FlurryAnalytics logAllPageViews:self.tabBarController];
    
    // Override point for customization after application launch.
    // Add the tab bar controller's current view as a subview of the window
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    self.controllers = nil;
    [self createSubViewsFromCommands];
    [self.tabBarController setViewControllers:self.controllers animated:YES];
}

- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    [controllers release];
    [super dealloc];
}

#pragma mark -
#pragma mark Helper Methods


- (void)createSubViewsFromCommands {
    
	// array to hold list of controllers
	NSMutableArray *array = [[NSMutableArray alloc] init];
	
    // create dictionary from plist/xml file
	NSString *commandListPath = [[NSBundle mainBundle] pathForResource:@"Commands" ofType:@"plist"];
	NSDictionary *mainDict = [[NSDictionary alloc] initWithContentsOfFile:commandListPath];
	
	// get the array of keys in the dictionary which we will iterate over to create each category controller
	NSArray *categoryArray = [[mainDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
	for (id category in categoryArray) {
        
        // get the dictionary which holds the properties of each command category
        NSDictionary *categoryDict = [[NSDictionary alloc] initWithDictionary:[mainDict valueForKey:category]];
        
		// get the commands for this category (an array of dictionaries)
		NSArray *commands = [[NSArray alloc] initWithArray:[categoryDict valueForKey:@"Commands"]];
		NSString *tabBarImageName = [[NSString alloc] initWithString:[categoryDict valueForKey:@"Image"]];
        
        // get sub-categories for this category
        NSDictionary *categories = [[NSDictionary alloc] initWithDictionary:[categoryDict valueForKey:@"Categories"]];
        
		// create the category view controller
		CategoryViewController *viewController = [[CategoryViewController alloc] initWithStyle:UITableViewStylePlain];
		viewController.title = category;
		viewController.commandList = commands;
        viewController.categoryList = categories;
        UIImage* tabBarImage = [UIImage imageNamed:tabBarImageName];
        
        // create tab-bar tab for top-level category
        viewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:category image:tabBarImage tag:0];
        
        // create navigation (hierarchical) controller view for drilling down the top level category. Colour black.
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
        navController.navigationBar.tintColor = [UIColor colorWithRed:.1 green:.1 blue:.1 alpha:2];
		
		// add controller to list
		[array addObject:navController];
        
        // add navigation controller to flurry
        //[FlurryAnalytics logAllPageViews:navController];
        
        // release resources not needed anymore
        [navController release];
		[viewController release];
		[commands release];
        [categories release];
        [tabBarImageName release];
        [categoryDict release];
	}
    
    
	// save the generated list of controllers
	self.controllers = array;
	
    // release resources not needed anymore
	[mainDict release];
	[array release];
}


@end