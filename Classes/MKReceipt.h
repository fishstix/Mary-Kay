//
//  MKReceipt.h
//  MaryKay
//
//  Created by Charles Fisher on 4/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKPurchase.h"
#import "SQLObject.h"

@interface MKReceipt : SQLObject {
	NSMutableArray *purchases;
	NSDate *date;
	float tax;
	float discount;
}

@property (nonatomic, retain) NSMutableArray *purchases;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, assign) float tax;
@property (nonatomic, assign) float discount;

- (NSString*) getFormattedDate;
- (int) getNumPurchases;
- (float) getSubTotal;
- (float) getTotalPrice;
- (void) addPurchase:(MKPurchase *) purchase;

- (void) addMKReceipt:(SQLObject*)mkclient;
- (void) updateMKReceipt;
- (void) deleteMKReceipt;
+ (void) getInitialData:(NSString *)dbPath;
+ (void) finalizeStatements;
@end
