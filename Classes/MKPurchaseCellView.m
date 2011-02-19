//
//  MKPurchaseCellView.m
//  MaryKay
//
//  Created by Charles Fisher on 6/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MKPurchaseCellView.h"
#import "MKProduct.h"

@implementation MKPurchaseCellView
@synthesize mkpurchase;

- (void) update:(MKPurchase*)mk {
	[self setMkpurchase:mk];
	[self updatePurchase];
}

- (void) updatePurchase {
	[nameLabel setText:self.mkpurchase.product.name];
	[priceLabel setText:[NSString stringWithFormat:@"$%.2f",[self.mkpurchase getPrice]]];
}


- (void)dealloc {
    [super dealloc];
}


@end
