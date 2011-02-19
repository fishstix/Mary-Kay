//
//  MKPartyTypeTableViewController.h
//  MaryKay
//
//  Created by Charles Fisher on 5/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKParty.h"

@interface MKPartyTypeTableViewController : UITableViewController {
	MKParty *mkparty;
}

@property (nonatomic, retain) MKParty *mkparty;

- (void) update:(MKParty*) mk;
- (int) getPartyType;

@end
