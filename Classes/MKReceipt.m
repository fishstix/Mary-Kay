//
//  MKReceipt.m
//  MaryKay
//
//  Created by Charles Fisher on 4/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MKReceipt.h"
#import "Mary_KayAppDelegate.h"

static sqlite3 *database = nil;
static sqlite3_stmt *deleteStmt = nil;
static sqlite3_stmt *updateStmt = nil;
static sqlite3_stmt *addStmt = nil;

@implementation MKReceipt
//@synthesize objectid;
@synthesize purchases;
@synthesize date;
@synthesize tax;
@synthesize discount;

- (id) init {
	if ([super init]) {
		self.purchases = [[NSMutableArray alloc] initWithArray:nil];
		self.date = [[NSDate alloc] init];
		Mary_KayAppDelegate *appDelegate = (Mary_KayAppDelegate *)[[UIApplication sharedApplication] delegate];
		self.tax = appDelegate.default_tax;
		self.discount = 0;
	}
	return self;
}


NSDateFormatter *receiptformatter;

- (NSString*) getFormattedDate {
	if (receiptformatter == nil) {
		receiptformatter = [[NSDateFormatter alloc] init];
		[receiptformatter setDateFormat:@"yyyy/MM/dd"];
	}
	
	return [receiptformatter stringFromDate:self.date];
}

- (int) getNumPurchases {
	return [purchases count];
}

- (float) getSubTotal {
	float subtotal = 0;
	
	for (int i = 0; i < [purchases count]; i++) {
		subtotal = subtotal + [((MKPurchase *)[purchases objectAtIndex:i]) getPrice];
	}
	
	return subtotal;
}
- (float) getTotalPrice {
	float subtotal = [self getSubTotal] - discount;
	return subtotal * (1 + (tax / 100));
}

- (void) addPurchase:(MKPurchase *) purchase {
	[purchases addObject:purchase];
}



- (void) addMKReceipt:(MKClient*)mkclient {
	if (addStmt == nil) {
		const char *sql = "insert into mkreceipt (mkclientid,date,tax,discount) values (?,?,?,?)";
		if (sqlite3_prepare_v2(database, sql, -1, &addStmt, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
		}
	}	
	
	sqlite3_bind_int(addStmt, 1, mkclient.objectid);
	sqlite3_bind_double(addStmt, 2, [date timeIntervalSince1970]);
	sqlite3_bind_double(addStmt, 3, tax);
	sqlite3_bind_double(addStmt, 4, discount);
		
	if(SQLITE_DONE != sqlite3_step(addStmt)) {
		NSAssert1(0, @"Error while inserting receipt data. '%s'", sqlite3_errmsg(database));
	} else {
		objectid = sqlite3_last_insert_rowid(database);
	}
		
	// Reset the add statement.
	sqlite3_reset(addStmt);
}

- (void) updateMKReceipt {
	if (updateStmt == nil) {
		const char *sql = "update mkreceipt set date = ?, tax = ?, discount = ? where mkreceiptkey = ?";
		if (sqlite3_prepare_v2(database, sql, -1, &updateStmt, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error while creating update mkreceipt statement. '%s'", sqlite3_errmsg(database));
		}		
	}
	
	sqlite3_bind_double(updateStmt, 1, [date timeIntervalSince1970]);
	sqlite3_bind_double(updateStmt, 2, tax);
	sqlite3_bind_double(updateStmt, 3, discount);
	sqlite3_bind_int(updateStmt, 4, objectid);
	
	if (SQLITE_DONE != sqlite3_step(updateStmt)) {
		NSAssert1(0, @"Error while updating mkreceipt. '%s'", sqlite3_errmsg(database));
	}
	
	sqlite3_reset(updateStmt);
}



- (void) deleteSQLObject {
	[self deleteMKReceipt];
}

- (void) deleteMKReceipt {
	// Delete Contents of MKReceipt (e.g. Purchases)
	for (int i = 0; i < [purchases count]; i++) {
		[(MKPurchase*)[purchases objectAtIndex:i] deleteMKPurchase];
	}
	
	if(deleteStmt == nil) {
		const char *sql = "delete from mkreceipt where mkreceiptkey = ?";
		if(sqlite3_prepare_v2(database, sql, -1, &deleteStmt, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error while creating delete statement. '%s'", sqlite3_errmsg(database));
		}
	}
	
	sqlite3_bind_int(deleteStmt, 1, objectid);
	
	if (SQLITE_DONE != sqlite3_step(deleteStmt)) {
		NSAssert1(0, @"Error while deleting mkreceipt. '%s'", sqlite3_errmsg(database));
	}
	
	sqlite3_reset(deleteStmt);
}



+ (void) getInitialData:(NSString *)dbPath {
	Mary_KayAppDelegate *appDelegate = (Mary_KayAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
		const char *sql = "select * from mkreceipt";
		sqlite3_stmt *selectstmt;
		if (sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
			while (sqlite3_step(selectstmt) == SQLITE_ROW) {
				NSInteger receiptid = sqlite3_column_int(selectstmt, 0);
				// Read th edata from the result row
				NSInteger mkclientId = sqlite3_column_int(selectstmt, 1);
				//NSString* guestsString = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 1)];
				//NSArray* guestsValues = [guestsString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
				NSDate *date = [NSDate dateWithTimeIntervalSince1970:sqlite3_column_double(selectstmt, 2)];
				float tax = (float)sqlite3_column_double(selectstmt, 3);  //[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 3)];
				float discount = (float)sqlite3_column_double(selectstmt, 4);
				
				MKClient *mkclient = [appDelegate getMKClient:mkclientId];
				MKReceipt *mkreceipt = [[MKReceipt alloc] initWithPrimaryKey:receiptid];
				
				[mkclient addReceipt:mkreceipt];
				mkreceipt.date = date;
				mkreceipt.tax = tax;
				mkreceipt.discount = discount;
				mkreceipt.purchases = [[NSMutableArray alloc] initWithArray:nil];
				
				[appDelegate.mkreceipts addObject:mkreceipt];
				[mkreceipt release];
				//[mkclient release];
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
