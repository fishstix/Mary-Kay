    //
//  MKPartyGuestView.m
//  MaryKay
//
//  Created by Charles Fisher on 5/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MKPartyGuestViewController.h"
#import "Mary_KayAppDelegate.h"
#import "MKAddEditPartyViewController.h"

@implementation MKPartyGuestViewController
@synthesize mkguest, mkparty;
@synthesize firstName, lastName, phone, bookParty;
@synthesize MKProfileView;
@synthesize MKReceiptView;


- (void) viewDidLoad {
	//UIBarButtonItem *editButton = [[UIBarButtonItem alloc] 
	//							   initWithBarButtonSystemItem:UIBarButtonSystemItemEdit 
	//							   target:self 
	//							   action:@selector(editMKClient)];
	//self.navigationItem.rightBarButtonItem = editButton;
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mkPartyGuestUpdated) name:MKClientUpdate object:nil];
}

- (void) mkPartyGuestUpdated {
	[self update:mkguest party:mkparty];
}

- (void) update:(MKPartyGuestReceipt*)mk party:(MKParty*)party{
	self.title = [mk.mkclient firstName];
	[self.firstName setText:[mk.mkclient firstName]];
	[self.lastName setText:[mk.mkclient lastName]];
	NSString *callTitle = [mk.mkclient.phone isEqualToString:@""] ? @"No Phone Number" : [NSString stringWithFormat:@"Call: %@", [mk.mkclient phone]];
	[self.phone setTitle:callTitle forState:UIControlStateNormal];
	[self.phone setTitle:callTitle forState:UIControlStateHighlighted];
	
	[self setMkparty:party];
	[self setMkguest:mk];
	
	NSString *deviceType = [UIDevice currentDevice].model;
	
	phone.enabled = [deviceType isEqualToString:@"iPhone"] &&
	![mk.mkclient.phone isEqualToString:@""];
	
	NSString *bookPartyTitle = mk.bookedParty == nil ? @"Book Party" : @"Edit Party";
	[self.bookParty setTitle:bookPartyTitle forState:UIControlStateNormal];
	[self.bookParty setTitle:bookPartyTitle forState:UIControlStateHighlighted];
	self.bookParty.enabled = YES;
	receipt.enabled = YES;
	profile.enabled = YES;
}

- (IBAction) callAction {
	//finalString = [[firstString stringByReplacingOccurancesOfString:@"O" withString:@"0"] stringByReplacingOccurancesOfString:@"o" withString:@"0"];
	NSString *phone_number = [NSString stringWithFormat:@"tel://%@", [mkguest.mkclient.phone stringByReplacingOccurrencesOfString:@"-" withString:@""	]];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone_number]];
	NSLog([NSString stringWithFormat:@"Phone Call: %@", phone_number]);
}


- (IBAction) bookPartyAction {
	MKAddEditPartyViewController *editMKPartyViewController = [[MKAddEditPartyViewController alloc] initWithNibName:@"MKAddEditPartyView" bundle:nil];
	editMKPartyViewController.delegate = self;
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:editMKPartyViewController];
	navController.navigationBar.barStyle = UIBarStyleBlackOpaque;
	editMKPartyViewController.navController = navController;
	
	if (mkguest.bookedParty != nil) {
		[editMKPartyViewController update:mkguest.bookedParty];
	}
	[editMKPartyViewController updateHost:mkguest.mkclient];
	//[editMKPartyViewController setHost:mkguest.mkclient];
	[self presentModalViewController:navController animated:YES];
	
	[navController release];
	[editMKPartyViewController release];	
}

- (void) saveMKParty:(MKParty *)mk {
	Mary_KayAppDelegate *appDelegate = (Mary_KayAppDelegate *)[[UIApplication sharedApplication] delegate];
	if (mkguest.bookedParty == nil) {
		[appDelegate addMKParty:mk];
		[mkguest setBookedParty:mk];
	} else {
		[appDelegate editMKParty:mkguest.bookedParty newParty:mk];
	}
	NSString *bookPartyTitle = mkguest.bookedParty == nil ? @"Book Party" : @"Edit Party";
	[self.bookParty setTitle:bookPartyTitle forState:UIControlStateNormal];
	[self.bookParty setTitle:bookPartyTitle forState:UIControlStateHighlighted];
	[self dismissModalViewControllerAnimated:YES];
}
- (void) cancelAddEditMKParty {
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction) profileAction {
	Mary_KayAppDelegate *appDelegate = (Mary_KayAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if(self.MKProfileView == nil) {
		MKProfileViewController *viewController = [[MKProfileViewController alloc] initWithNibName:@"MKProfileView" bundle:nil];
		self.MKProfileView = viewController;
		[viewController release];
	}
	
	[appDelegate.mkPartyNavigation pushViewController:self.MKProfileView animated:YES];
	[self.MKProfileView update:self.mkguest.mkclient];
}

- (IBAction) receiptAction {
	if (self.mkguest.mkclient == self.mkparty.host) {
		// Update Discount Value
		[self calcDiscount];
		if (discount > self.mkguest.mkreceipt.discount) {
			// open a alert with an OK and cancel button
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Update Host's Discount?" 
															message:[NSString stringWithFormat:@"%@ now qualifies for a discount of $%.2f", self.mkguest.mkclient.firstName, discount] 
														   delegate:self 
												  cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
			[alert show];
			[alert release];
		}
	}
	
	Mary_KayAppDelegate *appDelegate = (Mary_KayAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if(self.MKReceiptView == nil) {
		MKReceiptViewController *viewController = [[MKReceiptViewController alloc] initWithNibName:@"MKReceiptView" bundle:nil];
		self.MKReceiptView = viewController;
		[viewController release];
	}
	
	[appDelegate.mkPartyNavigation pushViewController:self.MKReceiptView animated:YES];
	[self.MKReceiptView update:[self.mkguest getMkreceipt] mkclient:self.mkguest.mkclient];
}	 
				 
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	 // the user clicked one of the OK/Cancel buttons
	 if (buttonIndex == 1)
	 {
		 Mary_KayAppDelegate *appDelegate = (Mary_KayAppDelegate *)[[UIApplication sharedApplication] delegate];
		 [appDelegate editReceipt:self.mkguest.mkreceipt newDiscount:discount];
	 }
	 else
	 {
		 //NSLog(@"cancel");
	 }
}
		 
- (void) calcDiscount {
	int parties = 0;
	float sum = 0;
	for (int i = 0; i < self.mkparty.mkguests.count; i++) {
		MKPartyGuestReceipt *mk = [self.mkparty.mkguests objectAtIndex:i];
		// HOST?
		if (mk == self.mkguest) {
			continue;
		}
		if (mk.bookedParty != nil) {
			parties++;
		}
		sum += [mk.mkreceipt getSubTotal];
	}
	
	float percent = parties >= 2 ? .20 : parties == 1 ? .15 : .10;
	// Sum is more than 200, 300, 400, etc...?
	sum = 100 * (int)(sum / 100);
	
	discount = sum >= 200 ? sum * percent : 0;
}
		 



- (void)dealloc {
    [super dealloc];
}


@end
