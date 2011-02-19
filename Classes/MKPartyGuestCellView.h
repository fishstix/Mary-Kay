//
//  MKPartyGuestCellView.h
//  MaryKay
//
//  Created by Charles Fisher on 5/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKPartyGuestReceipt.h"
#import "MKProfileViewController.h"
#import "MKReceiptViewController.h"

@interface MKPartyGuestCellView : UITableViewCell {
	IBOutlet UILabel *nameLabel;
	IBOutlet UILabel *profileLabel;
	IBOutlet UIButton *profileButton;
	IBOutlet UIButton *receiptButton;
	
	MKPartyGuestReceipt *mkguestreceipt;
	
	MKProfileViewController *MKProfileView;
	MKReceiptViewController *MKReceiptView;
}

@property (nonatomic, retain) MKPartyGuestReceipt *mkguestreceipt;

@property (nonatomic, retain) MKProfileViewController *MKProfileView;
@property (nonatomic, retain) MKReceiptViewController *MKReceiptView;

- (IBAction) profileAction;
- (IBAction) receiptAction;

- (void) update:(MKPartyGuestReceipt*)mk;

@end
