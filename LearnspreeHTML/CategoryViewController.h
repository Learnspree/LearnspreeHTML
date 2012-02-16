//
//  CategoryViewController.h
//  Learnspree HTML
//
//  Created by David Jackson on 17/04/2011.
//  Copyright 2011 learnspree.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommandDetailViewController;

@interface CategoryViewController : UITableViewController {
	NSArray *commandList;
	CommandDetailViewController *childController;
    CategoryViewController *childCategoryController;
    NSDictionary *categoryList;
}

@property (nonatomic,retain) NSArray *commandList;
@property (nonatomic, retain) NSDictionary *categoryList;

@end
