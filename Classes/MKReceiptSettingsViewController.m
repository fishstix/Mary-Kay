    //
//  MKReceiptSettingsViewController.m
//  MaryKay
//
//  Created by Charles Fisher on 6/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MKReceiptSettingsViewController.h"
#import "Mary_KayAppDelegate.h"

@implementation MKReceiptSettingsViewController
@synthesize mkreceipt;

- (void) viewDidLoad {
	[super viewDidLoad];
	[self setTitle:@"Receipt Price"];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mkReceiptUpdated) name:MKReceiptUpdate object:nil];
}

- (void) update:(MKReceipt*)mk {
	[self setMkreceipt:mk];
	[self mkReceiptUpdated];
}

- (void) mkReceiptUpdated {
	[self updateSubTotal];
	[self updateDiscount];
	[self updateTaxTitle];
	[self updateTotal];
}

- (void) updateSubTotal {
	[subTotal setText:[NSString stringWithFormat:@"$%.2f", [self.mkreceipt getSubTotal]]];
}

- (void) updateDiscount {
	NSString *discountTitle = [NSString stringWithFormat:@"$%.2f", self.mkreceipt.discount];
	[discount setTitle:discountTitle forState:UIControlStateNormal];
	[discount setTitle:discountTitle forState:UIControlStateHighlighted];
}

- (void) updateTaxTitle {
	NSString *taxTitle = [NSString stringWithFormat:@"%.2f%%",self.mkreceipt.tax];
	[tax setTitle:taxTitle forState:UIControlStateNormal];
	[tax setTitle:taxTitle forState:UIControlStateHighlighted];
}

- (void) updateTotal {
	[total setText:[NSString stringWithFormat:@"$%.2f", [self.mkreceipt getTotalPrice]]];
}

- (IBAction) chooseTax {
	MKTaxPickerViewController *mkTaxPicker = [[MKTaxPickerViewController alloc] initWithNibName:@"TaxPickView" bundle:nil];
	mkTaxPicker.delegate = self;
	[mkTaxPicker update:self.mkreceipt.tax limit:10];
	
	UINavigationController *navController2 = [[UINavigationController alloc] initWithRootViewController:mkTaxPicker];
	navController2.navigationBar.barStyle = UIBarStyleBlackOpaque;
	
	[self presentModalViewController:navController2 animated:YES];
	[navController2 release];
	[mkTaxPicker release];
}

- (void) updateTax:(float)new_tax {
	Mary_KayAppDelegate *appDelegate = (Mary_KayAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate editReceipt:self.mkreceipt newTax:new_tax];
}

- (IBAction) chooseDiscount {
	MKDiscountPickerViewController *mkDiscountPicker = [[MKDiscountPickerViewController alloc] initWithNibName:@"DiscountPickView" bundle:nil];
	mkDiscountPicker.delegate = self;
	[mkDiscountPicker update:self.mkreceipt.discount];
	
	UINavigationController *navController3 = [[UINavigationController alloc] initWithRootViewController:mkDiscountPicker];
	navController3.navigationBar.barStyle = UIBarStyleBlackOpaque;
	
	[self presentModalViewController:navController3 animated:YES];
	[navController3 release];
	[mkDiscountPicker release];
}

- (void) updateDiscount:(float)new_discount {
	Mary_KayAppDelegate *appDelegate = (Mary_KayAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate editReceipt:self.mkreceipt newDiscount:new_discount];
}



- (void)dealloc {
	[subTotal release];
	[tax release];
	[total release];
	[super dealloc];
}


@end
