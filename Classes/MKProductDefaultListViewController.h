//
//  MKProductDefaultListViewController.h
//  MaryKay
//
//  Created by Charles Fisher on 6/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
	
@class MKProductTableViewController;
	
@interface MKProductDefaultListViewController : UIViewController {
	IBOutlet MKProductTableViewController *productsTableView;
}

@property (nonatomic, retain) IBOutlet MKProductTableViewController *productsTableView;

@end
