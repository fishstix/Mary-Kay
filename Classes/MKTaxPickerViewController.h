//
//  MKTaxPickerViewController.h
//  MaryKay
//
//  Created by Charles Fisher on 6/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MKTaxPickerDelegate

@required
- (void) updateTax:(float)tax;

@end


@interface MKTaxPickerViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate> {
	IBOutlet UIPickerView *picker;
	IBOutlet UILabel *taxLabel;
	id<MKTaxPickerDelegate> delegate;
	
	int limit;
	float initial_tax;
}

@property (nonatomic, retain) IBOutlet UILabel *taxLabel;
@property (nonatomic, retain) id<MKTaxPickerDelegate> delegate;

- (void) update:(float)tax limit:(int)limit;

@end
