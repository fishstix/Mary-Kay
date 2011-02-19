//
//  MKPartyListViewController.h
//  Mary Kay
//
//  Created by Charles Fisher on 9/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKAddEditPartyViewController.h"

@class MKPartyTableViewController;

@interface MKPartyListViewController : UIViewController <MKAddEditPartyDelegate> {
	IBOutlet MKPartyTableViewController *partiesTableView;
}

@end