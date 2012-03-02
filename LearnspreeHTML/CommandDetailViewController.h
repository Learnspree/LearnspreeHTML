//
//  CommandDetailViewController.h
//  Learnspree HTML
//
//  Created by David Jackson on 17/04/2011.
//  Copyright 2011 learnspree.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CommandDetailViewController : UIViewController {

    UIWebView *commandLongDescriptionView;
    UISegmentedControl *commandDisplaySegment;
	
	NSString *commandName;
    NSString *previousCommandName;
	NSString *commandDescription;
	NSString *commandSyntax;
	NSString *commandLongDescription;
    NSString *commandExample;
}

@property (nonatomic, retain) IBOutlet UIWebView *commandLongDescriptionView;
@property (nonatomic, retain) IBOutlet UISegmentedControl *commandDisplaySegment;

@property (nonatomic, retain) NSString *previousCommandName;
@property (nonatomic, retain) NSString *commandName;
@property (nonatomic, retain) NSString *commandDescription;
@property (nonatomic, retain) NSString *commandSyntax;
@property (nonatomic, retain) NSString *commandLongDescription;
@property (nonatomic, retain) NSString *commandExample;

@end
