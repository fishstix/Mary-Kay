    //
//  MKAddClientViewController.m
//  MaryKay
//
//  Created by Charles Fisher on 5/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MKAddEditClientViewController.h"


@implementation MKAddEditClientViewController
@synthesize firstName, lastName, address, phone, email;
@synthesize mkclient;
@synthesize delegate;

- (void) viewDidLoad {
	[self setTitle:@"Add MK Client"];
	
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
																				  target:self action:@selector(cancelMKClient)];
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave 
																				target:self action:@selector(saveMKClient)];
	self.navigationItem.leftBarButtonItem = saveButton;
	self.navigationItem.rightBarButtonItem = cancelButton;

	if (mkclient != nil) {
		[self edit];
	}
}

- (void) edit {
	[self setTitle:[NSString stringWithFormat:@"Edit %@",mkclient.firstName]];
	[self.firstName setText:mkclient.firstName];
	[self.lastName setText:mkclient.lastName];
	[self.address setText:mkclient.address];
	[self.phone setText:mkclient.phone];
	[self.email setText:mkclient.email];
}

- (void) update:(MKClient *)mk {
	[self setMkclient:mk];
}

- (void) saveMKClient {
	[self resignKeyBoard];
	
	if ([firstName.text isEqualToString:@""] ||
		 [lastName.text isEqualToString:@""]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to Save" message:@"Please include a full first and last name" delegate:self 
											  cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	} else {
		MKClient *newMK = [[MKClient alloc] initWithName:firstName.text last:lastName.text 
												 address:address.text
												   email:email.text
												   phone:phone.text];
		[delegate saveMKClient:newMK];
	}
}

- (void) cancelMKClient {
	[self resignKeyBoard];
	[delegate cancelAddMKClient];
}

- (void) resignKeyBoard {
	[firstName resignFirstResponder];
	[lastName resignFirstResponder];
	[address resignFirstResponder];
	[email resignFirstResponder];
	[phone resignFirstResponder];
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
	[textField resignFirstResponder];
}

-(BOOL) textFieldShouldReturn:(UITextField*) textField {
	//[self resignKeyBoard];
	[textField resignFirstResponder]; 
    return YES;
}

- (IBAction) contactsAction {
	ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
	picker.peoplePickerDelegate = self;
	
	[self presentModalViewController:picker animated:YES];
	
	[picker release];
}

- (void) peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
	[self dismissModalViewControllerAnimated:YES];
}

- (BOOL) peoplePickerNavigationController:(ABPeoplePickerNavigationController*) peoplePicker 
	   shouldContinueAfterSelectingPerson:(ABRecordRef)person {
	NSString *first = (NSString*) ABRecordCopyValue(person, kABPersonFirstNameProperty);
	NSString *last = (NSString*) ABRecordCopyValue(person, kABPersonLastNameProperty);
	//NSString *address
	//NSString *em = (NSString*) ABRecordCopyValue(person, kABPersonEmailProperty);
	ABMutableMultiValueRef multiValueEmail = ABRecordCopyValue(person, kABPersonEmailProperty);
	if (ABMultiValueGetCount(multiValueEmail) > 0) {
		NSString *em = [(NSString *)ABMultiValueCopyValueAtIndex(multiValueEmail, 0) autorelease];
		[self.email setText:em];
		[em release];
	} else {
		[self.email setText:@""];
	}
	ABMutableMultiValueRef multiValuePhone = ABRecordCopyValue(person, kABPersonPhoneProperty);
	if (ABMultiValueGetCount(multiValuePhone) > 0) {
		NSString *p = [(NSString *)ABMultiValueCopyValueAtIndex(multiValuePhone, 0) autorelease];
		[self.phone setText:p];
		[p release];
	} else {
		[self.phone setText:@""];
	}
	
	ABMutableMultiValueRef multiValueAddress = ABRecordCopyValue(person, kABPersonAddressProperty);
	if (ABMultiValueGetCount(multiValueAddress) > 0) {
		CFDictionaryRef dict = ABMultiValueCopyValueAtIndex(multiValueAddress, 0);
		CFStringRef street = CFDictionaryGetValue(dict, kABPersonAddressStreetKey);
		CFStringRef city = CFDictionaryGetValue(dict, kABPersonAddressCityKey);
		CFStringRef state = CFDictionaryGetValue(dict, kABPersonAddressStateKey);
		CFStringRef zip = CFDictionaryGetValue(dict, kABPersonAddressZIPKey);
		
		CFRelease(dict);
		NSString *addy = [NSString stringWithFormat:@"%@ %@, %@ %@", street, city, state, zip];
		
		[self.address setText:addy];
		NSLog(addy);
		//[addy release];
	} else {
		[self.address setText:@""];
	}
	
	[self.firstName setText:first == nil ? @"" : first];
	[self.lastName setText:last == nil ? @"" : last];
	
	[first release];
	[last release];
	[self dismissModalViewControllerAnimated:YES];
	
	return NO;
}

- (void)dealloc {
	[firstName release];
	[lastName release];
	[address release];
	[email release];
	[phone release];
	[contactsButton release];
	[mkclient release];
	//[delegate release];
	 [super dealloc];
}


@end
