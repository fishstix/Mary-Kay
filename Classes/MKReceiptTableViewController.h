//
//  MKReceiptTableViewController.h
//  MaryKay
//
//  Created by Charles Fisher on 4/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKClient.h"

@class MKReceiptCellView;
@class MKReceiptViewController;

@interface MKReceiptTableViewController : UITableViewController {
	MKClient *mkclient;
	IBOutlet MKReceiptCellView *cell;
	//NSMutableArray *receipts;
	
	MKReceiptViewController *MKReceiptView;
}

//@property (nonatomic, retain) NSMutableArray *receipts;
@property (nonatomic, retain) MKClient *mkclient;
@property (nonatomic, retain) MKReceiptViewController *MKReceiptView;

- (void) update:(MKClient*)mk;

@end
