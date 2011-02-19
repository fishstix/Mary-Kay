//
//  MKReceiptTableViewController.m
//  MaryKay
//
//  Created by Charles Fisher on 4/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MKReceiptTableViewController.h"
#import "MKReceipt.h"
#import "MKReceiptViewController.h"
#import "Mary_KayAppDelegate.h"

@implementation MKReceiptTableViewController
@synthesize mkclient;
@synthesize MKReceiptView;

- (void) update:(MKClient *)mk {
	[self setMkclient:mk];
	[self.tableView reloadData];
}



- (void) viewDidLoad {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mkReceiptsUpdated) name:MKReceiptUpdate object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mkReceiptsUpdated) name:MKReceiptsUpdate object:nil];
}

- (void) mkReceiptsUpdated {
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
		[appDelegate deleteMKReceipt:[mkclient.receipts objectAtIndex:indexPath.row] mkclient:mkclient];
		//[appDelegate deleteMKParty:[appDelegate.mkparties objectAtIndex:indexPath.row]];
    }   
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [mkclient.receipts count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"MKReceiptCell";
    
    cell = (MKReceiptCellView *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"MKReceiptCellView" owner:self options:nil]; 
	}
	
	MKReceipt *mkreceipt = (MKReceipt*)[mkclient.receipts objectAtIndex:indexPath.row];
	
    // Configure the cell...
	[cell update:mkreceipt];
	
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic
	MKReceipt *mkreceipt = (MKReceipt*)[mkclient.receipts objectAtIndex:indexPath.row];
	
	if(self.MKReceiptView == nil) {
		MKReceiptViewController *viewController = [[MKReceiptViewController alloc] initWithNibName:@"MKReceiptView" bundle:nil];
		self.MKReceiptView = viewController;
		[viewController release];
	}
	
	Mary_KayAppDelegate *appDelegate = (Mary_KayAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate.mkClientNavigation pushViewController:self.MKReceiptView animated:YES];
	[self.MKReceiptView update:mkreceipt mkclient:mkclient];
	
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

