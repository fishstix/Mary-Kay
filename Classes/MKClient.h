//
//  MKClient.h
//  Mary Kay
//
//  Created by Charles Fisher on 9/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKProfile.h"
#import "MKReceipt.h"
#import "SQLObject.h"
#import <sqlite3.h>

@interface MKClient : SQLObject {
	NSString *firstName;
	NSString *lastName;
	
	NSString *creditCard;
	
	NSString *address;
	NSString *email;
	NSString *phone;
	
	MKProfile *profile;
	
	NSMutableArray *receipts;
}

@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *creditCard;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *phone;

@property (nonatomic, retain) MKProfile *profile;

@property (nonatomic, retain) NSMutableArray *receipts;


- (id)initWithName:(NSString*)first last:(NSString *)last address:(NSString *)addy 
			 email:(NSString*)email phone:(NSString*)phone;

- (void) addReceipt:(MKReceipt *) receipt;

- (void) addMKClient;
- (void) updateMKClient;
- (void) deleteMKClient;
+ (void) getInitialData:(NSString*)dbPath;
+ (void) finalizeStatements;

//- (id) initWithPrimaryKey:(NSInteger)pk;

@end
