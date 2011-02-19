//
//  SQLObject.m
//  MaryKay
//
//  Created by Charles Fisher on 8/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SQLObject.h"


@implementation SQLObject
@synthesize objectid;

- (id) initWithPrimaryKey:(NSInteger)pk {
	if (self = [super init]) {
		objectid = pk;
	}	
	return self;
}

@end
