//
//  MKPartyGuestTableVIewController.h
//  MaryKay
//
//  Created by Charles Fisher on 5/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKParty.h"

@class MKPartyGuestCellView;
@class MKPartyGuestViewController;

@interface MKPartyGuestTableViewController : UITableViewController {
	
	IBOutlet MKPartyGuestCellView *cell;
	
	MKPartyGuestViewController *MKPartyGuestView;
	
	MKParty *mkparty;
	NSMutableArray *guests;
	
}

@property (nonatomic, retain) MKParty *mkparty;
@property (nonatomic, retain) NSMutableArray *guests;
@property (nonatomic, retain) MKPartyGuestViewController *MKPartyGuestView;

- (void) update:(MKParty*)mk;

@end
