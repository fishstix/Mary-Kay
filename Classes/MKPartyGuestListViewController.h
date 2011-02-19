//
//  MKPartyGuestListViewController.h
//  Mary Kay
//
//  Created by Charles Fisher on 9/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKParty.h"
#import "MKClientPickerViewController.h"

@class MKPartyGuestTableViewController;

@interface MKPartyGuestListViewController : UIViewController <MKClientPickerDelegate> {
	MKParty *mkparty;
	
	IBOutlet MKPartyGuestTableViewController *guestsTableView;
}

@property (nonatomic, retain) MKParty *mkparty;

- (void) update:(MKParty*)mkparty;

@end
