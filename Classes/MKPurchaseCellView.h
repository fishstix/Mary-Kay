//
//  MKPurchaseCellView.h
//  MaryKay
//
//  Created by Charles Fisher on 6/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKPurchase.h"

@interface MKPurchaseCellView : UITableViewCell {
	IBOutlet UILabel *nameLabel;
	IBOutlet UILabel *priceLabel;
	
	MKPurchase *mkpurchase;
}

@property (nonatomic, retain) MKPurchase *mkpurchase;

- (void) update:(MKPurchase*)mk;

@end
