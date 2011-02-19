//
//  MKReceiptCellView.h
//  MaryKay
//
//  Created by Charles Fisher on 4/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKReceipt.h"

@interface MKReceiptCellView : UITableViewCell {
	IBOutlet UILabel *dateLabel;
	IBOutlet UILabel *costLabel;
	
	MKReceipt *receipt;
}

@property (nonatomic, retain) IBOutlet UILabel *dateLabel;
@property (nonatomic, retain) IBOutlet UILabel *costLabel;

@property (nonatomic, retain) MKReceipt *receipt;

- (void) update:(MKReceipt*)receipt;

@end
