    //
//  MKProductDefaultListViewController.m
//  MaryKay
//
//  Created by Charles Fisher on 6/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MKProductDefaultListViewController.h"
#import "MKProductTableViewController.h"
#import "MKProductViewController.h"
#import "MKProductNavigation.h"
#import "Mary_KayAppDelegate.h"
#import "MKProduct.h"



@implementation MKProductDefaultListViewController
@synthesize productsTableView;

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.title = NSLocalizedString(@"MK Products", @"Mary Kay Products");
	Mary_KayAppDelegate *appDelegate = (Mary_KayAppDelegate *)[[UIApplication sharedApplication] delegate];
	[self.productsTableView setMkproducts:appDelegate.mkproducts];
	[self.productsTableView.tableView reloadData];
}

- (void) viewWillAppear:(BOOL)animated {
	[productsTableView viewWillAppear:animated];
}

- (void)dealloc {
    [super dealloc];
}


@end

