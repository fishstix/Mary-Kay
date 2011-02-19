//
//  MKDiscountPickerViewController.h
//  MaryKay
//
//  Created by Charles Fisher on 6/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MKDiscountPickerDelegate

@required
- (void) updateDiscount:(float)discount;

@end


@interface MKDiscountPickerViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate> {
	IBOutlet UIPickerView *picker;
	IBOutlet UILabel *discountLabel;
	id<MKDiscountPickerDelegate> delegate;
	
	float initial_discount;
}

@property (nonatomic, retain) IBOutlet UILabel *discountLabel;
@property (nonatomic, retain) id<MKDiscountPickerDelegate> delegate;

- (void) update:(float)discount;

@end
