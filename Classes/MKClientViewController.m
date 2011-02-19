//
//  MKClientViewController.m
//  Mary Kay
//
//  Created by Charles Fisher on 9/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MKClientViewController.h"
#import "Mary_KayAppDelegate.h"
#import "MKAddEditClientViewController.h"

@implementation MKClientViewController
@synthesize firstName,lastName,creditCard,address,directions,email,phone;
@synthesize mkclient;

@synthesize MKProfileView;
@synthesize MKReceiptsView;

- (void) viewDidLoad {
	UIBarButtonItem *editButton = [[UIBarButtonItem alloc] 
								  initWithBarButtonSystemItem:UIBarButtonSystemItemEdit 
								  target:self 
								  action:@selector(editMKClient)];
	self.navigationItem.rightBarButtonItem = editButton;
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mkClientUpdated) name:MKClientUpdate object:nil];
}

- (void) mkClientUpdated {
	[self update:mkclient];
}

- (void) editMKClient {
	MKAddEditClientViewController *editMKClientViewController = [[MKAddEditClientViewController alloc] initWithNibName:@"MKAddEditClientView" bundle:nil];
	editMKClientViewController.delegate = self;
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:editMKClientViewController];
	navController.navigationBar.barStyle = UIBarStyleBlackOpaque;
	
	[self presentModalViewController:navController animated:YES];
	[editMKClientViewController update:mkclient];
	
	[navController release];
	[editMKClientViewController release];
		
}
	
- (void) saveMKClient:(MKClient *)mk {
	Mary_KayAppDelegate *appDelegate = (Mary_KayAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate editMKClient:mkclient newClient:mk];
	[self dismissModalViewControllerAnimated:YES];
}
- (void) cancelAddMKClient {
	[self dismissModalViewControllerAnimated:YES];
}
	
- (void) update:(MKClient*)mk {
	self.title = [mk firstName];
	//[appDelegate.mkClientNavigation pushViewController:self.MKClientView animated:YES];
	[self.firstName setText:[mk firstName]];
	[self.lastName setText:[mk lastName]];
	[self.creditCard setText:@""];
	//[self.creditCard setText:[mk creditCard]];
	[self.address setText:[mk address]];
	//[self.directions setTitle:@"Go" forState:UIControlStateNormal];
	//[self.directions setTitle:@"Go" forState:UIControlStateHighlighted];
	NSString *emailTitle = [mk.email isEqualToString:@""] ? @"No Email Address" : [NSString stringWithFormat:@"Email: %@", [mk email]];
	NSString *callTitle = [mk.phone isEqualToString:@""] ? @"No Phone Number" : [NSString stringWithFormat:@"Call: %@", [mk phone]];
	[self.email setTitle:emailTitle forState:UIControlStateNormal];
	[self.email setTitle:emailTitle forState:UIControlStateHighlighted];
	[self.phone setTitle:callTitle forState:UIControlStateNormal];
	[self.phone setTitle:callTitle forState:UIControlStateHighlighted];
	
	[self setMkclient:mk];
	
	NSString *deviceType = [UIDevice currentDevice].model;
	
	directions.enabled = ![mk.address isEqualToString:@""];
	phone.enabled = [deviceType isEqualToString:@"iPhone"] &&
					   ![mk.phone isEqualToString:@""];
	email.enabled = [MFMailComposeViewController canSendMail] &&
						![mk.email isEqualToString:@""];
	
	receipts.enabled = YES;
	profile.enabled = YES;
}

- (IBAction) directionsAction {
	// Create your query ...
	NSString* searchQuery = mkclient.address;//@"1 Infinite Loop, Cupertino, CA 95014";
	
	// Be careful to always URL encode things like spaces and other symbols that aren't URL friendly
	searchQuery =  [mkclient.address stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
	
	Mary_KayAppDelegate *appDelegate =   (Mary_KayAppDelegate *)[[UIApplication sharedApplication] delegate];
	CLLocationCoordinate2D coordinate = [appDelegate getCoordinate];
	
	// Now create the URL string ...
	NSString* urlString = [NSString stringWithFormat:@"http://maps.google.com/maps?daddr=%@&saddr=%f,%f", searchQuery, 
						   coordinate.latitude, 
						   coordinate.longitude];
	
	// An the final magic ... openURL!
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

- (IBAction) callAction {
	//finalString = [[firstString stringByReplacingOccurancesOfString:@"O" withString:@"0"] stringByReplacingOccurancesOfString:@"o" withString:@"0"];
	NSString *phone_number = [NSString stringWithFormat:@"tel://%@", [mkclient.phone stringByReplacingOccurrencesOfString:@"-" withString:@""	]];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone_number]];
	NSLog([NSString stringWithFormat:@"Phone Call: %@", phone_number]);
}


- (IBAction) emailAction {
	
	MFMailComposeViewController *emailViewController = [[MFMailComposeViewController alloc] init];
	
	emailViewController.mailComposeDelegate = self;

	[emailViewController setSubject:@"Mary Kay"];
	[emailViewController setToRecipients:[NSArray arrayWithObject:mkclient.email]];
	[emailViewController setMessageBody:@"" isHTML:NO];
	[self presentModalViewController:emailViewController animated:YES];
	[emailViewController release];
	
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[self becomeFirstResponder];
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction) profileAction {
	Mary_KayAppDelegate *appDelegate = (Mary_KayAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if(self.MKProfileView == nil) {
		MKProfileViewController *viewController = [[MKProfileViewController alloc] initWithNibName:@"MKProfileView" bundle:nil];
		self.MKProfileView = viewController;
		[viewController release];
	}
	
	[appDelegate.mkClientNavigation pushViewController:self.MKProfileView animated:YES];
	[self.MKProfileView update:self.mkclient];
}

- (IBAction) receiptsAction {
	Mary_KayAppDelegate *appDelegate = (Mary_KayAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if(self.MKReceiptsView == nil) {
		MKReceiptListViewController *viewController = [[MKReceiptListViewController alloc] initWithNibName:@"MKReceiptListView" bundle:nil];
		self.MKReceiptsView = viewController;
		[viewController release];
	}
	
	[appDelegate.mkClientNavigation pushViewController:self.MKReceiptsView animated:YES];
	[self.MKReceiptsView update:self.mkclient];
}


- (void)dealloc {
    [super dealloc];
}


@end
