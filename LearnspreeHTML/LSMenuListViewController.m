//
//  LSMenuListViewController.m
//  Learnspree HTML
//
//  Created by David Jackson on 17/04/2012.
//  Copyright 2011 learnspree.com. All rights reserved.
//

#import "AboutViewController.h"
#import "LSMenuListViewController.h"
#import "CommandDetailViewController.h"
#import "LSPAnalyticsUtils.h"

@implementation LSMenuListViewController

@synthesize commandList;
@synthesize categoryList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Set defaults for member variables
        rowHeight = 45.0;
        menuBackgroundImageName = @"fabric.png";
        aboutImageName = @"42-mini-info.png";
        cellBackgroundImageName = @"tableCellBackBlue.png";
        cellTextColor = [UIColor whiteColor];
        cellSubtextColor = [UIColor blackColor];
        cellTextFont = [UIFont fontWithName:@"Courier-Bold" size:14];
        cellSubtextFont = [UIFont fontWithName:@"Courier" size:10];
        analyticsEnabled = YES;
        
        // Set defaults for NIB names
        aboutViewNIBName = @"AboutViewController";
        detailViewNIBName = @"CommandDetailViewController";
    }
    return self;
}

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
	
    [super viewDidLoad];
    
	// set table view appearance properties
	[[ self tableView] setRowHeight: rowHeight];
    [[ self tableView] setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	
	// background view (image)
	UIImage* backgroundImage = [UIImage imageNamed:menuBackgroundImageName];
	UIImageView* imageView = [[UIImageView alloc] initWithImage:backgroundImage];
	[[self tableView] setBackgroundView:imageView];
	[imageView release];
    
    // set about page button
    UIButton *aboutButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [aboutButton setImage:[UIImage imageNamed:aboutImageName] forState:UIControlStateNormal];
    [aboutButton addTarget:self action:@selector(showAboutLearnspree:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:aboutButton];
    [aboutButton release];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return YES;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (categoryList.count > 0)
        return categoryList.count;
    else
        return [commandList count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CategoryCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSUInteger row = [indexPath row];
    if (categoryList.count > 0)
    {
        // Configure the cell...
        NSString *categoryName = [[categoryList allKeys] objectAtIndex:row];
        cell.textLabel.text = categoryName;
    }
    else if (commandList.count > 0)
    {
        // Configure the cell...
        NSDictionary *commandDetails = [commandList objectAtIndex:row];
        cell.textLabel.text = [commandDetails valueForKey:@"CommandName"];
        cell.detailTextLabel.text = [commandDetails valueForKey:@"Description"];
    }
	
	// set background view
	UIImage* backgroundImage = [UIImage imageNamed:cellBackgroundImageName];
	UIImageView* imageView = [[UIImageView alloc] initWithImage:backgroundImage];
	cell.backgroundView = imageView;
	[imageView release];
	
    
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    // check if there is another level in the menu hierarchy
    if (categoryList.count > 0)
    {
        if (childCategoryController == nil)
            childCategoryController = [[LSMenuListViewController alloc] initWithStyle:UITableViewStylePlain];
        
        NSUInteger row = [indexPath row];
        NSDictionary *selectedCategoryDetails = [[categoryList allValues] objectAtIndex:row];
        NSString *selectedCategoryName = [[categoryList allKeys] objectAtIndex:row];
        
		// get the commands for this category (an array of dictionaries)
		NSArray *commands = [[NSArray alloc] initWithArray:[selectedCategoryDetails valueForKey:@"Commands"]];
        
        // get sub-categories for this category
        NSDictionary *categories = [[NSDictionary alloc] initWithDictionary:[selectedCategoryDetails valueForKey:@"Categories"]];
        
		// create the category view controller
		childCategoryController.title = selectedCategoryName;
		childCategoryController.commandList = commands;
        childCategoryController.categoryList = categories; 
        
        // reload the data in the child category controller
        [childCategoryController.tableView reloadData];
        
        // display the command view
        [self.navigationController pushViewController:childCategoryController animated:YES];
	}
    else
    {
        if (childController == nil)
            childController = [[CommandDetailViewController alloc] initWithNibName:detailViewNIBName bundle:nil];
        
        NSUInteger row = [indexPath row];
        
        // setup the command view
        NSDictionary *selectedCommand = [commandList objectAtIndex:row];
        childController.commandName = [selectedCommand valueForKey:@"CommandName"];
        childController.commandDescription = [selectedCommand valueForKey:@"Description"];	
        childController.commandLongDescription = [[selectedCommand valueForKey:@"LongDescription"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        childController.commandSyntax = [selectedCommand valueForKey:@"Syntax"];  
        childController.commandExample = [[selectedCommand valueForKey:@"Example"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        // set show-demo to false only if the command has a key "ShowDemo" set to NO
        if ([[selectedCommand valueForKey:@"ShowDemo"] isEqualToString:@"NO"])
        {
            childController.showDemo = NO;
        }
        else
        {
            childController.showDemo = YES;
        }
        
        // log analytics events
        if (analyticsEnabled)
        {
            [LSPAnalyticsUtils registerScreenViewForScreenName:childController.commandName];
        }
        
        // display the command view
        [self.navigationController pushViewController:childController animated:YES];
        
    }
    
	
}

// customize properties of cell labels
- (void) tableView: (UITableView *) tableView willDisplayCell: (UITableViewCell *)cell 
 forRowAtIndexPath: (NSIndexPath *) indexPath {
	
	// set colour of labels
	cell.textLabel.textColor = cellTextColor;
	cell.detailTextLabel.textColor = cellSubtextColor;
	
	// set fonts
	[cell.textLabel setFont:cellTextFont];
	[cell.detailTextLabel setFont:cellSubtextFont];
	
	// set accessory type
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Pop back to top level in navigation controller so that we can re-build hierarchy from there
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	
	self.commandList = nil;
	[childController release];
	childController = nil;
}


- (void)dealloc {
	[commandList release];
	[childController release];
	
    [super dealloc];
}

#pragma mark -
#pragma mark Helper Methods

// Show the about screen
-(IBAction)showAboutLearnspree:(id)sender
{
    AboutViewController* aboutViewController = [[AboutViewController alloc] initWithNibName:aboutViewNIBName bundle:nil];
    
    aboutViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:aboutViewController animated:YES completion:NULL];
    
    [aboutViewController release];
}




@end
