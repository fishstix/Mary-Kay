//
//  MKClientPickerViewController.h
//  MaryKay
//
//  Created by Charles Fisher on 5/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MKClient.h"
#import "MKAddEditClientViewController.h"

@protocol MKClientPickerDelegate

@required
- (void) selectedMKClient:(MKClient*)mk;
- (void) canceledMKClient;

@end


@interface MKClientPickerViewController : UITableViewController <MKAddEditClientDelegate> {
	
	NSMutableArray *listOfItems;
	NSMutableArray *copyListOfItems;
	//IBOutlet UINavigationController *navControl;
	//IBOutlet UINavigationBar *navBar;
	IBOutlet UISearchBar *searchBar;
	//IBOutlet UIBarButtonItem *cancelButton;
	IBOutlet UIView *topView;
	//IBOutlet UINavigationBar *titleBar;
	//IBOutlet UINavigationItem *titleItem;
	BOOL searching;
	BOOL letUserSelectRow;
	
	NSString *addressTitle;
	//Command *updatePositionCommand;
	
	id<MKClientPickerDelegate> delegate;
		
	NSMutableArray *remove_List;
}

@property (nonatomic, retain) NSString *addressTitle;
//@property (nonatomic, retain) IBOutlet UINavigationBar *navBar;
//@property (nonatomic, retain) IBOutlet UINavigationController *navControl;
@property (nonatomic, retain) IBOutlet UIView *topView;
//@property (nonatomic, retain) IBOutlet UINavigationBar *titleBar;
//@property (nonatomic, retain) IBOutlet UINavigationItem *titleItem;
//@property (nonatomic, retain) Command *updatePositionCommand;
@property (nonatomic, retain) id<MKClientPickerDelegate> delegate;

@property (nonatomic, retain) NSMutableArray *remove_List;

//+ (Location*)local;
- (IBAction) cancel;
//- (void) setTitle:(NSString*)title;
- (void) searchTableView;
- (void) doneSearching_Clicked:(id) sender;

@end
