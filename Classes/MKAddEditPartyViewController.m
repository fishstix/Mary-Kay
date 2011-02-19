    //
//  MKAddEditPartyViewController.m
//  MaryKay
//
//  Created by Charles Fisher on 5/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MKAddEditPartyViewController.h"
#import "MKPartyGuestReceipt.h"

@implementation MKAddEditPartyViewController
@synthesize dateLabel, timeLabel, hostLabel, address;
@synthesize date,dateDate,timeDate,host,location;
@synthesize selectPartyType;
@synthesize mkparty;
@synthesize delegate;
@synthesize navController;

- (void) viewDidLoad {
	[self setTitle:@"Add MK Party"];
	
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
																				  target:self action:@selector(cancelMKParty)];
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave 
																				target:self action:@selector(saveMKParty)];
	self.navigationItem.leftBarButtonItem = saveButton;
	self.navigationItem.rightBarButtonItem = cancelButton;
	
	//NSLog(@"Load AddEdit Party");
	if (host != nil) {
		//NSLog(@"Host is not nil");
		[self bookedHost];
	}
	if (mkparty != nil) {
		[self edit];
	}
	
}

- (void) edit {
	[self setTitle:@"Edit MK Party"];
	self.date = mkparty.date;
	//self.dateDate = self.date;
	//self.timeDate = self.date;
	[self.dateLabel setText:[self getFormattedDate]];
	[self.timeLabel setText:[self getFormattedTime]];
	self.host = mkparty.host.mkclient;
	[self.hostLabel setText:[self.host firstName]];
	self.location = mkparty.location;
	[self.address setText:self.location];
	[self.selectPartyType update:mkparty];
}


NSDateFormatter *dateFormatter;

- (NSString*) getFormattedDate {
	if (dateFormatter == nil) {
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"cccc MMMM dd, yyyy"];
	}
	
	return [dateFormatter stringFromDate:self.date];
}
NSDateFormatter *timeFormatter;

- (NSString*) getFormattedTime {
	if (timeFormatter == nil) {
		timeFormatter = [[NSDateFormatter alloc] init];
		[timeFormatter setDateFormat:@"hh:mm a"];
	}
	
	return [timeFormatter stringFromDate:self.date];
}


- (void) update:(MKParty *)mk {
	[self setMkparty:mk];
}
- (void) updateHost:(MKClient*)mk {
	//NSLog(@"Setting Host");
	[self setHost:mk];
}

- (void) bookedHost {
	NSLog(@"Setup the Booked Host");
	//self.host = mk;
	[self.hostLabel setText:[self.host firstName]];
	self.location = host.address;
	[self.address setText:host.address];
	selectHostButton.enabled = NO;
}

- (void) saveMKParty {
	[self resignKeyBoard];
	
	if (host == nil) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to Save" message:@"Please select a Client to Host this Party" delegate:self 
											  cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	} else if (date == nil) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to Save" message:@"Please select a Date" delegate:self 
											  cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	} else {
		MKParty *newMK = [[MKParty alloc] init:host location:self.address.text];
		[newMK setPartyType:[selectPartyType getPartyType]];
		[newMK setDate:self.date];
		[delegate saveMKParty:newMK];
	}
}

- (void) cancelMKParty {
	[self resignKeyBoard];
	[delegate cancelAddEditMKParty];
}

- (void) resignKeyBoard {
	[address resignFirstResponder];
}


- (IBAction) dateAction {
	DateViewController *dateViewController = [[DateViewController alloc] init];
	dateViewController.delegate = self;
	dateViewController.date = [[NSDate alloc] init];
	[self.navController pushViewController:dateViewController animated:YES];
	
	[dateViewController release];
}
- (void)takeNewDate:(NSDate *)newDate {
	self.date = newDate;
	//self.dateDate = newDate;
	[self.dateLabel setText:[self getFormattedDate]];	
	[self.timeLabel setText:[self getFormattedTime]];
}

- (IBAction) timeAction {
	TimeViewController *timeViewController = [[TimeViewController alloc] init];
	timeViewController.delegate = self;
	timeViewController.date = [[NSDate alloc] init];
	[self.navController pushViewController:timeViewController animated:YES];
	
	[timeViewController release];
}

- (void)takeNewTime:(NSDate *)newTime {
	self.timeDate = newTime;
	[self.timeLabel setText:[self getFormattedTime]];	
}



- (IBAction) hostAction {
	MKClientPickerViewController *mkClientPicker = [[MKClientPickerViewController alloc] initWithNibName:@"ClientPickView" bundle:nil];
	mkClientPicker.delegate = self;
	
	UINavigationController *navController2 = [[UINavigationController alloc] initWithRootViewController:mkClientPicker];
	navController2.navigationBar.barStyle = UIBarStyleBlackOpaque;
	
	[self presentModalViewController:navController2 animated:YES];
	[navController2 release];
	[mkClientPicker release];
}


- (void) selectedMKClient:(MKClient *)mk {
	[self setHost:mk];
	[self.hostLabel setText:mk.firstName];
	[self dismissModalViewControllerAnimated:YES];
	
	if(![self.address.text isEqualToString:mk.address]) {
		// open a alert with an OK and cancel button
		NSString *msgTitle = [NSString stringWithFormat:@"Use %@'s Address for Party?",mk.firstName];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:msgTitle message:mk.address delegate:self 
											  cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
		[alert show];
		[alert release];
	}
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	// the user clicked one of the OK/Cancel buttons
	if (buttonIndex == 1)
	{
		[self.address setText:host.address];
	}
}

- (void) canceledMKClient {
	[self dismissModalViewControllerAnimated:YES];
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
	[textField resignFirstResponder];
}

-(BOOL) textFieldShouldReturn:(UITextField*) textField {
	//[self resignKeyBoard];
	[textField resignFirstResponder]; 
    return YES;
}

- (void)dealloc {
	[dateLabel release];
	[timeLabel release];
	[hostLabel release];
	[address release];

	[selectDateButton release];
	[selectTimeButton release];
	[selectHostButton release];

	[selectPartyType release];

	[date release];
	[dateDate release];
	[timeDate release];
	[host release];
	[location release];
	[mkparty release];

	[delegate release];
	[navController release];
	
    [super dealloc];
}


@end
