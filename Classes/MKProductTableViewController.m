//
//  MKProductTableViewController.m
//  MaryKay
//
//  Created by Charles Fisher on 4/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MKProductTableViewController.h"
#import "MKProductListViewController.h"
#import "MKProductViewController.h"
#import "MKProductNavigation.h"
#import "Mary_KayAppDelegate.h"
#import "MKProd.h"
#import "MKProduct.h"
#import "MKProductGroup.h"

#import "MKProductCellView.h"
#import "MKProductGroupCellView.h"

@implementation MKProductTableViewController
@synthesize MKProductView, MKProductListView, mkproducts;

- (void) viewDidLoad {
	arrayOfCharacters = [[NSMutableArray alloc] init];
	objectsForCharacters = [[NSMutableDictionary alloc] init];
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //Mary_KayAppDelegate *appDelegate = (Mary_KayAppDelegate *)[[UIApplication sharedApplication] delegate];
	//return appDelegate.mkproducts.count;
	return mkproducts.count;
}

//- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//	return 60;
//}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	// Set up the cell...
	//Mary_KayAppDelegate *appDelegate = (Mary_KayAppDelegate *)[[UIApplication sharedApplication] delegate];
	//MKProd *mk = (MKProd *)[appDelegate.mkproducts objectAtIndex:indexPath.row];
	MKProd *mk = (MKProd *)[mkproducts objectAtIndex:indexPath.row];
	
	if ([[mk getType] isEqualToString:@"Group"]) {
		cellGroup = (MKProductGroupCellView *) [tableView dequeueReusableCellWithIdentifier:[mk getCellIdentifier]];
		
		if (cellGroup == nil) {
			[[NSBundle mainBundle] loadNibNamed:[mk getTableCellViewName] owner:self options:nil];
		}
		MKProductGroup *mkgroup = (MKProductGroup*)mk;
		[cellGroup setText:mkgroup.name];
		cellGroup.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		return cellGroup;
	} else {
		cellProduct = (MKProductCellView *) [tableView dequeueReusableCellWithIdentifier:[mk getCellIdentifier]];
		if (cellProduct == nil) {
			[[NSBundle mainBundle] loadNibNamed:@"MKProductCellView" owner:self options:nil]; 
		}
    
   
		//[cell setText:mk.name];
		[cellProduct setProductCellDetails:(MKProduct*)mk];
		cellProduct.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		//[cell.label setText:mk.name];
	
		return cellProduct;
	}
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic
	Mary_KayAppDelegate *appDelegate = (Mary_KayAppDelegate *)[[UIApplication sharedApplication] delegate];
	//MKProduct *mk = (MKProduct *)[appDelegate.mkproducts objectAtIndex:indexPath.row];
	MKProd *mk = (MKProd*)[mkproducts objectAtIndex:indexPath.row];
	
	if ([[mk getType] isEqualToString:@"Group"]) {
		if(self.MKProductListView == nil) {
			MKProductListViewController *viewController = [[MKProductListViewController alloc] initWithNibName:@"MKProductListView" bundle:nil];
			self.MKProductListView = viewController;
			[viewController release];
		}
		MKProductGroup* mkgroup = (MKProductGroup*)mk;
		self.MKProductListView.title = [mkgroup name];
		[appDelegate.mkProductNavigation pushViewController:self.MKProductListView animated:YES];
		self.MKProductListView.productsTableView.mkproducts = mkgroup.MKProducts;
		[self.MKProductListView.productsTableView.tableView reloadData];
	} else {
		if(self.MKProductView == nil) {
			MKProductViewController *viewController = [[MKProductViewController alloc] initWithNibName:@"MKProductView" bundle:nil];
			self.MKProductView = viewController;
			[viewController release];
		}
		MKProduct* mkproduct = (MKProduct*)mk;
		//[self.navigationController pushViewController:self.MKProductView animated:YES];
		
		[appDelegate.mkProductNavigation pushViewController:self.MKProductView animated:YES];
		[self.MKProductView update:mkproduct];
	}
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
	[MKProductView release];
    [super dealloc];
}


@end

