//
//  SQLObject.h
//  MaryKay
//
//  Created by Charles Fisher on 8/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>


@interface SQLObject : NSObject {
	NSInteger objectid;
}

@property (nonatomic, readonly) NSInteger objectid;

- (id) initWithPrimaryKey:(NSInteger)pk;

- (void) deleteSQLObject;

@end
