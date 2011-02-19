//
//  MKPartyGuestCellView.m
//  MaryKay
//
//  Created by Charles Fisher on 5/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MKPartyGuestCellView.h"
#import "Mary_KayAppDelegate.h"

@implementation MKPartyGuestCellView
@synthesize mkguestreceipt;
@synthesize MKProfileView;
@synthesize MKReceiptView;

- (void) update:(MKPartyGuestReceipt*)mk {
	[self setMkguestreceipt:mk];
	[nameLabel setText:[mk.mkclient firstName]];
	[profileLabel setText:[NSString stringWithFormat:@"%@ / %@ / %@",
						   [mk.mkclient.profile getSkinType],
						   [mk.mkclient.profile getSkinTone], 
						   [mk.mkclient.profile getFoundationCoverage]]];
}

- (IBAction) profileAction {
	Mary_KayAppDelegate *appDelegate = (Mary_KayAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if(self.MKProfileView == nil) {
		MKProfileViewController *viewController = [[MKProfileViewController alloc] initWithNibName:@"MKProfileView" bundle:nil];
		self.MKProfileView = viewController;
		[viewController release];
	}
	
	[appDelegate.mkPartyNavigation pushViewController:self.MKProfileView animated:YES];
	[self.MKProfileView update:self.mkguestreceipt.mkclient];
}

- (IBAction) receiptAction {
	Mary_KayAppDelegate *appDelegate = (Mary_KayAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if(self.MKReceiptView == nil) {
		MKReceiptViewController *viewController = [[MKReceiptViewController alloc] initWithNibName:@"MKReceiptView" bundle:nil];
		self.MKReceiptView = viewController;
		[viewController release];
	}
	//MKReceiptViewController *viewController = [[MKReceiptViewController alloc] initWithNibName:@"MKReceiptView" bundle:nil];
	//self.MKReceiptView = viewController;
	//[viewController release];
	
	[appDelegate.mkPartyNavigation pushViewController:self.MKReceiptView animated:YES];
	[self.MKReceiptView update:[self.mkguestreceipt getMkreceipt] mkclient:self.mkguestreceipt.mkclient];
}

- (void)dealloc {
	[nameLabel release];
	[profileLabel release];
	[profileButton release];
	[receiptButton release];
	[mkguestreceipt release];
	[MKProfileView release];
	[MKReceiptView release];
    [super dealloc];
}


@end
