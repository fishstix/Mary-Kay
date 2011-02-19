//
//  MKPartyGuestTableVIewController.m
//  MaryKay
//
//  Created by Charles Fisher on 5/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MKPartyGuestTableViewController.h"
#import "Mary_KayAppDelegate.h"
#import "MKPartyGuestReceipt.h"
#import "MKPartyGuestViewController.h"

@implementation MKPartyGuestTableViewController
@synthesize mkparty;
@synthesize guests;
@synthesize MKPartyGuestView;

- (void) update:(MKParty *)mk {
	[self setMkparty:mk];
	[self setGuests:[mk getMKGuests]];
	[self.tableView reloadData];
}


- (void) viewDidLoad {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mkPartyUpdated) name:MKPartyUpdate object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mkPartyUpdated) name:MKClientUpdate object:nil];
}

- (void) mkPartyUpdated {
	[self setGuests:[self.mkparty getMKGuests]];
	[self.tableView reloadData];
}



- (void) loadView {
	[super loadView];
	
	self.tableView.editing = YES;
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
		[appDelegate deleteMKPartyGuest:[self.guests objectAtIndex:indexPath.row] mkparty:mkparty];
    }   
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.guests.count;
	//return self.mkparty.mkguests.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *CellIdentifier = @"MKPartyGuestCell";
    
    cell = (MKPartyGuestCellView *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"MKPartyGuestCellView" owner:self options:nil]; 
	}
    
    // Set up the cell...
	// Set up the cell...
	//Mary_KayAppDelegate *appDelegate = (Mary_KayAppDelegate *)[[UIApplication sharedApplication] delegate];
	MKPartyGuestReceipt *mk = (MKPartyGuestReceipt*)[self.guests objectAtIndex:indexPath.row];
	//MKProduct *mk = (MKProduct *)[appDelegate.mkproducts objectAtIndex:indexPath.row];
	
	//[cell setText:mk.name];
	[cell update:mk];
	//[cell.label setText:mk.name];
	
    return cell;
	
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// Navigation logic
	Mary_KayAppDelegate *appDelegate = (Mary_KayAppDelegate *)[[UIApplication sharedApplication] delegate];
	MKPartyGuestReceipt *mk = (MKPartyGuestReceipt *)[self.guests objectAtIndex:indexPath.row];
	
	if(self.MKPartyGuestView == nil) {
		MKPartyGuestViewController *viewController = [[MKPartyGuestViewController alloc] initWithNibName:@"MKPartyGuestView" bundle:nil];
		self.MKPartyGuestView = viewController;
		[viewController release];
	}
	
	[appDelegate.mkPartyNavigation pushViewController:self.MKPartyGuestView animated:YES];
	[self.MKPartyGuestView update:mk party:self.mkparty];
}


- (void)dealloc {
	[cell release];
	[mkparty release];
	[guests release];
	[MKPartyGuestView release];
    [super dealloc];
}



@end

