//
//  MKPurchaseViewController.h
//  MaryKay
//
//  Created by Charles Fisher on 6/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKPurchase.h"
#import "MKTaxPickerViewController.h"

@interface MKPurchaseViewController : UIViewController <MKTaxPickerDelegate> {
	IBOutlet UILabel *priceLabel;
	IBOutlet UIButton *discountButton;
	IBOutlet UILabel *finalPriceLabel;
	IBOutlet UIImageView *productImage;
	
	MKPurchase *mkpurchase;
}

@property (nonatomic, retain) MKPurchase *mkpurchase;

- (void) update:(MKPurchase*)mk;
- (IBAction) chooseDiscount;

@end
