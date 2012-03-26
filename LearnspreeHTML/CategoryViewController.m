//
//  CategoryViewController.m
//  Learnspree HTML
//
//  Created by David Jackson on 17/04/2011.
//  Copyright 2011 learnspree.com. All rights reserved.
//

#import "AboutViewController.h"
#import "CategoryViewController.h"
#import "CommandDetailViewController.h"
#import "FlurryAnalytics.h"

@implementation CategoryViewController

@synthesize commandList;
@synthesize categoryList;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
	
    [super viewDidLoad];

	// set table view appearance properties
	[[ self tableView] setRowHeight: 45.0];
    [[ self tableView] setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	
	// background view (image)
	UIImage* backgroundImage = [UIImage imageNamed:@"fabric.png"];
	UIImageView* imageView = [[UIImageView alloc] initWithImage:backgroundImage];
	[[self tableView] setBackgroundView:imageView];
	[imageView release];
    
    // set about page button
    UIImage* aboutImage = [UIImage imageNamed:@"14-gear.png"];
    UIBarButtonItem *aboutButton = [[UIBarButtonItem alloc] initWithImage:aboutImage style:UIBarButtonItemStylePlain	 target:self action:@selector(showAboutLearnspree:)];          
    self.navigationItem.rightBarButtonItem = aboutButton;
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
	UIImage* backgroundImage = [UIImage imageNamed:@"tableCellBackBlue.png"];
	UIImageView* imageView = [[UIImageView alloc] initWithImage:backgroundImage];
	cell.backgroundView = imageView;
	[imageView release];
	
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	
    if (categoryList.count > 0)
    {
        if (childCategoryController == nil)
            childCategoryController = [[CategoryViewController alloc] initWithStyle:UITableViewStylePlain];
        
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
            childController = [[CommandDetailViewController alloc] initWithNibName:@"CommandDetailViewController" bundle:nil];
        
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
        
        // log flurry events
        [FlurryAnalytics logEvent:childController.commandName]; 
        NSMutableDictionary *flurryDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                 childController.commandName, @"Command",
                                                 nil];
        [FlurryAnalytics logEvent:@"VIEW DESCRIPTION" withParameters:flurryDictionary];
        
        
        // display the command view
        [self.navigationController pushViewController:childController animated:YES];
        
    }
    
	
}

// customize properties of cell labels
- (void) tableView: (UITableView *) tableView willDisplayCell: (UITableViewCell *)cell 
 forRowAtIndexPath: (NSIndexPath *) indexPath {
	
	// set colour of labels
	cell.textLabel.textColor = [UIColor whiteColor];
	cell.detailTextLabel.textColor = [UIColor blackColor];
	
	// set fonts
	[cell.textLabel setFont:[UIFont fontWithName:@"Courier-Bold" size:14]];
	[cell.detailTextLabel setFont:[UIFont fontWithName:@"Courier" size:10]];
	
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
    AboutViewController* aboutViewController = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
    
    aboutViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:aboutViewController animated:YES completion:NULL];
    
    [aboutViewController release];
}



@end

