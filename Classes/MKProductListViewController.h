//
//  MKProductListViewController.h
//  Mary Kay
//
//  Created by Charles Fisher on 8/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MKProductTableViewController;

@interface MKProductListViewController : UIViewController {
	IBOutlet MKProductTableViewController *productsTableView;
}

@property (nonatomic, retain) IBOutlet MKProductTableViewController *productsTableView;

@end
