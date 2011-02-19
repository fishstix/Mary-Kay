//
//  MKReceiptProductsTableViewController.h
//  MaryKay
//
//  Created by Charles Fisher on 4/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKReceipt.h"
#import "MKPurchaseViewController.h"

@class MKPurchaseCellView;

@interface MKReceiptProductsTableViewController : UITableViewController {
	IBOutlet MKPurchaseCellView *cell;
	
	MKPurchaseViewController *MKPurchaseView;
	UINavigationController *navController;
	
	MKReceipt *receipt;
}

@property (nonatomic, retain) MKPurchaseViewController *MKPurchaseView;
@property (nonatomic, retain) UINavigationController *navController;
@property (nonatomic, retain) MKReceipt *receipt;

- (void) update:(MKReceipt*)receipt;

@end
