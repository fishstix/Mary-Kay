//
//  MKClient.m
//  Mary Kay
//
//  Created by Charles Fisher on 9/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MKClient.h"
#import "Mary_KayAppDelegate.h"

static sqlite3 *database = nil;
static sqlite3_stmt *deleteStmt = nil;
static sqlite3_stmt *updateStmt = nil;
static sqlite3_stmt *addStmt = nil;

@implementation MKClient
//@synthesize objectid;
@synthesize firstName,lastName,creditCard,address,email,phone;
@synthesize profile;
@synthesize receipts;


- (id)initWithName:(NSString*)first last:(NSString*)last address:(NSString*)addy
		   email:(NSString*)em phone:(NSString*)p{
	if (self = [super init]) {
	
		   
		self.firstName	= first;
		self.lastName	= last;
		self.creditCard = @"1234 8765 9087 1256";
		self.address	= addy;
		self.email		= em;
		self.phone		= p;
	
		self.profile = [[MKProfile alloc] init];
		self.receipts = [[NSMutableArray alloc] initWithArray:nil];
	}
	return self;
}

- (void) addReceipt:(MKReceipt *) receipt {
	[receipts addObject:receipt];
	[[NSNotificationCenter defaultCenter] postNotificationName:MKReceiptsUpdate object:self];
}


- (void) addMKClient {
	if (addStmt == nil) {
		const char *sql = "insert into mkclient(first,last,address,email,phone) values (?,?,?,?,?)";
		if (sqlite3_prepare_v2(database, sql, -1, &addStmt, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error while creating mkclient add statement. '%s'", sqlite3_errmsg(database));
		}
	}
		
	sqlite3_bind_text(addStmt, 1, [firstName UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(addStmt, 2, [lastName UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(addStmt, 3, [address UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(addStmt, 4, [email UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(addStmt, 5, [phone UTF8String], -1, SQLITE_TRANSIENT);
	
	if(SQLITE_DONE != sqlite3_step(addStmt)) {
		NSAssert1(0, @"Error while inserting mkclient data. '%s'", sqlite3_errmsg(database));
	} else {
		objectid = sqlite3_last_insert_rowid(database);
	}
		
	// Reset the add statement.
	sqlite3_reset(addStmt);

	// Add Profile
	[self.profile addMKProfile:self];
}

- (void) updateMKClient {
	if (updateStmt == nil) {
		const char *sql = "update mkclient set first = ?, last = ?, address = ?, email = ?, phone = ? where mkclientkey = ?";
		if (sqlite3_prepare_v2(database, sql, -1, &updateStmt, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error while creating update mkclient statement. '%s'", sqlite3_errmsg(database));
		}		
	}
	
	sqlite3_bind_text(updateStmt, 1, [firstName UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(updateStmt, 2, [lastName UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(updateStmt, 3, [address UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(updateStmt, 4, [email UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(updateStmt, 5, [phone UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_int(updateStmt, 6, objectid);
	
	if (SQLITE_DONE != sqlite3_step(updateStmt)) {
		NSAssert1(0, @"Error while updating mkclient. '%s'", sqlite3_errmsg(database));
	}
	
	sqlite3_reset(updateStmt);
}

- (void) deleteSQLObject {
	[self deleteMKClient];
}

- (void) deleteMKClient {
	// Delete Contents of MKClient (e.g. Profile, Receipts)
	for (int i = 0; i < [receipts count]; i++) {
		[(MKReceipt*)[receipts objectAtIndex:i] deleteMKReceipt];
	}
	
	// Delete Profile
	[self.profile deleteMKProfile];
	
	// Delete MKClient
	if(deleteStmt == nil) {
		const char *sql = "delete from mkclient where mkclientkey = ?";
		if(sqlite3_prepare_v2(database, sql, -1, &deleteStmt, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error while creating delete statement. '%s'", sqlite3_errmsg(database));
		}
	}
	
	sqlite3_bind_int(deleteStmt, 1, objectid);
	
	if (SQLITE_DONE != sqlite3_step(deleteStmt)) {
		NSAssert1(0, @"Error while deleting mkclient. '%s'", sqlite3_errmsg(database));
	}
	
	sqlite3_reset(deleteStmt);
}

+ (void) getInitialData:(NSString *)dbPath {
	Mary_KayAppDelegate *appDelegate = (Mary_KayAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
		const char *sql = "select * from mkclient order by first";
		sqlite3_stmt *selectstmt;
		if (sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
			while (sqlite3_step(selectstmt) == SQLITE_ROW) {
				NSInteger clientid = sqlite3_column_int(selectstmt, 0);
				NSString *aFirstName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 1)];
				NSString *aLastName =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 2)];
				NSString *aAddress =   [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 3)];
				NSString *aEmail =     [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 4)];
				NSString *aPhone =     [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 5)];
				
				MKClient *mkclient = [[MKClient alloc] initWithPrimaryKey:clientid];
				mkclient.firstName = aFirstName;
				mkclient.lastName = aLastName;
				mkclient.address = aAddress;
				mkclient.email = aEmail;
				mkclient.phone = aPhone;
				mkclient.profile = nil;//[[MKProfile alloc] init];
				mkclient.receipts = [[NSMutableArray alloc] initWithArray:nil];
				//MKClient *mkclient = [[MKClient alloc] initWithID:clientid first:aFirstName last:aLastName address:aAddress email:aEmail phone:aPhone];
				
				[appDelegate.mkclients addObject:mkclient];
				[mkclient release];
				
				//NSLog(@"Contact: %i, %@, %@, %@, %@, %@", clientid, aFirstName, aLastName, aAddress, aEmail, aPhone);	
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
