//
//  MKSkinCareProgramTableViewController.m
//  MaryKay
//
//  Created by Charles Fisher on 4/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MKSkinCareProgramTableViewController.h"
#import "Mary_KayAppDelegate.h"

@implementation MKSkinCareProgramTableViewController
@synthesize mkclient;

- (void) update:(MKClient *)mk {
	[self setMkclient:mk];
	[self.tableView reloadData];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return @"Skin Care Program";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    Mary_KayAppDelegate *appDelegate = (Mary_KayAppDelegate *)[[UIApplication sharedApplication] delegate];
	return appDelegate.skinCareProgram.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	Mary_KayAppDelegate *appDelegate = (Mary_KayAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSString *skinCare = (NSString *)[appDelegate.skinCareProgram objectAtIndex:indexPath.row];
	
	[cell setText:skinCare];	
	
	// Check
	if([[self.mkclient.profile.skinCareProgram objectAtIndex:indexPath.row] boolValue]) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	} else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	
	//Mary_KayAppDelegate *appDelegate = (Mary_KayAppDelegate *)[[UIApplication sharedApplication] delegate];
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	
	if ([[self.mkclient.profile.skinCareProgram objectAtIndex:indexPath.row] boolValue]) {
		[self.mkclient.profile.skinCareProgram replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:NO]];
		cell.accessoryType = UITableViewCellAccessoryNone;
	} else {
		[self.mkclient.profile.skinCareProgram replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:YES]];
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
	[self.mkclient.profile updateMKProfile];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

