//
//  MKReceiptCellView.m
//  MaryKay
//
//  Created by Charles Fisher on 4/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MKReceiptCellView.h"
#import "Mary_KayAppDelegate.h"

@implementation MKReceiptCellView
@synthesize dateLabel, costLabel;
@synthesize receipt;

- (void) update:(MKReceipt *)r {
	
	[self setReceipt:r];
	[self.dateLabel setText:[receipt getFormattedDate]];
	[self.costLabel setText:[NSString stringWithFormat:@"$%2.2f",[receipt getTotalPrice]]];

}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
    [super dealloc];
}


@end
