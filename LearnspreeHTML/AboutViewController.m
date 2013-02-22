//
//  AboutViewController.m
//  LearnspreeHTML
//
//  Created by David Jackson on 16/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AboutViewController.h"

@implementation AboutViewController

@synthesize applicationNameLabel;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // set application name label
    NSString*	version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    //NSString*   appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
    NSString*   appDescription = [[NSString alloc] initWithFormat:@"Learnspree HTML5 v%@",  version];
    
    applicationNameLabel.Text = appDescription;
    
    [appDescription release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

#pragma mark - Events

-(IBAction)hideAboutLearnspree:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}


@end
