//
//  MKParty.m
//  Mary Kay
//
//  Created by Charles Fisher on 9/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MKParty.h"
#import "MKPartyGuestReceipt.h"
#import "Mary_KayAppDelegate.h"

static sqlite3 *database = nil;
static sqlite3_stmt *deleteStmt = nil;
static sqlite3_stmt *updateStmt = nil;
static sqlite3_stmt *addStmt = nil;

@implementation MKParty
//@synthesize objectid;
@synthesize mkhostid;
@synthesize host;
@synthesize mkguests;
@synthesize date;
@synthesize location;
@synthesize partyType;

- (id)init:(MKClient*)partyHost location:(NSString*)address{
	if (self = [super init]) {
		self.date = [[NSDate alloc] init];
		self.host = [[MKPartyGuestReceipt alloc] init:partyHost];
		//self.host		= partyHost;
		self.location	= address;
		self.partyType = -1;
		
		self.mkguests = [[NSMutableArray alloc] init];
		//[self addGuest:self.host];
	}
	return self;
}


- (NSString*) getPartyType {
	Mary_KayAppDelegate *appDelegate = (Mary_KayAppDelegate *)[[UIApplication sharedApplication] delegate];
	return [self getNSStringFromList:self.partyType list:[appDelegate partyTypes] defaultString:@"Party Type"];
}

- (NSString*) getNSStringFromList:(int)index list:(NSMutableArray*)list defaultString:(NSString*)d {
	if (index != -1) {
		return (NSString*)[list objectAtIndex:index]; 
	} else {
		return d;
	}
}



//- (void) addGuest:(MKClient *)mk {
//	MKPartyGuestReceipt *newGuest = [[MKPartyGuestReceipt alloc] init:mk];
//	[self.mkguests addObject:newGuest];
//}

- (void) addMKGuest:(MKPartyGuestReceipt *)mk {
	// Check if it's the host
	if (mk.objectid == mkhostid) {
	//	NSLog(@"Add Host %@", mk.mkclient.firstName);
		[self setHost:mk];
	} else {
	//	NSLog(@"Add Guest");
		[self.mkguests addObject:mk];
	}
}

- (NSMutableArray*) getGuests {
	NSMutableArray *guests = [[NSMutableArray alloc] init];
	[guests addObject:host.mkclient];
	for(int i = 0; i < [self.mkguests count]; i++) {
		MKPartyGuestReceipt *guest = [self.mkguests objectAtIndex:i];
		if (guest.mkclient == host.mkclient) {
			continue;
		}
		[guests addObject:guest.mkclient];
	}
	
	return guests;
}

- (NSMutableArray*) getMKGuests {
	NSMutableArray *guests = [[NSMutableArray alloc] init];
	[guests addObject:host];
	//[guests addObjectsFromArray:self.mkguests];
	for(int i = 0; i < [self.mkguests count]; i++) {
		MKPartyGuestReceipt *guest = [self.mkguests objectAtIndex:i];
		if (guest.mkclient == host.mkclient) {
			continue;
		}
		[guests addObject:guest];
	}
	return guests;
}

- (BOOL) containsGuest:(MKClient *)mkclient {
	// Check Host
	if (host.mkclient == mkclient) {
		return YES;
	}
	// Check Guests
	for(int i = 0; i < [self.mkguests count]; i++) {
		MKPartyGuestReceipt *guest = [self.mkguests objectAtIndex:i];
		if (mkclient == guest.mkclient) {
			return YES;
		}
	}
	
	return NO;
}


- (BOOL) containsReceipt:(MKReceipt *)mkreceipt {
	for(int i = 0; i < [self.mkguests count]; i++) {
		MKPartyGuestReceipt *guest = [self.mkguests objectAtIndex:i];
		if (mkreceipt == guest.mkreceipt) {
			return YES;
		}
	}
	
	return NO;
}

NSDateFormatter *formatter;
	
- (NSString*) getFormattedDate {
	if (formatter == nil) {
		formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"MMMM dd, yyyy hh:mm a"];
	}
	
	return [formatter stringFromDate:self.date];
}


