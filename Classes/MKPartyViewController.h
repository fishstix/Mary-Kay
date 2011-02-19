//
//  MKPartyViewController.h
//  Mary Kay
//
//  Created by Charles Fisher on 9/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKAddEditPartyViewController.h"

@class MKParty;
@class MKPartyGuestListViewController;

@interface MKPartyViewController : UIViewController <MKAddEditPartyDelegate> {
	IBOutlet UILabel *host;
	IBOutlet UILabel *location;
	IBOutlet UILabel *date;
	IBOutlet UILabel *type;
	IBOutlet UIButton *guests;
	
	MKPartyGuestListViewController *MKGuestListView;

	MKParty *party;
}

@property (nonatomic, retain) IBOutlet UILabel *host;
@property (nonatomic, retain) IBOutlet UILabel *location;
@property (nonatomic, retain) IBOutlet UILabel *type;
@property (nonatomic, retain) MKPartyGuestListViewController *MKGuestListView;
@property (nonatomic, retain) MKParty *party;

- (id)initWithParty:(MKParty*)mk;
- (IBAction) guestsAction;

@end
