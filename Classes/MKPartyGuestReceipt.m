//
//  MKPartyGuestReceipt.m
//  MaryKay
//
//  Created by Charles Fisher on 5/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MKPartyGuestReceipt.h"
#import "Mary_KayAppDelegate.h"

static sqlite3 *database = nil;
static sqlite3_stmt *deleteStmt = nil;
static sqlite3_stmt *updateStmt = nil;
static sqlite3_stmt *addStmt = nil;

@implementation MKPartyGuestReceipt
@synthesize mkclient, mkreceipt, bookedParty;

- (id) initWithPrimaryKey:(NSInteger)pk {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mkPartiesUpdated) name:MKPartiesUpdate object:nil];
	return [super initWithPrimaryKey:pk];
}
- (id) init:(MKClient*) mk {
	return [self init:mk receipt:nil];
}

- (id) init:(MKClient*)mk receipt:(MKReceipt*)receipt {
	if (self = [super init]) {
		self.mkclient = mk;
		self.mkreceipt = receipt;
		self.bookedParty = nil;
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mkPartiesUpdated) name:MKPartiesUpdate object:nil];
	}
	return self;
}

- (void) mkPartiesUpdated {
	Mary_KayAppDelegate *appDelegate = (Mary_KayAppDelegate *)[[UIApplication sharedApplication] delegate];
	if (![appDelegate.mkparties containsObject:bookedParty]) {
		[bookedParty release];
		self.bookedParty = nil;
		[self updateMKGuest];
	}
}

- (MKReceipt*) getMkreceipt {
	if (mkreceipt == nil) {
		mkreceipt = [[MKReceipt alloc] init];
		Mary_KayAppDelegate *appDelegate = (Mary_KayAppDelegate*)[[UIApplication sharedApplication] delegate];
		[appDelegate addMKReceipt:mkreceipt client:mkclient];
		[self updateMKGuest];
		//[mkclient addReceipt:mkreceipt];
	}
	return mkreceipt;
}

- (void) setBookedParty:(MKParty *)mk {
	bookedParty = mk;
	[self updateMKGuest];
}


- (void) addMKGuest:(MKParty*)mkparty {
	if (addStmt == nil) {
		const char *sql = "insert into mkguest (mkpartyid,mkclientid,mkreceiptid, mkpartybookedid) values (?,?,?,?)";
		if (sqlite3_prepare_v2(database, sql, -1, &addStmt, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error while creating add mkguest statement. '%s'", sqlite3_errmsg(database));
		}
	}
		
	sqlite3_bind_int(addStmt, 1, mkparty.objectid);
	sqlite3_bind_int(addStmt, 2, mkclient.objectid);
	sqlite3_bind_int(addStmt, 3, mkreceipt.objectid);
	sqlite3_bind_int(addStmt, 4, bookedParty.objectid);
		
	if(SQLITE_DONE != sqlite3_step(addStmt)) {
		NSAssert1(0, @"Error while inserting guest data. '%s'", sqlite3_errmsg(database));
	} else {
		objectid = sqlite3_last_insert_rowid(database);
	}
		
	// Reset the add statement.
	sqlite3_reset(addStmt);
}

- (void) updateMKGuest {
	if (updateStmt == nil) {
		const char *sql = "update mkguest set mkclientid = ?, mkreceiptid = ?, mkpartybookedid = ? where mkguestkey = ?";
		if (sqlite3_prepare_v2(database, sql, -1, &updateStmt, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error while creating update mkguest statement. '%s'", sqlite3_errmsg(database));
		}		
	}
	
	sqlite3_bind_int(updateStmt, 1, mkclient.objectid);
	sqlite3_bind_int(updateStmt, 2, mkreceipt.objectid);
	sqlite3_bind_int(updateStmt, 3, bookedParty.objectid);
	sqlite3_bind_int(updateStmt, 4, objectid);
	
	if (SQLITE_DONE != sqlite3_step(updateStmt)) {
		NSAssert1(0, @"Error while updating mkreceipt. '%s'", sqlite3_errmsg(database));
	}
	
	sqlite3_reset(updateStmt);
}



- (void) deleteSQLObject {
	[self deleteMKGuest];
}

- (void) deleteMKGuest {
	// Delete Contents of MKReceipt (e.g. Purchases)
	//for (int i = 0; i < [purchases count]; i++) {
	//	[(MKPurchase*)[purchases objectAtIndex:i] deleteMKPurchase];
	//}
	
	if(deleteStmt == nil) {
		const char *sql = "delete from mkguest where mkguestkey = ?";
		if(sqlite3_prepare_v2(database, sql, -1, &deleteStmt, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error while creating delete guest statement. '%s'", sqlite3_errmsg(database));
		}
	}
	
	sqlite3_bind_int(deleteStmt, 1, objectid);
	
	if (SQLITE_DONE != sqlite3_step(deleteStmt)) {
		NSAssert1(0, @"Error while deleting mkguest. '%s'", sqlite3_errmsg(database));
	}
	
	sqlite3_reset(deleteStmt);
}



+ (void) getInitialData:(NSString *)dbPath {
	Mary_KayAppDelegate *appDelegate = (Mary_KayAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
		const char *sql = "select * from mkguest";
		sqlite3_stmt *selectstmt;
		if (sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
			while (sqlite3_step(selectstmt) == SQLITE_ROW) {
				NSInteger guestid = sqlite3_column_int(selectstmt, 0);
				// Read th edata from the result row
				NSInteger mkpartyId = sqlite3_column_int(selectstmt, 1);
				NSInteger mkclientId = sqlite3_column_int(selectstmt, 2);
				NSInteger mkreceiptId = sqlite3_column_int(selectstmt, 3);
				NSInteger mkpartybookedId = sqlite3_column_int(selectstmt, 4);

				MKPartyGuestReceipt *mkguest = [[MKPartyGuestReceipt alloc] initWithPrimaryKey:guestid];

				NSLog(@"Guest: %i %i",mkpartyId, mkclientId);
				MKClient *mkclient_ = [appDelegate getMKClient:mkclientId];
				
				MKParty  *mkparty_ = [appDelegate getMKParty:mkpartyId];
				MKReceipt *mkreceipt_ = [appDelegate getMKReceipt:mkreceiptId];
				MKParty *mkbookedparty = [appDelegate getMKParty:mkpartybookedId];
				
				[mkguest setMkclient:mkclient_];
				[mkguest setMkreceipt:mkreceipt_];
				[mkguest setBookedParty:mkbookedparty];
				
				//[mkparty addGuest:mkguest];
				if (mkparty_.mkhostid == guestid) {
					[mkparty_ setHost:mkguest];
				} else {
					[mkparty_ addMKGuest:mkguest];
				}
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
