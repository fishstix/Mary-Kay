//
//  MKProductTableViewController.h
//  MaryKay
//
//  Created by Charles Fisher on 4/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MKProductCellView;
@class MKProductGroupCellView;
@class MKProductViewController;
@class MKProductListViewController;

@interface MKProductTableViewController : UITableViewController {
	IBOutlet MKProductCellView *cellProduct;
	IBOutlet MKProductGroupCellView *cellGroup;
	//IBOutlet UITableViewCell *cell;
	MKProductViewController *MKProductView;
	MKProductListViewController *MKProductListView;
	
	NSMutableArray *mkproducts;
	
	NSMutableArray *arrayOfCharacters;
	NSMutableDictionary *objectsForCharacters;
}

@property (nonatomic, retain) NSMutableArray *mkproducts;
@property (nonatomic, retain) MKProductViewController *MKProductView;
@property (nonatomic, retain) MKProductListViewController *MKProductListView;

@end
