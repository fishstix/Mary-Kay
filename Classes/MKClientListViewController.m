//
//  MKClientListViewController.m
//  Mary Kay
//
//  Created by Charles Fisher on 9/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MKClientListViewController.h"
#import "Mary_KayAppDelegate.h"
#import "MKAddEditClientViewController.h"

@implementation MKClientListViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = NSLocalizedString(@"MK Clients", @"Mary Kay Clients");
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] 
								 initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
								 target:self 
								 action:@selector(addMKClient)];
	self.navigationItem.rightBarButtonItem = addButton;
}

- (void) addMKClient {
	MKAddEditClientViewController *addMKClientViewController = [[MKAddEditClientViewController alloc] initWithNibName:@"MKAddEditClientView" bundle:nil];
	addMKClientViewController.delegate = self;
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:addMKClientViewController];
	navController.navigationBar.barStyle = UIBarStyleBlackOpaque;
	
	[self presentModalViewController:navController animated:YES];
	
	[navController release];
	[addMKClientViewController release];
	
	
	//Mary_KayAppDelegate *appDelegate = (Mary_KayAppDelegate *)[[UIApplication sharedApplication] delegate];
	//[appDelegate addMKClient];
}

- (void) saveMKClient:(MKClient *)mk {
	Mary_KayAppDelegate *appDelegate = (Mary_KayAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate addMKClient:mk];
	[self dismissModalViewControllerAnimated:YES];
}
- (void) cancelAddMKClient {
	[self dismissModalViewControllerAnimated:YES];
}

- (void) viewWillAppear:(BOOL)animated {
	[clientsTableView viewWillAppear:animated];
}

- (void)dealloc {
	[super dealloc];
}


@end
