    //
//  MKPurchasePickerViewController.m
//  MaryKay
//
//  Created by Charles Fisher on 5/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import "MKPurchasePickerViewController.h"
#import "Mary_KayAppDelegate.h"
#import "MKProd.h";
#import "MKProductGroup.h"

@implementation MKPurchasePickerViewController
//@synthesize mkproducts;
@synthesize pickerViewController;
@synthesize navigationController;
@synthesize delegate;
@synthesize addressTitle;

NSString *PurchasesDictionaryKey = @"MKPurchases";

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) includeCancelButton {
	UIBarButtonItem *exitButton = [[UIBarButtonItem alloc] 
								   initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
								   target:self 
								   action:@selector(cancel)];
	self.navigationItem.leftBarButtonItem = exitButton;
}

- (void) loadProducts:(NSMutableArray*)products {
	
	// Init Array
	listOfItems = [[NSMutableArray alloc] init];	
	
	Mary_KayAppDelegate *appDelegate = (Mary_KayAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	//NSMutableArray *mkproducts = [[NSMutableArray alloc] initWithCapacity:[appDelegate.mkproducts count]];
	//[mkproducts addObjectsFromArray:appDelegate.mkproducts];
	mkproducts = products;
	
	NSDictionary *mkProductsDict = [NSDictionary dictionaryWithObject:mkproducts forKey:PurchasesDictionaryKey];
	
	[listOfItems addObject:mkProductsDict];
	
	// Init copy
	copyListOfItems = [[NSMutableArray alloc] init];
	
	// Set Title
	// Set elsewhere?
	
	// Add search bar
	self.tableView.tableHeaderView = topView;
	searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	searchBar.barStyle = UIBarStyleBlackOpaque;
	
	searching = NO;
	letUserSelectRow = YES;
	
	[self.tableView reloadData];
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *) theSearchBar {
	searching = YES;
	letUserSelectRow = NO;
	self.tableView.scrollEnabled = NO;
	
	// Add done button
	//self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
	//										   initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
	//										   target:self 
	//										   action:@selector(doneSearching_Clicked:)] autorelease];
}

- (NSIndexPath *) tableView : (UITableView *) theTableView willSelectRowAtIndexPath:(NSIndexPath *) indexPath {
	
	if(letUserSelectRow)
		return indexPath;
	else
		return nil;
}

-(void) searchBar:(UISearchBar *) theSearchBar textDidChange:(NSString *) searchText {
	
	// Remove objects
	[copyListOfItems removeAllObjects];
	
	if([searchText length] > 0) {
		
		searching = YES;
		letUserSelectRow = YES;
		self.tableView.scrollEnabled = YES;
		[self searchTableView];
	}
	else {
		searching = NO;
		letUserSelectRow = NO;
		self.tableView.scrollEnabled = NO;
	}
	
	[self.tableView reloadData];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *) theSearchBar {
	[self searchTableView];
}

- (void) searchTableView {
	
	NSString *searchText = searchBar.text;
	NSMutableArray *searchArray = [[NSMutableArray alloc] init];
	
	for (NSDictionary *dictionary in listOfItems) {
		NSArray *array = [dictionary objectForKey:PurchasesDictionaryKey];
		[searchArray addObjectsFromArray:array];
	}
	
	for (MKProduct *mk in searchArray)
	{
		NSRange nameResultsRange = [[mk name] rangeOfString:searchText options:NSCaseInsensitiveSearch];
		
		//*sTemp
		//NSRange titleResultsRange = [sTemp rangeOfString:searchText options:NSCaseInsensitiveSearch];
		
		if (nameResultsRange.length > 0)
			[copyListOfItems addObject:mk];
	}
	
	[searchArray release];
	searchArray = nil;
	
	mkproducts = copyListOfItems;
	
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	[self doneSearching_Clicked:nil];
}

- (void) doneSearching_Clicked:(id)sender {
	searchBar.text = @"";
	[searchBar resignFirstResponder];
	
	letUserSelectRow = YES;
	searching = NO;
	self.navigationItem.rightBarButtonItem = nil;
	self.tableView.scrollEnabled = YES;
	
	[self.tableView reloadData];
}


#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
	if (searching)
		return 1;
	else
		return [listOfItems count];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSectionBlah:(NSInteger)section {
	
	if (searching)
		return [copyListOfItems count];
	else {
		
		//Number of rows it should expect should be based on the section
		NSDictionary *dictionary = [listOfItems objectAtIndex:section];
		NSArray *array = [dictionary objectForKey:PurchasesDictionaryKey];
		return [array count];
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	if(searching)
		return @"Search Results";
	
	return @"";
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPathBlah:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		CGRect CellFrame = CGRectMake(0, 0, 300, 60);
		
        cell = [[[UITableViewCell alloc] initWithFrame:CellFrame reuseIdentifier:CellIdentifier] autorelease];
		
		CGRect Label1Frame = CGRectMake(10, 10, 290, 25);
		CGRect Label2Frame = CGRectMake(10, 33, 290, 25);
		
		UILabel *lblTemp;
		
		//Initialize Label with tag 1.
		lblTemp = [[UILabel alloc] initWithFrame:Label1Frame];
		lblTemp.tag = 1;
		[cell.contentView addSubview:lblTemp];
		[lblTemp release];
		
		//Initialize Label with tag 2.
		lblTemp = [[UILabel alloc] initWithFrame:Label2Frame];
		lblTemp.tag = 2;
		lblTemp.font = [UIFont boldSystemFontOfSize:12];
		lblTemp.textColor = [UIColor darkGrayColor];
		[cell.contentView addSubview:lblTemp];
		[lblTemp release];
    }
    
    // Set up the cell...
	UILabel *lblTemp1 = (UILabel *)[cell viewWithTag:1];
	UILabel *lblTemp2 = (UILabel *)[cell viewWithTag:2];
	
	//First get the dictionary object
	NSArray *array;
	if(!searching) {
		NSDictionary *dictionary = [listOfItems objectAtIndex:indexPath.section];
		array = [dictionary objectForKey:PurchasesDictionaryKey];
	} else {
		array = copyListOfItems;
	}
	MKProduct *mk = [array objectAtIndex:indexPath.row];
	//NSString *cellValue = [local name];
	//cell.text = [local name];
	lblTemp1.text = [mk name];
	//lblTemp2.text = [mk ];
	
    return cell;
}

//RootViewController.m
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {	
	return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
	if (cell == cellProduct) {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	MKProd *mk = (MKProd*) [mkproducts objectAtIndex:indexPath.row];
	if ([[mk getType] isEqualToString:@"Group"]) {
		if(self.pickerViewController == nil) {
			MKPurchasePickerViewController *mkPurchasePicker = [[MKPurchasePickerViewController alloc] initWithNibName:@"PurchasePickView" bundle:nil];
			mkPurchasePicker.delegate = self.delegate;
			mkPurchasePicker.navigationController = self.navigationController;
			self.pickerViewController = mkPurchasePicker;
			[mkPurchasePicker release];
		}
		MKProductGroup* mkgroup = (MKProductGroup*)mk;
		self.pickerViewController.title = [NSString stringWithFormat:@"Select %@ Product",[mkgroup name]];
		[navigationController pushViewController:self.pickerViewController animated:YES];
		//[appDelegate.mkProductNavigation pushViewController:self.MKProductListView animated:YES];
		[self.pickerViewController loadProducts: mkgroup.MKProducts];
		return;
	}
	
	NSArray *array;
	if(!searching) {
		NSDictionary *dictionary = [listOfItems objectAtIndex:indexPath.section];
		array = [dictionary objectForKey:PurchasesDictionaryKey];
	} else {
		array = copyListOfItems;
	}
	MKProduct *mkproduct = (MKProduct*)mk;//[array objectAtIndex:indexPath.row];
	MKPurchase *mkpurchase = [[MKPurchase alloc] init:mkproduct discount:0];
	
	[self.delegate selectedMKPurchase:mkpurchase]; 
	
	//[self dismissModalViewControllerAnimated:YES];
}

- (IBAction) cancel {
	[self.delegate canceledMKPurchase];
	//[self dismissModalViewControllerAnimated:YES];
}


- (void)dealloc {
	
	//[ovController release];
	[copyListOfItems release];
	[searchBar release];
	[listOfItems release];
    [super dealloc];
}


@end
