//
//  MKProfile.m
//  MaryKay
//
//  Created by Charles Fisher on 4/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MKProfile.h"
#import "Mary_KayAppDelegate.h"

@implementation MKProfile
//@synthesize objectid;
@synthesize skinType;
@synthesize skinTone;
@synthesize foundationCoverage;
@synthesize skinCareProgram;

static sqlite3 *database = nil;
static sqlite3_stmt *deleteStmt = nil;
static sqlite3_stmt *updateStmt = nil;
static sqlite3_stmt *addStmt = nil;

-(id) init {
	if(self = [super init]) {
		skinType = -1;
		skinTone = -1;
		foundationCoverage = -1;
		
		skinCareProgram = [[NSMutableArray alloc] initWithObjects:nil];
		Mary_KayAppDelegate *appDelegate = (Mary_KayAppDelegate *)[[UIApplication sharedApplication] delegate];
		for (int i = 0; i < [appDelegate.skinCareProgram count]; i++) {
			[skinCareProgram addObject:[NSNumber numberWithBool:NO]];
		}
	}
	
	return self;
}

- (void) setSkinTone:(int)tone {
	skinTone = tone;
	[self updateMKProfile];
	[[NSNotificationCenter defaultCenter] postNotificationName:MKClientUpdate object:self];
}

- (void) setSkinType:(int)type {
	skinType = type;
	[self updateMKProfile];
	[[NSNotificationCenter defaultCenter] postNotificationName:MKClientUpdate object:self];
}

- (void) setFoundationCoverage:(int)coverage {
	foundationCoverage = coverage;
	[self updateMKProfile];
	[[NSNotificationCenter defaultCenter] postNotificationName:MKClientUpdate object:self];
}


- (NSString*) getSkinType {
	Mary_KayAppDelegate *appDelegate = (Mary_KayAppDelegate *)[[UIApplication sharedApplication] delegate];
	return [self getNSStringFromList:self.skinType list:[appDelegate skinTypes] defaultString:@"Type"];
}
- (NSString*) getSkinTone {
	Mary_KayAppDelegate *appDelegate = (Mary_KayAppDelegate *)[[UIApplication sharedApplication] delegate];
	return [self getNSStringFromList:self.skinTone list:[appDelegate skinTones] defaultString:@"Tone"];
}
- (NSString*) getFoundationCoverage {
	Mary_KayAppDelegate *appDelegate = (Mary_KayAppDelegate *)[[UIApplication sharedApplication] delegate];
	return [self getNSStringFromList:self.foundationCoverage list:[appDelegate foundationCoveragePreferences] defaultString:@"Foundation"];
}

- (NSString*) getNSStringFromList:(int)index list:(NSMutableArray*)list defaultString:(NSString*)d {
	if (index != -1) {
		return (NSString*)[list objectAtIndex:index]; 
	} else {
		return d;
	}
}

