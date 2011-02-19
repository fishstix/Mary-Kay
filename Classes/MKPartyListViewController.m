//
//  MKPartyListViewController.m
//  Mary Kay
//
//  Created by Charles Fisher on 9/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MKPartyListViewController.h"
#import "Mary_KayAppDelegate.h"
#import "MKAddEditPartyViewController.h"

@implementation MKPartyListViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = NSLocalizedString(@"MK Parties", @"Mary Kay Parties");
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] 
								  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
								  target:self 
								  action:@selector(addMKParty)];
	self.navigationItem.rightBarButtonItem = addButton;
}

- (void) addMKParty {	
	MKAddEditPartyViewController *addMKPartyViewController = [[MKAddEditPartyViewController alloc] initWithNibName:@"MKAddEditPartyView" bundle:nil];
	addMKPartyViewController.delegate = self;
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:addMKPartyViewController];
	navController.navigationBar.barStyle = UIBarStyleBlackOpaque;
	
	addMKPartyViewController.navController = navController;
	
	[self presentModalViewController:navController animated:YES];
	
	[navController release];
	[addMKPartyViewController release];
}

- (void) saveMKParty:(MKParty *)mk {
	Mary_KayAppDelegate *appDelegate = (Mary_KayAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate addMKParty:mk];
	[self dismissModalViewControllerAnimated:YES];
}
- (void) cancelAddEditMKParty {
	[self dismissModalViewControllerAnimated:YES];
}


- (void) viewWillAppear:(BOOL)animated {
	[partiesTableView viewWillAppear:animated];
}

- (void)dealloc {
    [super dealloc];
}


@end
