//
//  MKClientTableViewController.h
//  MaryKay
//
//  Created by Charles Fisher on 4/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MKClientCellView;
@class MKClientViewController;

@interface MKClientTableViewController : UITableViewController{
	IBOutlet MKClientCellView *cell;
	MKClientViewController *MKClientView;
}

@property (nonatomic, retain) MKClientViewController *MKClientView;

@end
