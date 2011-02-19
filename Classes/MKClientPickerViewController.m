    //
//  MKClientPickerViewController.m
//  MaryKay
//
//  Created by Charles Fisher on 5/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MKClientPickerViewController.h"
#import "Mary_KayAppDelegate.h"

@implementation MKClientPickerViewController
@synthesize delegate;
@synthesize addressTitle;

//@synthesize navControl;
//@synthesize titleItem;
@synthesize remove_List;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		NSLog(@"Init RemoveList");
		self.remove_List = [[NSMutableArray alloc] init];
	}
	return self;
}

NSString *DictionaryKey = @"MKClients";

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// Set Title
	[self setTitle:@"Select Client"];
	
	// Add search bar
	self.tableView.tableHeaderView = topView;
	
	searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	searchBar.barStyle = UIBarStyleBlackOpaque;
	
	searching = NO;
	letUserSelectRow = YES;
	
	
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] 
								  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
								  target:self 
								  action:@selector(addMKClient)];
	UIBarButtonItem *exitButton = [[UIBarButtonItem alloc] 
								  initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
								  target:self 
								  action:@selector(cancel)];
	self.navigationItem.leftBarButtonItem = exitButton;
	self.navigationItem.rightBarButtonItem = addButton;
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:MKClientsUpdate object:nil];
	
	[self reloadData];
}

- (void) reloadData {
	// Init Array
	listOfItems = [[NSMutableArray alloc] init];
	
	
	Mary_KayAppDelegate *appDelegate = (Mary_KayAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSMutableArray *mkclients = [[NSMutableArray alloc] initWithCapacity:[appDelegate.mkclients count]];
	[mkclients addObjectsFromArray:appDelegate.mkclients];
	for (int i = 0; i < [remove_List count]; i++) {
		[mkclients removeObject:[remove_List objectAtIndex:i]];
	}
	
	NSDictionary *mkClientsDict = [NSDictionary dictionaryWithObject:mkclients forKey:DictionaryKey];
	
	[listOfItems addObject:mkClientsDict];
	
	// Init copy
	copyListOfItems = [[NSMutableArray alloc] init];	
	
	[self.tableView reloadData];
}

- (void) addMKClient {
	MKAddEditClientViewController *addMKClientViewController = [[MKAddEditClientViewController alloc] initWithNibName:@"MKAddEditClientView" bundle:nil];
	addMKClientViewController.delegate = self;
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:addMKClientViewController];
	navController.navigationBar.barStyle = UIBarStyleBlackOpaque;
	
	[self presentModalViewController:navController animated:YES];
	
	[navController release];
	[addMKClientViewController release];
}

// Delegate Methods

- (void) saveMKClient:(MKClient *)mk {
	Mary_KayAppDelegate *appDelegate = (Mary_KayAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate addMKClient:mk];
	[self dismissModalViewControllerAnimated:YES];
}
- (void) cancelAddMKClient {
	[self dismissModalViewControllerAnimated:YES];
}


//- (void) setTitle:(NSString*)title {
//	[self.navControl setTitle:title];
//	[self.titleItem setTitle:NSLocalizedString(title,nil)];
	//[self.tableView.tableHeaderView setTitle:title];
//}



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
		NSArray *array = [dictionary objectForKey:DictionaryKey];
		[searchArray addObjectsFromArray:array];
	}
	
	for (MKClient *mk in searchArray)
	{
		NSRange nameResultsRange = [[mk firstName] rangeOfString:searchText options:NSCaseInsensitiveSearch];
		NSRange addressResultsRange = [[mk address] rangeOfString:searchText options:NSCaseInsensitiveSearch];
		
		//*sTemp
		//NSRange titleResultsRange = [sTemp rangeOfString:searchText options:NSCaseInsensitiveSearch];
		
		if (nameResultsRange.length > 0 ||
			addressResultsRange.length > 0)
			[copyListOfItems addObject:mk];
	}
	
	[searchArray release];
	searchArray = nil;
	
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	[self doneSearching_Clicked:nil];
}

- (void) doneSearching_Clicked:(id)sender {
	searchBar.text = @"";
	[searchBar resignFirstResponder];
	
	letUserSelectRow = YES;
	searching = NO;
	//self.navigationItem.rightBarButtonItem = nil;
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	if (searching)
		return [copyListOfItems count];
	else {
		
		//Number of rows it should expect should be based on the section
		NSDictionary *dictionary = [listOfItems objectAtIndex:section];
		NSArray *array = [dictionary objectForKey:DictionaryKey];
		return [array count];
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	if(searching)
		return @"Search Results";
	
	return @"";
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
		array = [dictionary objectForKey:DictionaryKey];
	} else {
		array = copyListOfItems;
	}
	MKClient *mk = [array objectAtIndex:indexPath.row];
	//NSString *cellValue = [local name];
	//cell.text = [local name];
	lblTemp1.text = [mk firstName];
	lblTemp2.text = [mk address];
	
    return cell;
}

//RootViewController.m
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return 60;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSArray *array;
	if(!searching) {
		NSDictionary *dictionary = [listOfItems objectAtIndex:indexPath.section];
		array = [dictionary objectForKey:DictionaryKey];
	} else {
		array = copyListOfItems;
	}
	MKClient *mk = (MKClient*)[array objectAtIndex:indexPath.row];
	
	[self.delegate selectedMKClient:mk]; 
	
	//[self dismissModalViewControllerAnimated:YES];
}

- (IBAction) cancel {
	[self.delegate canceledMKClient];
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
