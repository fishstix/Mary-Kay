//
//  MKPartyCellView.h
//  MaryKay
//
//  Created by Charles Fisher on 5/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKParty.h"

@interface MKPartyCellView : UITableViewCell {
	IBOutlet UILabel *dateLabel;
	IBOutlet UILabel *hostLabel;
	
	MKParty *mkparty;
}

@property (nonatomic, retain) IBOutlet UILabel *dateLabel;
@property (nonatomic, retain) IBOutlet UILabel *hostLabel;

@property (nonatomic, retain) MKParty *mkparty;

- (void) update:(MKParty*)party;

@end
