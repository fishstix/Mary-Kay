//
//  MKPartyTableViewController.h
//  MaryKay
//
//  Created by Charles Fisher on 5/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MKPartyCellView;
@class MKPartyViewController;

@interface MKPartyTableViewController : UITableViewController {
	IBOutlet MKPartyCellView *cell;
	MKPartyViewController *MKPartyView;
}

@property (nonatomic, retain) MKPartyViewController *MKPartyView;

@end
