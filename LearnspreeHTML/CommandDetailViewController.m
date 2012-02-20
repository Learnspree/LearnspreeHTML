//
//  CommandDetailViewController.m
//  Learnspree HTML
//
//  Created by David Jackson on 17/04/2011.
//  Copyright 2011 learnspree.com. All rights reserved.
//

#import "CommandDetailViewController.h"


@implementation CommandDetailViewController

@synthesize commandLongDescriptionLabel;
@synthesize commandDisplaySegment;

@synthesize commandName;
@synthesize commandDescription;
@synthesize commandSyntax;
@synthesize commandLongDescription;
@synthesize commandExample;



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return YES;
}

// viewdidload - set background image
- (void)viewDidLoad {
    
    // background view (image)
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"fabric.png"]];
    
    // set up action for segment control
    [commandDisplaySegment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Pop back to top level in navigation controller so that we can re-build hierarchy from there
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
	
    // set default position of segment to the first option 
    // this view is re-used so we need to reset each time
    commandDisplaySegment.selectedSegmentIndex = 0;
    
    // set default text to show the command syntax
    self.title = commandName;
	commandLongDescriptionLabel.text = commandLongDescription;

	[super viewWillAppear:animated];
}

-(void) segmentAction: (id) sender {
    switch([sender selectedSegmentIndex] + 1) {
        case 1: 
            [commandLongDescriptionLabel setText:commandLongDescription]; 
            break; 
        case 2: 
            [commandLongDescriptionLabel setText:commandExample]; 
            break; 
        case 3:
            [commandLongDescriptionLabel setText:commandSyntax]; 
            break;
        default: 
            break;
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.commandLongDescriptionLabel = nil;
    self.commandDisplaySegment = nil;
	
	self.commandName = nil;
	self.commandDescription = nil;
	self.commandSyntax = nil;
	self.commandLongDescription = nil;
    self.commandExample = nil;
}


- (void)dealloc {
	
	[commandLongDescriptionLabel release];
    [commandDisplaySegment release];
	
	[commandName release];
	[commandDescription release];
	[commandSyntax release];
	[commandLongDescription release];
    [commandExample release];
	
    [super dealloc];
}


@end
