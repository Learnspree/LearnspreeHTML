//
//  AboutViewController.h
//  LearnspreeHTML
//
//  Created by David Jackson on 16/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController {
    
    UILabel* applicationNameLabel;
}

@property (nonatomic, retain) IBOutlet UILabel *applicationNameLabel;

- (IBAction)hideAboutLearnspree:(id)sender;

@end
