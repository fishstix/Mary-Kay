//
//  MKPurchasePickerViewController.h
//  MaryKay
//
//  Created by Charles Fisher on 5/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MKProductTableViewController.h"
#import "MKPurchase.h"

@protocol MKPurchasePickerDelegate

@required
- (void) selectedMKPurchase:(MKPurchase*)mk;
- (void) canceledMKPurchase;

@end


//@interface MKPurchasePickerViewController : UITableViewController {
@interface MKPurchasePickerViewController : MKProductTableViewController {	

	MKPurchasePickerViewController *pickerViewController;
	UINavigationController *navigationController;
	
	NSMutableArray *listOfItems;
	NSMutableArray *copyListOfItems;
	IBOutlet UISearchBar *searchBar;
	IBOutlet UIView *topView;
	BOOL searching;
	BOOL letUserSelectRow;
	
	NSString *addressTitle;
	
	id<MKPurchasePickerDelegate> delegate;
}

@property (nonatomic, retain) MKPurchasePickerViewController *pickerViewController;
@property (nonatomic, retain) UINavigationController *navigationController;
@property (nonatomic, retain) NSString *addressTitle;
@property (nonatomic, retain) IBOutlet UIView *topView;
@property (nonatomic, retain) id<MKPurchasePickerDelegate> delegate;

- (void) includeCancelButton;
- (void) loadProducts:(NSMutableArray*)mkproducts;

- (IBAction) cancel;
- (void) searchTableView;
- (void) doneSearching_Clicked:(id) sender;

@end
