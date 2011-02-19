//
//  MKClientViewController.h
//  Mary Kay
//
//  Created by Charles Fisher on 9/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "MKClient.h"
#import "MKClientReceiptsTableViewController.h"
#import "MKAddEditClientViewController.h"
//#import "MKAddEditClientDelegate.h"

@class MKProfileViewController;
@class MKReceiptListViewController;

@interface MKClientViewController : UIViewController <UIScrollViewDelegate, MFMailComposeViewControllerDelegate, MKAddEditClientDelegate> {
	
	//IBOutlet UIScrollView *scrollView;
	//IBOutlet MKClientReceiptsTableViewController *receptsView;
	
	IBOutlet UILabel *firstName;
	IBOutlet UILabel *lastName;
	IBOutlet UILabel *creditCard;
	IBOutlet UILabel *address;
	IBOutlet UIButton *directions;
	IBOutlet UIButton *email;
	IBOutlet UIButton *phone;
	
	IBOutlet UIButton *receipts;
	IBOutlet UIButton *profile;
	
	MKReceiptListViewController *MKReceiptsView;
	MKProfileViewController *MKProfileView;

	MKClient *mkclient;
	
}

@property (nonatomic, retain) IBOutlet UILabel *firstName;
@property (nonatomic, retain) IBOutlet UILabel *lastName;
@property (nonatomic, retain) IBOutlet UILabel *creditCard;
@property (nonatomic, retain) IBOutlet UILabel *address;
@property (nonatomic, retain) IBOutlet UIButton *directions;
@property (nonatomic, retain) IBOutlet UIButton *email;
@property (nonatomic, retain) IBOutlet UIButton *phone;

@property (nonatomic, retain) MKProfileViewController *MKProfileView;
@property (nonatomic, retain) MKReceiptListViewController *MKReceiptsView;

@property (nonatomic, retain) MKClient *mkclient;

- (void) update:(MKClient*)client;

- (IBAction) directionsAction;
- (IBAction) callAction;
- (IBAction) emailAction;
- (IBAction) profileAction;
- (IBAction) receiptsAction;

@end
