//
//  MKPartyGuestReceipt.h
//  MaryKay
//
//  Created by Charles Fisher on 5/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKClient.h"
#import "MKReceipt.h"
#import "MKParty.h"

@interface MKPartyGuestReceipt : SQLObject {
	MKClient *mkclient;
	MKReceipt *mkreceipt;
	MKParty *bookedParty;
}

@property (nonatomic, retain) MKClient *mkclient;
@property (nonatomic, retain) MKReceipt *mkreceipt;
@property (nonatomic, assign) MKParty *bookedParty;

- (id) init:(MKClient*) mk;
- (id) init:(MKClient*) mk receipt:(MKReceipt*)mkreceipt;

- (void) addMKGuest:(SQLObject*)mkparty;
- (void) updateMKGuest;
- (void) deleteMKGuest;
+ (void) getInitialData:(NSString *)dbPath;
+ (void) finalizeStatements;

@end
