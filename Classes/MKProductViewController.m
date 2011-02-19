//
//  MKProductViewController.m
//  Mary Kay
//
//  Created by Charles Fisher on 8/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MKProductViewController.h"


@implementation MKProductViewController
@synthesize MKProductDescription,MKProductPrice,MKProductName,MKProductImage;

- (void) update:(MKProduct*)mk {
	self.title = [mk name];
	[self.MKProductDescription setText:[mk description]];
	[self.MKProductName setText:[mk name]];
	[self.MKProductPrice setText:[NSString stringWithFormat:@"Price: $%.2f", [mk price]]];
	//UIImage *image = [UIImage imageNamed:mk.image];
	[self.MKProductImage setImage:mk.image];
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}


@end
