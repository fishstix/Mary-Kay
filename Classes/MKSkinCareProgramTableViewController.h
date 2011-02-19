//
//  MKSkinCareProgramTableViewController.h
//  MaryKay
//
//  Created by Charles Fisher on 4/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKClient.h"


@interface MKSkinCareProgramTableViewController : UITableViewController {
	MKClient *mkclient;
}

@property (nonatomic, retain) MKClient *mkclient;

- (void) update:(MKClient*) mk;

@end
