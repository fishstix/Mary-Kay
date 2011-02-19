//
//  MKPurchase.h
//  Mary Kay
//
//  Created by Charles Fisher on 9/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQLObject.h"

@class MKProduct;
//@class MKParty;

@interface MKPurchase : SQLObject {
	MKProduct *product;
	float discount;
	//MKParty *party;
}

@property (nonatomic, retain) MKProduct *product;
@property (nonatomic, assign) float discount;
//@property (nonatomic, retain) MKParty *party;

//- (id) init:(MKProduct*)product party:(MKParty*)party;
- (id) init:(MKProduct *)product discount:(float)discount;
- (float) getPrice;


- (void) addMKPurchase:(SQLObject*)mkreceipt;
- (void) updateMKPurchase;
- (void) deleteMKPurchase;
+ (void) getInitialData:(NSString *)dbPath;
+ (void) finalizeStatements;


@end
