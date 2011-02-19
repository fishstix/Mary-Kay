//
//  MKParty.h
//  Mary Kay
//
//  Created by Charles Fisher on 9/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQLObject.h"

@class MKClient;
@class MKPartyGuestReceipt;
@class MKReceipt;

@interface MKParty : SQLObject {
	//MKClient *host;
	int mkhostid;
	MKPartyGuestReceipt *host;
	NSMutableArray *mkguests;
	
	NSDate *date;
	NSString *location;
	
	int partyType;
}

@property (nonatomic, assign) int mkhostid;
@property (nonatomic, retain) MKPartyGuestReceipt *host;
@property (nonatomic, retain) NSMutableArray *mkguests;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, assign) int partyType;

- (id) init:(MKClient*)host location:(NSString*)address;

//- (void) addGuest:(MKClient*)mk;
- (void) addMKGuest:(MKPartyGuestReceipt*)mk;
- (NSMutableArray*) getGuests;
- (NSMutableArray*) getMKGuests;
- (BOOL) containsGuest:(MKClient*)mkclient;
- (BOOL) containsReceipt:(MKReceipt*)mkreceipt;

- (NSString*) getFormattedDate;

- (void) addMKParty;
- (void) updateMKParty;
- (void) deleteMKParty;
+ (void) getInitialData:(NSString *)dbPath;
+ (void) finalizeStatements;

@end