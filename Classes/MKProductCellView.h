//
//  MKProductCellView.h
//  MaryKay
//
//  Created by Charles Fisher on 4/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKProduct.h"

@interface MKProductCellView : UITableViewCell {
	IBOutlet UILabel *nameLabel;
	IBOutlet UILabel *priceLabel;
	IBOutlet UIImageView *imageView;
	
	bool listening;
	
	MKProduct *mkproduct;
}

@property (nonatomic, retain) MKProduct *mkproduct;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;

- (void) setProductCellDetails:(MKProduct *)mk;

@end
