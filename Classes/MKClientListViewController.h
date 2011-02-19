//
//  MKClientListViewController.h
//  Mary Kay
//
//  Created by Charles Fisher on 9/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKAddEditClientViewController.h"
//#import "MKAddEditClientDelegate.h"

@class MKClientTableViewController;

@interface MKClientListViewController : UIViewController <MKAddEditClientDelegate> {
	IBOutlet MKClientTableViewController *clientsTableView;
}

@end
