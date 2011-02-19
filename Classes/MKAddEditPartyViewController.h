//
//  MKAddEditPartyViewController.h
//  MaryKay
//
//  Created by Charles Fisher on 5/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKParty.h"
#import "MKClient.h"
#import "DateViewController.h"
#import "TimeViewController.h"
#import "MKClientPickerViewController.h"
#import "MKPartyTypeTableViewController.h"

@protocol MKAddEditPartyDelegate

- (void) saveMKParty:(MKParty*)mk;
- (void) cancelAddEditMKParty;

@end


@interface MKAddEditPartyViewController : UIViewController <DateViewDelegate, TimeViewDelegate, MKClientPickerDelegate, UIAlertViewDelegate>{
	IBOutlet UILabel *dateLabel;
	IBOutlet UILabel *timeLabel;
	IBOutlet UILabel *hostLabel;
	IBOutlet UITextField *address;
	
	IBOutlet UIButton *selectDateButton;
	IBOutlet UIButton *selectTimeButton;
	IBOutlet UIButton *selectHostButton;
	
	IBOutlet MKPartyTypeTableViewController *selectPartyType;
	
	NSDate *date;
	NSDate *dateDate;
	NSDate *timeDate;
	MKClient *host;
	NSString *location;
	
	MKParty *mkparty;
	
	id<MKAddEditPartyDelegate> delegate;

	UINavigationController *navController;
}

@property (nonatomic, retain) IBOutlet UILabel *dateLabel;
@property (nonatomic, retain) IBOutlet UILabel *timeLabel;
@property (nonatomic, retain) IBOutlet UILabel *hostLabel;
@property (nonatomic, retain) IBOutlet UITextField *address;
@property (nonatomic, retain) IBOutlet MKPartyTypeTableViewController *selectPartyType;

@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSDate *dateDate;
@property (nonatomic, retain) NSDate *timeDate;
@property (nonatomic, retain) MKClient *host;
@property (nonatomic, retain) NSString *location;
@property (nonatomic, retain) MKParty *mkparty;
@property (nonatomic, assign) id<MKAddEditPartyDelegate> delegate;

@property (nonatomic, retain) UINavigationController *navController;

- (void) update:(MKParty*)mk;
- (void) updateHost:(MKClient*)mk;
//- (void) setHost:(MKClient*)mk;

- (IBAction) dateAction;
- (IBAction) timeAction;
- (IBAction) hostAction;

@end
