//
//  MKProductGroup.m
//  MaryKay
//
//  Created by Charles Fisher on 6/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MKProductGroup.h"


@implementation MKProductGroup
@synthesize name, MKProducts;

- (id) init:(NSString*)name {
	if(self = [super init]) {
		self.name = name;
		self.MKProducts = [[NSMutableArray alloc] init];
	}
	return self;
}
- (void) addMK:(NSObject*)newProduct {
	[MKProducts addObject:newProduct];
}

- (NSString*) getType {return @"Group";}
- (NSString*) getCellIdentifier {return @"MKProductGroupCell";}
- (NSString*) getTableCellViewName {return @"MKProductGroupCellView";}


@end
