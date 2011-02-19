//
//  MKReceiptSettingsViewController.h
//  MaryKay
//
//  Created by Charles Fisher on 6/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKReceipt.h"
#import "MKTaxPickerViewController.h"
#import "MKDiscountPickerViewController.h"

@interface MKReceiptSettingsViewController : UIViewController <MKTaxPickerDelegate, MKDiscountPickerDelegate> {
	IBOutlet UILabel *subTotal;
	IBOutlet UIButton *discount;
	IBOutlet UIButton *tax;
	IBOutlet UILabel *total;
	
	MKReceipt *mkreceipt;
}

@property (nonatomic, retain) MKReceipt *mkreceipt;

- (void) update:(MKReceipt*)mk;
- (IBAction) chooseTax;
- (IBAction) chooseDiscount;

@end
