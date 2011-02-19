//
//  MKProductViewController.h
//  Mary Kay
//
//  Created by Charles Fisher on 8/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKProduct.h"

@interface MKProductViewController : UIViewController {
	IBOutlet UITextView *MKProductDescription;
	IBOutlet UILabel    *MKProductPrice;
	IBOutlet UILabel    *MKProductName;
	IBOutlet UIImageView *MKProductImage;
}

@property (nonatomic, retain) IBOutlet UITextView *MKProductDescription;
@property (nonatomic, retain) IBOutlet UILabel *MKProductPrice;
@property (nonatomic, retain) IBOutlet UILabel *MKProductName;
@property (nonatomic, retain) IBOutlet UIImageView *MKProductImage;

- (void) update:(MKProduct*)mk;

@end
