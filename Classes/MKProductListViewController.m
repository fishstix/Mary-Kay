//
//  MKProductListViewController.m
//  Mary Kay
//
//  Created by Charles Fisher on 8/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MKProductListViewController.h"
#import "MKProductTableViewController.h"
#import "MKProductViewController.h"
#import "MKProductNavigation.h"
#import "Mary_KayAppDelegate.h"
#import "MKProduct.h"



@implementation MKProductListViewController
@synthesize productsTableView;

 - (void)viewDidLoad {
	 [super viewDidLoad];
	 
	 NSLog(@"Accessing MKProducts %i", self.productsTableView.mkproducts.count);
	 
	 //self.title = NSLocalizedString(@"MK Products", @"Mary Kay Products");
	 //Mary_KayAppDelegate *appDelegate = (Mary_KayAppDelegate *)[[UIApplication sharedApplication] delegate];
	 //[self.productsTableView setMkproducts:appDelegate.mkproducts];
	 //[self.productsTableView.tableView reloadData];
}

- (void) viewWillAppear:(BOOL)animated {
	[productsTableView viewWillAppear:animated];
}

- (void)dealloc {
    [super dealloc];
}


@end

