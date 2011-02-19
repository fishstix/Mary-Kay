//
//  MKPurchase.m
//  Mary Kay
//
//  Created by Charles Fisher on 9/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MKPurchase.h"
#import "MKProduct.h"
#import "Mary_KayAppDelegate.h"

static sqlite3 *database = nil;
static sqlite3_stmt *deleteStmt = nil;
static sqlite3_stmt *updateStmt = nil;
static sqlite3_stmt *addStmt = nil;

@implementation MKPurchase
//@synthesize objectid;
@synthesize product,discount;

- (id)init:(MKProduct*)product_ discount:(float)discount_ {
	if ([super init]) {
		self.product	= product_;
		//self.party		= party;
		self.discount = discount_;
	}	
	return self;
}

- (float) getPrice {
	return (1 - (self.discount / 100)) * self.product.price;
}


- (void) addMKPurchase:(SQLObject*)mkreceipt {
	if (addStmt == nil) {
		const char *sql = "insert into mkpurchase (mkreceiptid,product,discount) values (?,?,?)";
		if (sqlite3_prepare_v2(database, sql, -1, &addStmt, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
		}
	}
		
	sqlite3_bind_int(addStmt, 1, mkreceipt.objectid);
	sqlite3_bind_text(addStmt, 2, [product.product_id UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_double(addStmt, 3, discount);
		
	if(SQLITE_DONE != sqlite3_step(addStmt)) {
		NSAssert1(0, @"Error while inserting purchase data. '%s'", sqlite3_errmsg(database));
	} else {
		objectid = sqlite3_last_insert_rowid(database);
	}
		
	// Reset the add statement.
	sqlite3_reset(addStmt);
}

- (void) updateMKPurchase {
	if (updateStmt == nil) {
		const char *sql = "update mkpurchase set product = ?, discount = ? where mkpurchasekey = ?";
		if (sqlite3_prepare_v2(database, sql, -1, &updateStmt, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error while creating update mkpurchase statement. '%s'", sqlite3_errmsg(database));
		}		
	}
	
	sqlite3_bind_text(updateStmt, 1, [product.product_id UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_double(updateStmt, 2, discount);
	sqlite3_bind_int(updateStmt, 3, objectid);
	
	if (SQLITE_DONE != sqlite3_step(updateStmt)) {
		NSAssert1(0, @"Error while updating mkpurchase. '%s'", sqlite3_errmsg(database));
	}
	
	sqlite3_reset(updateStmt);
}


- (void) deleteSQLObject {
	[self deleteMPurchase];
}

- (void) deleteMKPurchase {
	// Delete MKPurchase
	if(deleteStmt == nil) {
		const char *sql = "delete from mkpurchase where mkpurchasekey = ?";
		if(sqlite3_prepare_v2(database, sql, -1, &deleteStmt, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error while creating delete statement. '%s'", sqlite3_errmsg(database));
		}
	}
	
	sqlite3_bind_int(deleteStmt, 1, objectid);
	
	if (SQLITE_DONE != sqlite3_step(deleteStmt)) {
		NSAssert1(0, @"Error while deleting mkpurchase. '%s'", sqlite3_errmsg(database));
	}
	
	sqlite3_reset(deleteStmt);
}

+ (void) getInitialData:(NSString *)dbPath {
	Mary_KayAppDelegate *appDelegate = (Mary_KayAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
		const char *sql = "select * from mkpurchase";
		sqlite3_stmt *selectstmt;
		if (sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
			while (sqlite3_step(selectstmt) == SQLITE_ROW) {
				NSInteger purchaseid = sqlite3_column_int(selectstmt, 0);
				// Read the data from the result row
				NSInteger receiptId = sqlite3_column_int(selectstmt, 1);
				float discount = (float) sqlite3_column_double(selectstmt, 3);
				NSString *productId =   [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 2)];
				
				MKReceipt *mkreceipt = [appDelegate getMKReceipt:receiptId];
				MKPurchase *mkpurchase = [[MKPurchase alloc] initWithPrimaryKey:purchaseid];
				mkpurchase.product = [appDelegate getMKProduct:productId];
				mkpurchase.discount = discount;
				[mkreceipt addPurchase:mkpurchase];
				
				[appDelegate.mkpurchases addObject:mkpurchase];
				//[mkreceipt release];
				[mkpurchase release];
			}
		}
	} else {
		sqlite3_close(database);
	}
}
+ (void) finalizeStatements {
	if (database) sqlite3_close(database);
	if (deleteStmt) sqlite3_finalize(deleteStmt);
	if (updateStmt) sqlite3_finalize(updateStmt);
	if (addStmt) sqlite3_finalize(addStmt);
}


@end
