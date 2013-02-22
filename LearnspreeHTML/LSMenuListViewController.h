//
//  LSMenuListViewController.h
//  LearnspreeHTML
//
//  Created by David Jackson on 15/05/2012.
//  Copyright (c) 2012 Learnspree. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommandDetailViewController;

@interface LSMenuListViewController : UITableViewController {
    NSArray *commandList;
	CommandDetailViewController *childController;
    LSMenuListViewController *childCategoryController;
    NSDictionary *categoryList;
    
    // configurable member variables by subclasses
    CGFloat rowHeight;
    NSString *menuBackgroundImageName;
    NSString *aboutImageName;
    NSString *cellBackgroundImageName;
    UIColor *cellTextColor;
    UIColor *cellSubtextColor;
    UIFont *cellTextFont;
    UIFont *cellSubtextFont;
    BOOL analyticsEnabled;
    
    // configurable NIB resource names for MVC flexibility
    NSString *aboutViewNIBName;
    NSString *detailViewNIBName;
}

@property (nonatomic,retain) NSArray *commandList;
@property (nonatomic, retain) NSDictionary *categoryList;

- (IBAction)showAboutLearnspree:(id)sender;

@end
