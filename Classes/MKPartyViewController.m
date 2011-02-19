//
//  MKPartyViewController.m
//  Mary Kay
//
//  Created by Charles Fisher on 9/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MKPartyViewController.h"
#import "Mary_KayAppDelegate.h"
#import "MKParty.h"
#import "MKClient.h"
#import "MKPartyGuestListViewController.h"
#import "MKAddEditPartyViewController.h"

@implementation MKPartyViewController
@synthesize host,location, type;
@synthesize MKGuestListView,party;

- (void) viewDidLoad {
	UIBarButtonItem *editButton = [[UIBarButtonItem alloc] 
								   initWithBarButtonSystemItem:UIBarButtonSystemItemEdit 
								   target:self 
								   action:@selector(editMKParty)];
	self.navigationItem.rightBarButtonItem = editButton;
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mkPartyUpdated) name:MKPartyUpdate object:nil];
}

- (void) editMKParty {
	MKAddEditPartyViewController *editMKPartyViewController = [[MKAddEditPartyViewController alloc] initWithNibName:@"MKAddEditPartyView" bundle:nil];
	editMKPartyViewController.delegate = self;
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:editMKPartyViewController];
	navController.navigationBar.barStyle = UIBarStyleBlackOpaque;
	editMKPartyViewController.navController = navController;
	
	[editMKPartyViewController update:party];
	[self presentModalViewController:navController animated:YES];
	
	[navController release];
	[editMKPartyViewController release];	
}

- (void) saveMKParty:(MKParty *)mk {
	Mary_KayAppDelegate *appDelegate = (Mary_KayAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate editMKParty:self.party newParty:mk];
	[self dismissModalViewControllerAnimated:YES];
}
- (void) cancelAddEditMKParty {
	[self dismissModalViewControllerAnimated:YES];
}


- (void) mkPartyUpdated {
	[self initWithParty:self.party];
}


- (id)initWithParty: (MKParty*)mk {
	[self setParty:mk];
	
	[self.host setText:[NSString stringWithFormat:@"Host: %@", mk.host.mkclient.firstName]];
	[self.location setText:mk.location];
	[self.type setText:[mk getPartyType]];
	[date setText:[self.party getFormattedDate]];
	self.title = [NSString stringWithFormat:@"%@'s Party", mk.host.mkclient.firstName];
}

- (IBAction) guestsAction {
	Mary_KayAppDelegate *appDelegate = (Mary_KayAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	MKPartyGuestListViewController *viewController = [[MKPartyGuestListViewController alloc] 
													  initWithNibName:@"MKPartyGuestListView" bundle:nil];
	self.MKGuestListView = viewController;
	[viewController release];
	
	[appDelegate.mkPartyNavigation pushViewController:self.MKGuestListView animated:YES];
	[self.MKGuestListView update:self.party];	
}



- (void)dealloc {
	[host release];
	[location release];
	[date release];
	[guests release];
	[MKGuestListView release];
	[party release];
    [super dealloc];
}


@end
