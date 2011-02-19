//
//  MKClientCellView.m
//  MaryKay
//
//  Created by Charles Fisher on 4/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MKClientCellView.h"


@implementation MKClientCellView

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
