//
//  MKProductGroup.h
//  MaryKay
//
//  Created by Charles Fisher on 6/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKProd.h"

@interface MKProductGroup : MKProd {
	NSString *name;
	NSMutableArray *MKProducts;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSMutableArray *MKProducts;

- (id) init:(NSString*)name;
- (void) addMK:(NSObject*)newProduct;

@end
