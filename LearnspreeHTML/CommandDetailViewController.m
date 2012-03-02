//
//  CommandDetailViewController.m
//  Learnspree HTML
//
//  Created by David Jackson on 17/04/2011.
//  Copyright 2011 learnspree.com. All rights reserved.
//

#import "CommandDetailViewController.h"

// private helper methods
@interface CommandDetailViewController (PrivateMethods)
- (void)displayFormattedText:(NSString *)rawText;
- (void)displayCommandDetail:(int)selectedSegmentIndex;
@end

@implementation CommandDetailViewController

@synthesize commandLongDescriptionView;
@synthesize commandDisplaySegment;

@synthesize commandName;
@synthesize previousCommandName;
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
    self.view.backgroundColor = [UIColor blackColor]; 
    [commandLongDescriptionView setBackgroundColor:[UIColor blackColor]];
    
    // set up action for segment control
    [commandDisplaySegment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
}

// respond to rotation by resetting content
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self displayCommandDetail:[commandDisplaySegment selectedSegmentIndex]];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Pop back to top level in navigation controller so that we can re-build hierarchy from there
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
	
    if (commandName != previousCommandName)
    {
        // set default position of segment to the first option 
        // this view is re-used so we need to reset each time
        commandDisplaySegment.selectedSegmentIndex = 0;
        
        // set default text to show the command syntax
        self.title = commandName;
        [self displayFormattedText:commandLongDescription];
        
        // update previousCommandName
        self.previousCommandName = commandName;
    }
    

	[super viewWillAppear:animated];
}

// show the command detail appropriate to the selected segment
-(void) segmentAction: (id) sender {
    [self displayCommandDetail:[sender selectedSegmentIndex]];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.commandLongDescriptionView = nil;
    self.commandDisplaySegment = nil;
	
	self.commandName = nil;
    self.previousCommandName = nil;
	self.commandDescription = nil;
	self.commandSyntax = nil;
	self.commandLongDescription = nil;
    self.commandExample = nil;
}


- (void)dealloc {
	
    [commandLongDescriptionView release];
    [commandDisplaySegment release];
	
	[commandName release];
    [previousCommandName release];
	[commandDescription release];
	[commandSyntax release];
	[commandLongDescription release];
    [commandExample release];
	
    [super dealloc];
}

#pragma mark -
#pragma mark Helper Methods

// method to display the appropriate information depending on the currently selected command segment
- (void)displayCommandDetail:(int)selectedSegmentIndex {
    switch(selectedSegmentIndex) {
        case 0:  
            [self displayFormattedText:commandLongDescription];
            break; 
        case 1:  
            [self displayFormattedText:commandExample];
            break; 
        case 2:
            [self displayFormattedText:commandSyntax];
            break;
        default: 
            break;
    }
}

// method to populate the uiwebview with formatted text
- (void)displayFormattedText:(NSString *)rawText {
    // create a mutable string initalized to the length of the raw text to be displayed
    int origLength = [rawText length];
    NSMutableString* finalHtml = [NSMutableString stringWithCapacity:origLength];
    
    // load the dictionary of translations to be made
	NSString *formatTextPath = [[NSBundle mainBundle] pathForResource:@"FormatText" ofType:@"plist"];
	NSDictionary *formatDict = [[NSDictionary alloc] initWithContentsOfFile:formatTextPath];
    NSArray *specialCharsArray = [[formatDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    // initialze previous, next and current characters
    unichar currentChar = ' ';
    unichar prevChar = ' ';
    unichar nextChar = ' ';
    unichar activeFormatChar = ' ';
    
    // initialize no-space character count - used to count how many characters since we last had a space
    // which would allow for a line-break (too many chars without a space and we go off the edge of the webview)
    int noBreakCount = 0;
    
    // iterate character by character, replacing as necessary
    for (int i = 0; i < origLength; i++) {
        // update character values
        currentChar = [rawText characterAtIndex:i];
        if (i > 0)
            prevChar = [rawText characterAtIndex:i-1];
        if (i < origLength - 1)
            nextChar = [rawText characterAtIndex:i+1];
        

        if (currentChar == ' ')
        {
            noBreakCount = 0;
            if (nextChar == ' ' || prevChar == ' ')
            {
                // two spaces in a row means indentation for html so use &nbsp
                // we don't want to always substitute &nbsp; for spaces because long sentences would not
                // wrap in browser in that case
                [finalHtml appendString:@"&nbsp;"];
            }
            else
                [finalHtml appendString:@" "];
        }
        else if (currentChar == '\n')
        {
            [finalHtml appendString:@"<br/>"];
            noBreakCount = 0;
        }
        else
        {
            noBreakCount++;
            
            // check if the current character should be replaced
            NSString *currentCharAsString = [[NSString alloc] initWithFormat:@"%C", currentChar ];
            if ([specialCharsArray indexOfObject:currentCharAsString] == NSNotFound)
            {
                // no replacement needed - add character to the string
                [finalHtml appendString:[NSString stringWithCharacters:&currentChar length:1]];
            }
            else
            {
                // check for a repeat of the char that started the current format <span>
                // e.g. useful for "quoted phrases"
                if (currentChar == activeFormatChar)
                {
                    // reset active char
                    activeFormatChar = ' ';
                    
                    // close <span> 
                    NSString *closeReplaceString = [[NSString alloc] initWithFormat:@"%C</span>",currentChar];
                    [finalHtml appendString:closeReplaceString];
                }
                else
                {
                    // replace with specified replacement string
                    NSString *replaceString = [[NSString alloc] initWithString:[formatDict valueForKey:currentCharAsString]];
                    [finalHtml appendString:replaceString];
                    
                    // save current active format char
                    activeFormatChar = currentChar;
                }
            }
            
            // check if we need to insert a <wbr> break option if we are going quite long without a space
            if (noBreakCount > 30)
            {
                noBreakCount = 0;
                [finalHtml appendString:@"<wbr/>"];
            }
        }
    }
    
    // set font style depending on whether we are showing code or a description of some kind
    NSString* fontFamily = @"courier";
    NSString* fontWeight = @"bold";
    NSString* fontSize = @"16px";
    
    if ([commandDisplaySegment selectedSegmentIndex] == 0)
    {
        fontFamily = @"verdana";
        fontWeight = @"normal";
        fontSize = @"14px";
    }
    
    // set final html for webview
    NSString* webViewContent = [[NSString alloc] initWithFormat:@"%@%@%@%@%@%@%@%@%@", 
                                @"<html><head><style type=""text/css""> div.formatted { background-color:transparent; color: white;width:100%;overflow:hidden;font-family:", 
                                fontFamily, 
                                @";font-size:",
                                fontSize,
                                @"; font-weight:", 
                                fontWeight, 
                                @"    } </style></head><body><div class=""formatted""><p>", 
                                finalHtml, 
                                @"</p></div></body></html>"];
    
    
    [self.commandLongDescriptionView loadHTMLString:webViewContent baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
}



@end
