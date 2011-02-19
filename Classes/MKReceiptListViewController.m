    //
//  MKReceiptListViewController.m
//  MaryKay
//
//  Created by Charles Fisher on 4/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MKReceiptListViewController.h"
#import "Mary_KayAppDelegate.h"

@implementation MKReceiptListViewController
@synthesize mkclient;

- (void) viewDidLoad {
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] 
								  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
								  target:self 
								  action:@selector(addMKReceipt)];
	self.navigationItem.rightBarButtonItem = addButton;
}

- (void) addMKReceipt {
	Mary_KayAppDelegate *appDelegate = (Mary_KayAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate addMKReceipt:self.mkclient];
}

- (void) update:(MKClient *)mk {
	[self setTitle:[NSString stringWithFormat:@"%@'s Receipts", mk.firstName]];
	[self setMkclient:mk];
	[receiptsTableView update:mk];
}

- (void) viewWillAppear:(BOOL)animated {
	[receiptsTableView viewWillAppear:animated];
}

- (void)dealloc {
    [super dealloc];
}


@end
