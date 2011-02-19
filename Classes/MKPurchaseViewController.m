    //
//  MKPurchaseViewController.m
//  MaryKay
//
//  Created by Charles Fisher on 6/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MKPurchaseViewController.h"
#import "Mary_KayAppDelegate.h"
#import "MKProduct.h"

@implementation MKPurchaseViewController
@synthesize mkpurchase;


- (void) viewDidLoad {
	[super viewDidLoad];
	//[self setTitle:@"Receipt Price"];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mkPurchaseUpdated) name:MKPurchaseUpdate object:nil];
}

- (void) update:(MKPurchase*)mk {
	[self setMkpurchase:mk];
	[self mkPurchaseUpdated];
}

- (void) mkPurchaseUpdated {	
	[priceLabel setText:[NSString stringWithFormat:@"$%.2f",[self.mkpurchase.product price]]];
	[finalPriceLabel setText:[NSString stringWithFormat:@"$%.2f",[self.mkpurchase getPrice]]];
	[productImage setImage:self.mkpurchase.product.image];
	
	NSString *discountTitle = [NSString stringWithFormat:@"%.2f%%",self.mkpurchase.discount];
	[discountButton setTitle:discountTitle forState:UIControlStateNormal];
	[discountButton setTitle:discountTitle forState:UIControlStateHighlighted];
}

- (IBAction) chooseDiscount {
	MKTaxPickerViewController *mkTaxPicker = [[MKTaxPickerViewController alloc] initWithNibName:@"TaxPickView" bundle:nil];
	mkTaxPicker.delegate = self;
	[mkTaxPicker update:self.mkpurchase.discount limit:100];
	
	UINavigationController *navController2 = [[UINavigationController alloc] initWithRootViewController:mkTaxPicker];
	navController2.navigationBar.barStyle = UIBarStyleBlackOpaque;
	
	[self presentModalViewController:navController2 animated:YES];
	[navController2 release];
	[mkTaxPicker release];
}

- (void) updateTax:(float)new_discount {
	Mary_KayAppDelegate *appDelegate = (Mary_KayAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate editPurchase:self.mkpurchase newDiscount:new_discount];
}


- (void)dealloc {
    [super dealloc];
}


@end
