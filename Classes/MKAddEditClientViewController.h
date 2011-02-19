//
//  MKAddClientViewController.h
//  MaryKay
//
//  Created by Charles Fisher on 5/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "MKClient.h"


@protocol MKAddEditClientDelegate

- (void) saveMKClient:(MKClient*)mk;
- (void) cancelAddMKClient;

@end

@interface MKAddEditClientViewController : UIViewController <ABPeoplePickerNavigationControllerDelegate> {

	IBOutlet UITextField *firstName;
	IBOutlet UITextField *lastName;
	IBOutlet UITextField *address;
	IBOutlet UITextField *phone;
	IBOutlet UITextField *email;
	
	IBOutlet UIButton *contactsButton;
	
	MKClient *mkclient;
	
	id<MKAddEditClientDelegate> delegate;
	
}

@property (nonatomic, retain) IBOutlet UITextField *firstName;
@property (nonatomic, retain) IBOutlet UITextField *lastName;
@property (nonatomic, retain) IBOutlet UITextField *address;
@property (nonatomic, retain) IBOutlet UITextField *phone;
@property (nonatomic, retain) IBOutlet UITextField *email;

@property (nonatomic, retain) MKClient *mkclient;

@property (nonatomic, assign) id<MKAddEditClientDelegate> delegate;

- (void) update:(MKClient*)mk;

- (IBAction) contactsAction;

@end
