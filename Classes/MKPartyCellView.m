//
//  MKPartyCellView.m
//  MaryKay
//
//  Created by Charles Fisher on 5/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MKPartyCellView.h"
#import "MKClient.h"
#import "MKPartyGuestReceipt.h"


@implementation MKPartyCellView
@synthesize dateLabel,hostLabel;
@synthesize mkparty;

- (void) update:(MKParty *)party {
	[self setMkparty:party];
	
	//[self.dateLabel setText:[NSString stringWithFormat:@"%@",[formatter stringFromDate:mkparty.date]]];
	[self.dateLabel setText:[self.mkparty getFormattedDate]];
	[self.hostLabel setText:mkparty.host.mkclient.firstName];
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
	[dateLabel release];
	[hostLabel release];
	
	[mkparty release];
	
    [super dealloc];
}


@end
