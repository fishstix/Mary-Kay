    //
//  MKTaxPickerViewController.m
//  MaryKay
//
//  Created by Charles Fisher on 6/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

//#import "<Math/Math.h>"
#import "MKTaxPickerViewController.h"
#import "Mary_KayAppDelegate.h"

@implementation MKTaxPickerViewController
@synthesize taxLabel;
@synthesize delegate;

- (void) viewDidLoad {
	
	[self setTitle:@"Sales Tax"];
	
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] 
								  initWithBarButtonSystemItem:UIBarButtonSystemItemSave 
								  target:self 
								  action:@selector(save)];
	UIBarButtonItem *exitButton = [[UIBarButtonItem alloc] 
								   initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
								   target:self 
								   action:@selector(cancel)];
	self.navigationItem.leftBarButtonItem = exitButton;
	self.navigationItem.rightBarButtonItem = saveButton;
	
	int tax_integer = (int)initial_tax;
	int tax_decimal = (int)((initial_tax - tax_integer) * 100);
	[picker selectRow:tax_integer inComponent:0 animated:NO];
	[picker selectRow:tax_decimal inComponent:1 animated:NO];
	
	[self updateTaxLabel];
}

- (void) update:(float)tax limit:(int)limit_{
	initial_tax = tax;
	limit = limit_;
}

- (void) save {
	float new_tax = [picker selectedRowInComponent:0] + ((float)[picker selectedRowInComponent:1] / 100);
	[delegate updateTax:new_tax];
	[self dismissModalViewControllerAnimated:YES];
}
- (void) cancel {
	[self dismissModalViewControllerAnimated:YES];
}

- (void) updateTaxLabel {
	[self.taxLabel setText:[NSString stringWithFormat:@"%i.%.2i%%",[picker selectedRowInComponent:0],[picker selectedRowInComponent:1]]];
}

- (NSInteger) pickerView:(UIPickerView*)thePickerView numberOfRowsInComponent:(NSInteger) component {
	return component == 0 ? limit : 100;
	//return (int)pow(10,component + 1);
}

- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [NSString stringWithFormat:@"%i",row];
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	[self updateTaxLabel];
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 2;
}

- (void)dealloc {
	[picker release];
    [super dealloc];
}


@end
