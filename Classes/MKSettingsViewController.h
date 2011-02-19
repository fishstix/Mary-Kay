//
//  MKSettingsViewController.h
//  Mary Kay
//
//  Created by Charles Fisher on 9/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "MKTaxPickerViewController.h"

@interface MKSettingsViewController : UIViewController <MKTaxPickerDelegate, MFMailComposeViewControllerDelegate> {
	IBOutlet UIButton *taxButton;
}

@property (nonatomic, retain) IBOutlet UIButton *taxButton;

- (IBAction) chooseDefaultTax;
- (IBAction) emailSupportAction;

@end
