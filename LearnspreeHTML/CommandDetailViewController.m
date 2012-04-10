//
//  CommandDetailViewController.m
//  Learnspree HTML
//
//  Created by David Jackson on 17/04/2011.
//  Copyright 2011 learnspree.com. All rights reserved.
//

#import "CommandDetailViewController.h"
//#import "FlurryAnalytics.h"


// private helper methods
@interface CommandDetailViewController (PrivateMethods)
- (void)displayFormattedText:(NSString *)rawText;
- (void)displayExampleDemo:(NSString *)demoHtmlText;
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
@synthesize showDemo;




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

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Pop back to top level in navigation controller so that we can re-build hierarchy from there
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
	
    // check if we're showing a different command than last time we were shown
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
    
    // check if the html demo is worth showing in the demo segment
    // by checking if a head is in the example but no body - e.g. meta examples
    // also check special case for comment tag which has nothing to show
    NSRange bodyIndexRange = [self.commandExample rangeOfString:@"<body>"];
    NSRange headIndexRange = [self.commandExample rangeOfString:@"<head>"];
    if ((bodyIndexRange.location == NSNotFound && headIndexRange.location != NSNotFound) ||
        (self.showDemo == NO))
    {
        // hide "demo" segment
        [commandDisplaySegment setWidth:0.01 forSegmentAtIndex:2];
    }
    else
    {
        // show "demo" segment (might have been hidden last time)
        [commandDisplaySegment setWidth:0.0 forSegmentAtIndex:2];
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
    
    // flurry analytics data
    //NSMutableDictionary *flurryDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
    //                                  [self commandName], @"Command",
    //                                  nil];
    
    // show the correct command details according to selected segment
    switch(selectedSegmentIndex) {
        case 0:  
            [self displayFormattedText:commandLongDescription];
            //[FlurryAnalytics logEvent:@"VIEW DESCRIPTION" withParameters:flurryDictionary];
            break; 
        case 1:  
            [self displayFormattedText:commandExample];
            //[FlurryAnalytics logEvent:@"VIEW EXAMPLE" withParameters:flurryDictionary];
            break; 
        case 2:
            [self displayExampleDemo:commandExample];
            //[FlurryAnalytics logEvent:@"VIEW DEMO" withParameters:flurryDictionary];
            break;
        default: 
            break;
    }
}

// method to display the given text in the webuicontrol directly (as a demo)
- (void)displayExampleDemo:(NSString *)demoHtmlText {
    
    // create mutable string for final html
    NSMutableString* finalHtml = [NSMutableString stringWithCapacity:[demoHtmlText length]];
    
    // check for existance of a body, head tags
    NSRange bodyIndexRange = [demoHtmlText rangeOfString:@"<body>"];
    NSRange headIndexRange = [demoHtmlText rangeOfString:@"<head>"];
    NSRange htmlIndexRange = [demoHtmlText rangeOfString:@"<html>"];
    
    // if just a html snippet - surround in a full html document with styling to show it on a black background which the uiwebview has
    if (htmlIndexRange.location == NSNotFound && headIndexRange.location == NSNotFound && bodyIndexRange.location == NSNotFound)
    {
        [finalHtml appendFormat:@"%@%@%@", 
         @"<html><head><meta name='viewport' content='width=device-width; initial-scale=1.0; maximum-scale=1.0;'><style type=""text/css""> div.formatted { background-color:transparent; color: white;width:100%;overflow:hidden; font-family: verdana; font-size: 14px;   } div.formatted table { color: white; } </style></head><body><div class=""formatted""><p>", 
         demoHtmlText, 
         @"</p></div></body></html>"];
    }
    // if html example has a proper head and body, then insert meta-viewport and styling into header
    else if (headIndexRange.location != NSNotFound && bodyIndexRange.location != NSNotFound)
    {
        [finalHtml appendFormat:@"%@%@%@", 
         [demoHtmlText substringToIndex:headIndexRange.location + 6], 
         @"<meta name='viewport' content='width=device-width; initial-scale=1.0; maximum-scale=1.0;'><style type=""text/css""> body { background-color:transparent; color: white;width:100%;overflow:hidden;  font-family: verdana; font-size: 14px;   } </style>", 
         [demoHtmlText substringFromIndex:headIndexRange.location + 6]];
    }
    // if there is a body but no head, then create a new head and insert before body
    else if (headIndexRange.location == NSNotFound && bodyIndexRange.location != NSNotFound)
    {
        [finalHtml appendFormat:@"%@%@%@", 
         [demoHtmlText substringToIndex:bodyIndexRange.location], 
         @"<head><meta name='viewport' content='width=device-width; initial-scale=1.0; maximum-scale=1.0;'><style type=""text/css""> body { background-color:transparent;  color: white;width:100%;overflow:hidden;  font-family: verdana; font-size: 14px;  } </style></head>", 
         [demoHtmlText substringFromIndex:bodyIndexRange.location]];
    }
    else
    {
        // default case - shouldn't happen
        [finalHtml appendString:demoHtmlText];
    }
    
    // set final html for webview
    [self.commandLongDescriptionView loadHTMLString:finalHtml baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
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
                    [closeReplaceString release];
                }
                else
                {
                    // replace with specified replacement string
                    NSString *replaceString = [[NSString alloc] initWithString:[formatDict valueForKey:currentCharAsString]];
                    [finalHtml appendString:replaceString];
                    [replaceString release];
                    
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
                                @"<html><head><meta name='viewport' content='width=device-width; initial-scale=1.0; maximum-scale=1.0;'><style type=""text/css""> div.formatted { background-color:transparent; color: white;width:100%;overflow:hidden;font-family:", 
                                fontFamily, 
                                @";font-size:",
                                fontSize,
                                @"; font-weight:", 
                                fontWeight, 
                                @"    } </style></head><body><div class=""formatted""><p>", 
                                finalHtml, 
                                @"</p></div></body></html>"];
    
    
    [self.commandLongDescriptionView loadHTMLString:webViewContent baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
    
    // release resources
    [formatDict release];
}



@end
