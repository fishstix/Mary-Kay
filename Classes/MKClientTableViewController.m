//
//  MKClientTableViewController.m
//  MaryKay
//
//  Created by Charles Fisher on 4/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MKClientTableViewController.h"
#import "Mary_KayAppDelegate.h"
#import "MKClient.h"
#import "MKClientViewController.h"


@implementation MKClientTableViewController
@synthesize MKClientView;

- (void) viewDidLoad {
	// New / Deleted MKClient
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mkClientsUpdated) name:MKClientsUpdate object:nil];
	// New Name
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mkClientsUpdated) name:MKClientUpdate object:nil];
}

- (void) mkClientsUpdated {
	[self.tableView reloadData];
}


- (void) loadView {
	[super loadView];
	
	self.tableView.editing = YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	Mary_KayAppDelegate *appDelegate = (Mary_KayAppDelegate *)[[UIApplication sharedApplication] delegate];
	return appDelegate.mkclients.count;
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
		[appDelegate deleteMKClient:[appDelegate.mkclients objectAtIndex:indexPath.row]];
    }   
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"MKClientCell";
    
    cell = (MKClientCellView *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"MKClientCellView" owner:self options:nil]; 
	 }
    
    // Set up the cell...
	// Set up the cell...
	Mary_KayAppDelegate *appDelegate = (Mary_KayAppDelegate *)[[UIApplication sharedApplication] delegate];
	MKClient *mk = (MKClient *)[appDelegate.mkclients objectAtIndex:indexPath.row];
	
	[cell setText:mk.firstName];
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic
	Mary_KayAppDelegate *appDelegate = (Mary_KayAppDelegate *)[[UIApplication sharedApplication] delegate];
	MKClient *mk = (MKClient *)[appDelegate.mkclients objectAtIndex:indexPath.row];
	
	if(self.MKClientView == nil) {
		MKClientViewController *viewController = [[MKClientViewController alloc] initWithNibName:@"MKClientView" bundle:nil];
		self.MKClientView = viewController;
		[viewController release];
	}
	
	[appDelegate.mkClientNavigation pushViewController:self.MKClientView animated:YES];
	[self.MKClientView update:mk];
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [MKClientView release];
    [super dealloc];
}


@end

