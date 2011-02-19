//
//  MKPartyGuestListViewController.m
//  Mary Kay
//
//  Created by Charles Fisher on 9/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MKPartyGuestListViewController.h"
#import "Mary_KayAppDelegate.h"
#import "MKClient.h"

@implementation MKPartyGuestListViewController
@synthesize mkparty;


- (void) viewDidLoad {
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] 
								  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
								  target:self 
								  action:@selector(addMKGuest)];
	self.navigationItem.rightBarButtonItem = addButton;
}

- (void) addMKGuest {
	MKClientPickerViewController *mkClientPicker = [[MKClientPickerViewController alloc] initWithNibName:@"ClientPickView" bundle:nil];
	NSMutableArray *guests = [mkparty getGuests];
	[mkClientPicker.remove_List addObjectsFromArray:guests];
	//mkClientPicker.removeList = [mkparty getGuests];
	//[mkClientPicker setRemoveList: [mkparty getGuests]];
	mkClientPicker.delegate = self;
	
	UINavigationController *navController2 = [[UINavigationController alloc] initWithRootViewController:mkClientPicker];
	navController2.navigationBar.barStyle = UIBarStyleBlackOpaque;
	
	[self presentModalViewController:navController2 animated:YES];
	[navController2 release];
	[mkClientPicker release];
}


- (void) selectedMKClient:(MKClient *)mk {
	Mary_KayAppDelegate *appDelegate = (Mary_KayAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate addMKPartyGuest:mk party:mkparty];
	
	[self dismissModalViewControllerAnimated:YES];
}

- (void) canceledMKClient {
	[self dismissModalViewControllerAnimated:YES];
}



- (void) update:(MKParty*)mk {
	[self setTitle:[NSString stringWithFormat:@"%@'s Guests", mk.host.mkclient.firstName]];
	[self setMkparty:mk];
	[guestsTableView update:self.mkparty];
}


- (void) viewWillAppear:(BOOL)animated {
	[guestsTableView viewWillAppear:animated];
}

- (void)dealloc {
	[guestsTableView release];
	[mkparty release];
    [super dealloc];
}




@end
