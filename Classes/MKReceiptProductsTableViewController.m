//
//  MKReceiptProductsTableViewController.m
//  MaryKay
//
//  Created by Charles Fisher on 4/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MKReceiptProductsTableViewController.h"
#import "Mary_KayAppDelegate.h"
#import "MKPurchase.h"
#import "MKProduct.h"

@implementation MKReceiptProductsTableViewController
@synthesize MKPurchaseView;
@synthesize navController;
@synthesize receipt;

- (void) viewDidLoad {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mkReceiptUpdated) name:MKReceiptUpdate object:nil];
}

- (void) mkReceiptUpdated {
	[self.tableView reloadData];
}

- (void) update:(MKReceipt*)r {
	[self setReceipt:r];	
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
		[appDelegate deleteMKPurchase:[self.receipt.purchases objectAtIndex:indexPath.row] receipt:self.receipt];
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
    return [self.receipt.purchases count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"MKPurchaseCell";
    
    cell = (MKPurchaseCellView *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"MKPurchaseCellView" owner:self options:nil]; 
	}
	
	MKPurchase *mk = [self.receipt.purchases objectAtIndex:indexPath.row];
	
    // Configure the cell...
	[cell update:mk];
	//[cell setText:[NSString stringWithFormat:@"%@ - $%.2f", mk.product.name, [mk getPrice]]];
    
    return cell;
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
	if(self.MKPurchaseView == nil) {
		MKPurchaseViewController *viewController = [[MKPurchaseViewController alloc] initWithNibName:@"MKPurchaseView" bundle:nil];
		self.MKPurchaseView = viewController;
		[viewController release];
	}
	MKPurchase *mk = [self.receipt.purchases objectAtIndex:indexPath.row];
	[self.navController pushViewController:self.MKPurchaseView animated:YES];
	[self.MKPurchaseView update:mk];
}



- (void)dealloc {
    [super dealloc];
}


@end