// SQL
- (void) addMKProfile:(MKClient*)mk {
	if (addStmt == nil) {
		const char *sql = "insert into mkprofile (mkclientid, type,tone,coverage,program) values (?,?,?,?,?)";
		if (sqlite3_prepare_v2(database, sql, -1, &addStmt, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error while creating mkprofile add statement. '%s'", sqlite3_errmsg(database));
		}
	}
	
	sqlite3_bind_int(addStmt, 1, mk.objectid);
	sqlite3_bind_int(addStmt, 2, skinType);
	sqlite3_bind_int(addStmt, 3, skinTone);
	sqlite3_bind_int(addStmt, 4, foundationCoverage);
	sqlite3_bind_text(addStmt, 5, [@"" UTF8String], -1, SQLITE_TRANSIENT);
	
	if(SQLITE_DONE != sqlite3_step(addStmt)) {
		NSAssert1(0, @"Error while inserting mkprofile data. '%s'", sqlite3_errmsg(database));
	} else {
		objectid = sqlite3_last_insert_rowid(database);
	}
	
	// Reset the add statement.
	sqlite3_reset(addStmt);
}

- (void) updateMKProfile {
	if (updateStmt == nil) {
		const char *sql = "update mkprofile set type = ?, tone = ?, coverage = ?, program = ? where mkprofilekey = ?";
		if (sqlite3_prepare_v2(database, sql, -1, &updateStmt, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error while creating update mkprofile statement. '%s'", sqlite3_errmsg(database));
		}		
	}
	
	NSString *program = @"";
	for (int i = 0; i < [skinCareProgram count]; i++) {
		if ([skinCareProgram objectAtIndex:i] == [NSNumber numberWithBool:YES]) {
			program = [NSString stringWithFormat:@"%i,%@",i,program];
		}
	}
	
	sqlite3_bind_int(updateStmt, 1, skinType);
	sqlite3_bind_int(updateStmt, 2, skinTone);
	sqlite3_bind_int(updateStmt, 3, foundationCoverage);
	sqlite3_bind_text(updateStmt, 4, [program UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_int(updateStmt, 5, objectid);
	
	if (SQLITE_DONE != sqlite3_step(updateStmt)) {
		NSAssert1(0, @"Error while updating mkprofile. '%s'", sqlite3_errmsg(database));
	}
	NSLog(@"Updated Profile Program: %@",program);
	
	sqlite3_reset(updateStmt);
}

- (void) deleteSQLObject {
	[self deleteMKProfile];
}

- (void) deleteMKProfile {
	// Delete MKProfile
	if(deleteStmt == nil) {
		const char *sql = "delete from mkprofile where mkprofilekey = ?";
		if(sqlite3_prepare_v2(database, sql, -1, &deleteStmt, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error while creating delete mkprofile statement. '%s'", sqlite3_errmsg(database));
		}
	}
	
	sqlite3_bind_int(deleteStmt, 1, objectid);
	
	if (SQLITE_DONE != sqlite3_step(deleteStmt)) {
		NSAssert1(0, @"Error while deleting mkprofile. '%s'", sqlite3_errmsg(database));
	}
	
	sqlite3_reset(deleteStmt);
}

+ (void) getInitialData:(NSString *)dbPath {
	Mary_KayAppDelegate *appDelegate = (Mary_KayAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
		const char *sql = "select * from mkprofile";
		sqlite3_stmt *selectstmt;
		if (sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
			while (sqlite3_step(selectstmt) == SQLITE_ROW) {
				NSInteger profileid = sqlite3_column_int(selectstmt, 0);
				NSInteger clientId = sqlite3_column_int(selectstmt, 1);
				NSInteger type = sqlite3_column_int(selectstmt, 2);
				NSInteger tone = sqlite3_column_int(selectstmt, 3);
				NSInteger coverage = sqlite3_column_int(selectstmt, 4);
				NSString *program =   [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 5)];
				NSLog(@"Program: %@", program);
				NSArray *program_array = [program componentsSeparatedByString:@","];
				Mary_KayAppDelegate *appDelegate = (Mary_KayAppDelegate *)[[UIApplication sharedApplication] delegate];
				NSMutableArray *skinCareProgram = [[NSMutableArray alloc] init];
				for (int i = 0; i < [appDelegate.skinCareProgram count]; i++) {
					for (int j = 0; j < [program_array count]; j++) {
						if ([[program_array objectAtIndex:j] isEqualToString:[NSString stringWithFormat:@"%i",i]]) {
							[skinCareProgram addObject:[NSNumber numberWithBool:YES]];
							continue;
						}
					}
					if ([skinCareProgram count] <= i) {
						[skinCareProgram addObject:[NSNumber numberWithBool:NO]];
					}
				}
				
				MKProfile *mkprofile = [[MKProfile alloc] initWithPrimaryKey:profileid];
				mkprofile.skinCareProgram = skinCareProgram;
				mkprofile.skinType = type;
				mkprofile.skinTone = tone;
				mkprofile.foundationCoverage = coverage;
				
				MKClient *mk = [appDelegate getMKClient:clientId];
				mk.profile = mkprofile;
				
				//[mkprofile release];
			}
		} else {
			NSLog(@"Error while selecting mkprofiles.");
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
