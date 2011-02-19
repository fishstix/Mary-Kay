    //
//  MKProfileViewController.m
//  MaryKay
//
//  Created by Charles Fisher on 4/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MKProfileViewController.h"
#import "Mary_KayAppDelegate.h"

@implementation MKProfileViewController
@synthesize mkclient;

- (void) viewDidLoad {
	[super viewDidLoad];
	[scrollView setContentSize:CGSizeMake(320, 960)];
	//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mkClientUpdated) name:MKClientUpdate object:nil];
}

- (void) mkClientUpdated {
	[self update:mkclient];
}

- (void) update:(MKClient *)mk {
	[scrollView setContentOffset:CGPointZero];
	
	[self setMkclient:mk];
	[self setTitle:[NSString stringWithFormat:@"%@'s Skin Profile", mk.firstName]];
	[skinTypeTableView update:mk];
	[skinToneTableView update:mk];
	[foundationPrefTableView update:mk];
	[skinCareTableView update:mk];
}


- (void)dealloc {
    [super dealloc];
}


@end
