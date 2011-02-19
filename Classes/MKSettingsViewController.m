//
//  MKSettingsViewController.m
//  Mary Kay
//
//  Created by Charles Fisher on 9/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MKSettingsViewController.h"
#import "MKTaxPickerViewController.h"
#import "Mary_KayAppDelegate.h"

@implementation MKSettingsViewController
@synthesize taxButton;

- (void) viewDidLoad {
	Mary_KayAppDelegate *appDelegate = (Mary_KayAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	// TAX
	[self setTaxTitle];
}

- (void) setTaxTitle {
	Mary_KayAppDelegate *appDelegate = (Mary_KayAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSString *taxTitle = [NSString stringWithFormat:@"%.2f%%",appDelegate.default_tax];
	[self.taxButton setTitle:taxTitle forState:UIControlStateNormal];
	[self.taxButton setTitle:taxTitle forState:UIControlStateHighlighted];
}

- (IBAction) chooseDefaultTax {
	Mary_KayAppDelegate *appDelegate = (Mary_KayAppDelegate *)[[UIApplication sharedApplication] delegate];

	MKTaxPickerViewController *mkTaxPicker = [[MKTaxPickerViewController alloc] initWithNibName:@"TaxPickView" bundle:nil];
	mkTaxPicker.delegate = self;
	[mkTaxPicker update:appDelegate.default_tax limit:10];
	
	UINavigationController *navController2 = [[UINavigationController alloc] initWithRootViewController:mkTaxPicker];
	navController2.navigationBar.barStyle = UIBarStyleBlackOpaque;
	
	[self presentModalViewController:navController2 animated:YES];
	[navController2 release];
	[mkTaxPicker release];
}

- (void) updateTax:(float)tax {
	Mary_KayAppDelegate *appDelegate = (Mary_KayAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate updateTax:tax];
	//[appDelegate setDefault_tax:tax];
	[self setTaxTitle];
}


- (IBAction) emailSupportAction {
	
	MFMailComposeViewController *emailViewController = [[MFMailComposeViewController alloc] init];
	
	emailViewController.mailComposeDelegate = self;
	
	[emailViewController setSubject:@"Mary Kay App Support - iPhone"];
	[emailViewController setToRecipients:[NSArray arrayWithObject:@"marykayapp.support@gmail.com"]];
	[emailViewController setMessageBody:@"" isHTML:NO];
	[self presentModalViewController:emailViewController animated:YES];
	[emailViewController release];
	
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[self becomeFirstResponder];
	[self dismissModalViewControllerAnimated:YES];
}

- (void)dealloc {
	[taxButton release];
    [super dealloc];
}


@end
