//
//  MKReceiptViewController.h
//  MaryKay
//
//  Created by Charles Fisher on 4/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKReceipt.h"
#import "MKClient.h"
#import "MKReceiptProductsTableViewController.h"
#import "MKPurchasePickerViewController.h"
#import "MKReceiptSettingsViewController.h"

@interface MKReceiptViewController : UIViewController <MKPurchasePickerDelegate> {
	MKClient *mkclient;
	MKReceipt *receipt;
	
	IBOutlet UIButton *total;
	IBOutlet UILabel *totalCost;
	IBOutlet UILabel *dateLabel;
	IBOutlet MKReceiptProductsTableViewController *MKReceiptProductTable;
	
	MKReceiptSettingsViewController *MKReceiptSettingsView;
}

@property (nonatomic, retain) MKClient *mkclient;
@property (nonatomic, retain) MKReceipt *receipt;
@property (nonatomic, retain) IBOutlet MKReceiptProductsTableViewController *MKReceiptProductTable;
@property (nonatomic, retain) MKReceiptSettingsViewController *MKReceiptSettingsView;

- (void) update:(MKReceipt*)r client:(MKClient*)mk;
- (IBAction) receiptSettings;

@end
