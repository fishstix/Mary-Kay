//
//  MKPartyGuestView.h
//  MaryKay
//
//  Created by Charles Fisher on 5/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKParty.h"
#import "MKPartyGuestReceipt.h"
#import "MKAddEditPartyViewController.h"

@class MKReceiptViewController;
@class MKProfileViewController;

@interface MKPartyGuestViewController : UIViewController <MKAddEditPartyDelegate, UIAlertViewDelegate> {
	IBOutlet UILabel *firstName;
	IBOutlet UILabel *lastName;
	IBOutlet UIButton *phone;
	
	IBOutlet UIButton *bookParty;
	IBOutlet UIButton *receipt;
	IBOutlet UIButton *profile;
	
	MKReceiptViewController *MKReceiptView;
	MKProfileViewController *MKProfileView;
	
	MKParty *mkparty;
	MKPartyGuestReceipt *mkguest;
	
	float discount;
}
@property (nonatomic, retain) MKParty *mkparty;
@property (nonatomic, retain) MKPartyGuestReceipt *mkguest;

@property (nonatomic, retain) IBOutlet UILabel *firstName;
@property (nonatomic, retain) IBOutlet UILabel *lastName;
@property (nonatomic, retain) IBOutlet UIButton *phone;
@property (nonatomic, retain) IBOutlet UIButton *bookParty;

@property (nonatomic, retain) MKProfileViewController *MKProfileView;
@property (nonatomic, retain) MKReceiptViewController *MKReceiptView;

- (void) update:(MKPartyGuestReceipt*)client party:(MKParty*)party;

- (IBAction) callAction;
- (IBAction) bookPartyAction;
- (IBAction) profileAction;
- (IBAction) receiptAction;

@end