- (void) addMKParty {
	if (addStmt == nil) {
		const char *sql = "insert into mkparty(mkhostid,date,location,type) values (?,?,?,?)";
		if (sqlite3_prepare_v2(database, sql, -1, &addStmt, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
		}
	}
		
	sqlite3_bind_int(addStmt, 1, host.objectid);
	sqlite3_bind_double(addStmt, 2, [date timeIntervalSince1970]);
	sqlite3_bind_text(addStmt, 3, [location UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_int(addStmt, 4, partyType);
		
	if(SQLITE_DONE != sqlite3_step(addStmt)) {
		NSAssert1(0, @"Error while inserting party data. '%s'", sqlite3_errmsg(database));
	} else {
		objectid = sqlite3_last_insert_rowid(database);
	}
		
	// Reset the add statement.
	sqlite3_reset(addStmt);
	
	// Add Host
	[host addMKGuest:self];
	// Update Host ID in Party
	[self updateMKParty];
}

- (void) updateMKParty {
	// Add Host
	[host addMKGuest:self];
	
	if (updateStmt == nil) {
		const char *sql = "update mkparty set mkhostid = ?, date = ?, location = ?, type = ? where mkpartykey = ?";
		if (sqlite3_prepare_v2(database, sql, -1, &updateStmt, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error while creating update mkparty statement. '%s'", sqlite3_errmsg(database));
		}		
	}
	
	sqlite3_bind_int(updateStmt, 1, host.objectid);
	sqlite3_bind_double(updateStmt, 2, [date timeIntervalSince1970]);
	sqlite3_bind_text(updateStmt, 3, [location UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_int(updateStmt, 4, partyType);
	sqlite3_bind_int(updateStmt, 5, objectid);
	
	if (SQLITE_DONE != sqlite3_step(updateStmt)) {
		NSAssert1(0, @"Error while updating mkparty. '%s'", sqlite3_errmsg(database));
	}
	
	sqlite3_reset(updateStmt);
}


- (void) deleteSQLObject {
	[self deleteMKParty];
}

- (void) deleteMKParty {
	// Delete Contents of MKParty (e.g. Guests)
	[self.host deleteMKGuest];
	for (int i = 0; i < [self.mkguests count]; i++) {
		[(MKPartyGuestReceipt*)[self.mkguests objectAtIndex:i] deleteMKGuest];
	}
	
	// Delete MKParty
	if(deleteStmt == nil) {
		const char *sql = "delete from mkparty where mkpartykey = ?";
		if(sqlite3_prepare_v2(database, sql, -1, &deleteStmt, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error while creating delete statement. '%s'", sqlite3_errmsg(database));
		}
	}
	
	sqlite3_bind_int(deleteStmt, 1, objectid);
	
	if (SQLITE_DONE != sqlite3_step(deleteStmt)) {
		NSAssert1(0, @"Error while deleting mkparty. '%s'", sqlite3_errmsg(database));
	}
	
	sqlite3_reset(deleteStmt);
}

+ (void) getInitialData:(NSString *)dbPath {
	Mary_KayAppDelegate *appDelegate = (Mary_KayAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
		const char *sql = "select * from mkparty";
		sqlite3_stmt *selectstmt;
		if (sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
			while (sqlite3_step(selectstmt) == SQLITE_ROW) {
				NSInteger partyid = sqlite3_column_int(selectstmt, 0);
				// Read th edata from the result row
				NSInteger hostId = sqlite3_column_int(selectstmt, 1);
				//NSString* guestsString = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 1)];
				//NSArray* guestsValues = [guestsString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
				NSDate *date = [NSDate dateWithTimeIntervalSince1970:sqlite3_column_double(selectstmt, 2)];  
				NSString *aAddress =   [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 3)];
				int partyType = sqlite3_column_int(selectstmt, 4);
				
				//MKClient *host = [appDelegate getMKClient:hostId];
				MKParty *mkparty = [[MKParty alloc] initWithPrimaryKey:partyid];//:host location:aAddress];
				mkparty.mkhostid = hostId;
				//mkparty.host = [[MKPartyGuestReceipt alloc] init:host];
				mkparty.date = date;
				mkparty.location = aAddress;
				mkparty.partyType = partyType;
				mkparty.mkguests = [[NSMutableArray alloc] init];
				//[mkparty addGuest:host];
									
				//for (int i =0; i < [guestsValues count]; i++) {
				//	int guestID = [[guestsValues objectAtIndex:i] intValue];
				//	MKClient *clientguest = [self getMKClient:guestID];
				//	MKPartyGuestReceipt *guest = [[MKPartyGuestReceipt alloc] init:clientguest];
				//	[mkparty.mkguests addObject:guest];
				//	[guest release];
				//	[clientguest release];
				//}
				
				[appDelegate.mkparties addObject:mkparty];
				[mkparty release];
				//[host release];
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
