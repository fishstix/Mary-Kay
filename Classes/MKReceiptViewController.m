    //
//  MKReceiptViewController.m
//  MaryKay
//
//  Created by Charles Fisher on 4/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MKReceiptViewController.h"
#import "Mary_KayAppDelegate.h"

@implementation MKReceiptViewController
@synthesize receipt, mkclient;
@synthesize MKReceiptProductTable;
@synthesize MKReceiptSettingsView;


- (void) viewDidLoad {
	[super viewDidLoad];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mkReceiptUpdated) name:MKReceiptUpdate object:nil];
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] 
								  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
								  target:self 
								  action:@selector(addMKPurchase)];
	self.navigationItem.rightBarButtonItem = addButton;
	
	self.MKReceiptProductTable.navController = self.navigationController;
}


- (void) viewWillAppear:(BOOL)animated {
	[self.MKReceiptProductTable viewWillAppear:animated];
}

- (void) addMKPurchase {
	MKPurchasePickerViewController *mkPurchasePicker = [[MKPurchasePickerViewController alloc] initWithNibName:@"PurchasePickView" bundle:nil];
	mkPurchasePicker.delegate = self;
	
	UINavigationController *navController2 = [[UINavigationController alloc] initWithRootViewController:mkPurchasePicker];
	//mkPurchasePicker.navigationController = navController2;
	[mkPurchasePicker setNavigationController:navController2];
	navController2.navigationBar.barStyle = UIBarStyleBlackOpaque;
	
	[self presentModalViewController:navController2 animated:YES];
	Mary_KayAppDelegate *appDelegate = (Mary_KayAppDelegate *)[[UIApplication sharedApplication] delegate];
	[mkPurchasePicker loadProducts:appDelegate.mkproducts];
	[mkPurchasePicker includeCancelButton];
	[mkPurchasePicker setTitle:@"Select Product"];
	[navController2 release];
	[mkPurchasePicker release];
}

- (void) selectedMKPurchase:(MKPurchase *)mk {
	Mary_KayAppDelegate *appDelegate = (Mary_KayAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate addMKPurchase:mk receipt:self.receipt];
	[self dismissModalViewControllerAnimated:YES];
}
- (void) canceledMKPurchase {
	[self dismissModalViewControllerAnimated:YES];
}

- (void) mkReceiptUpdated {
	[self update:self.receipt mkclient:self.mkclient];
}

- (void) update:(MKReceipt*)r mkclient:(MKClient*)mk{
	[self setTitle:[NSString stringWithFormat:@"%@'s Receipt", mk.firstName]];
	
	[self setMkclient:mk];
	[self setReceipt:r];

	NSString *totalTitle = [NSString stringWithFormat:@"$%.2f",[receipt getTotalPrice]];
	[total setTitle:totalTitle forState:UIControlStateNormal];
	[total setTitle:totalTitle forState:UIControlStateHighlighted];
	//[totalCost setText:[NSString stringWithFormat:@"Total Price: $%.2f", [receipt getTotalPrice]]];
	[dateLabel setText:[receipt getFormattedDate]];
	[self.MKReceiptProductTable update:receipt];
}

- (IBAction) receiptSettings {
	//Mary_KayAppDelegate *appDelegate = (Mary_KayAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if(self.MKReceiptSettingsView == nil) {
		MKReceiptSettingsViewController *viewController = [[MKReceiptSettingsViewController alloc] initWithNibName:@"MKReceiptSettingsView" bundle:nil];
		self.MKReceiptSettingsView = viewController;
		[viewController release];
	}
	
	[self.navigationController pushViewController:self.MKReceiptSettingsView animated:YES];
	//[appDelegate.mkClientNavigation pushViewController:self.MKReceiptSettingsView animated:YES];
	[self.MKReceiptSettingsView update:self.receipt];
	
}


- (void)dealloc {
	[receipt release];
	[totalCost release];
    [super dealloc];
}


@end
