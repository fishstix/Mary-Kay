//
//  MKProfileViewController.h
//  MaryKay
//
//  Created by Charles Fisher on 4/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKClient.h"

@class MKSkinTypeTableViewController;
@class MKSkinToneTableViewController;
@class MKFoundationPrefTableViewController;
@class MKSkinCareProgramTableViewController;

@interface MKProfileViewController : UIViewController <UIScrollViewDelegate> {
	IBOutlet UIScrollView *scrollView;
	
	IBOutlet MKSkinTypeTableViewController *skinTypeTableView;
	IBOutlet MKSkinToneTableViewController *skinToneTableView;
	IBOutlet MKFoundationPrefTableViewController *foundationPrefTableView;
	IBOutlet MKSkinCareProgramTableViewController *skinCareTableView;

	MKClient *mkclient;
}

@property (nonatomic, retain) MKClient *mkclient;

- (void) update:(MKClient*)mk;

@end
