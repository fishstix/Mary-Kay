    //
//  MKDiscountPickerViewController.m
//  MaryKay
//
//  Created by Charles Fisher on 6/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MKDiscountPickerViewController.h"
#import "Mary_KayAppDelegate.h"

@implementation MKDiscountPickerViewController
@synthesize discountLabel;
@synthesize delegate;

- (void) viewDidLoad {
	
	[self setTitle:@"Discount"];
	
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
	
	[picker selectRow:(int)(initial_discount / 5) inComponent:0 animated:NO];
	
	[self updateDiscountLabel];
}

- (void) update:(float)discount {
	initial_discount = discount;
}

- (void) save {
	float new_discount = 5 * [picker selectedRowInComponent:0];
	[delegate updateDiscount:new_discount];
	[self dismissModalViewControllerAnimated:YES];
}
- (void) cancel {
	[self dismissModalViewControllerAnimated:YES];
}

- (void) updateDiscountLabel {
	[self.discountLabel setText:[NSString stringWithFormat:@"$%i.00",5 * [picker selectedRowInComponent:0]]];
}

- (NSInteger) pickerView:(UIPickerView*)thePickerView numberOfRowsInComponent:(NSInteger) component {
	return 21;
	//return (int)pow(10,component + 1);
}

- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [NSString stringWithFormat:@"$%i.00",5 * row];
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	[self updateDiscountLabel];
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (void)dealloc {
	[picker release];
    [super dealloc];
}


@end
