//
//  MKProductCellView.m
//  MaryKay
//
//  Created by Charles Fisher on 4/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MKProductCellView.h"
#import "AsyncImageView.h"
#import "Mary_KayAppDelegate.h"

@implementation MKProductCellView
@synthesize imageView;
@synthesize mkproduct;

listening = NO;

- (void) setProductCellDetails:(MKProduct *)mk {
	if (!listening) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mkProductUpdated:) name:MKProductUpdate object:nil];
		listening = YES;
	}
	
	if(mk != self.mkproduct) {
		// Remove Old Image
		[self.mkproduct removeImage];
		// Get New Image
		[self setMkproduct:mk];
	
		[nameLabel setText:mk.name];
		[priceLabel setText:[NSString stringWithFormat:@"$%.2f", mk.price]];
	}
	[imageView setImage: [mk getImage]];
	
	//CGRect frame;
	//frame.size.width = 75; frame.size.height = 75;
	//frame.origin.x = 0; frame.origin.y = 0;
	//AsyncImageView *asyncImage = [[[AsyncImageView alloc]
	//							   initWithFrame:frame] autorelease];
	//asyncImage.tag = 999;
	//NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://content2.marykayintouch.com/public/PWS_US/Images/%@.jpg",mk.product_id]];
	//[asyncImage loadImageFromURL:url];
	
	//[self.contentView addSubview:asyncImage];
}

- (void) mkProductUpdated:(NSNotification*) notification {
	MKProduct *mk = (MKProduct*)[notification object];
	if (mk == self.mkproduct) {
		[self setProductCellDetails:mk];
	}
}


- (void)dealloc {
	[nameLabel release];
	[priceLabel release];
	[imageView release];
	[super dealloc];
}


@end
