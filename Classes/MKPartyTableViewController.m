//
//  MKPartyTableViewController.m
//  MaryKay
//
//  Created by Charles Fisher on 5/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MKPartyTableViewController.h"
#import "Mary_KayAppDelegate.h"
#import "MKParty.h"
#import "MKPartyViewController.h"

@implementation MKPartyTableViewController
@synthesize MKPartyView;

- (void) viewDidLoad {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mkPartiesUpdated) name:MKPartiesUpdate object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mkPartiesUpdated) name:MKPartyUpdate object:nil];
}

- (void) mkPartiesUpdated {
	[self.tableView reloadData];
}

- (void) loadView {
	[super loadView];
	
	self.tableView.editing = YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath {
	return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (editingStyle == UITableViewCellEditingStyleDelete) 
    {
		// remove the row here.
		Mary_KayAppDelegate *appDelegate = (Mary_KayAppDelegate *)[[UIApplication sharedApplication] delegate];
		[appDelegate deleteMKParty:[appDelegate.mkparties objectAtIndex:indexPath.row]];
    }   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	Mary_KayAppDelegate *appDelegate = (Mary_KayAppDelegate *)[[UIApplication sharedApplication] delegate];
	return appDelegate.mkparties.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"MKPartyCell";
    
    cell = (MKPartyCellView *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"MKPartyCellView" owner:self options:nil]; 
	}

	// Set up the cell...
	Mary_KayAppDelegate *appDelegate = (Mary_KayAppDelegate *)[[UIApplication sharedApplication] delegate];
	MKParty *mk = (MKParty *)[appDelegate.mkparties objectAtIndex:indexPath.row];
	
	[cell update:mk];
	//[cell setText: [NSString stringWithFormat:@"Date   (%@)", [[mk host] firstName]]];
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic
	Mary_KayAppDelegate *appDelegate = (Mary_KayAppDelegate *)[[UIApplication sharedApplication] delegate];
	MKParty *mk = (MKParty *)[appDelegate.mkparties objectAtIndex:indexPath.row];
	
	if(self.MKPartyView == nil) {
		MKPartyViewController *viewController = [[MKPartyViewController alloc] initWithNibName:@"MKPartyView" bundle:nil];
		self.MKPartyView = viewController;
		[viewController release];
	}
	
	[appDelegate.mkPartyNavigation pushViewController:self.MKPartyView animated:YES];
	[self.MKPartyView initWithParty:mk];
}


- (void)dealloc {
	[MKPartyView release];
    [super dealloc];
}


@end

