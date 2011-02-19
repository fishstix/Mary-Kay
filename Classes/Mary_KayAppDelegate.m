//
//  Mary_KayAppDelegate.m
//  Mary Kay
//
//  Created by Charles Fisher on 8/22/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "Mary_KayAppDelegate.h"
#import "MKProduct.h"
#import "MKProductGroup.h"
#import "MKClient.h"
#import "MKParty.h"
#import "MKReceipt.h"
#import "MKPurchase.h"
#import "SQLObject.h"
#import "MKProductNavigation.h"
//#import "MKProductListViewController.h"
//#import "MKProductTableViewController.h"
#import "MKClientNavigation.h"
#import "MKPartyNavigation.h"
#import "CSVLoader.h"

#define MKTaxKey @"DefaultTax"

@implementation Mary_KayAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize mkProductNavigation;
//@synthesize mkProductListViewController;
@synthesize mkClientNavigation;
@synthesize mkPartyNavigation;
@synthesize mkproducts;
@synthesize mkclients;
@synthesize mkparties;
@synthesize mkguests;
@synthesize mkreceipts;
@synthesize mkpurchases;
// Settings
@synthesize default_tax;

// Profile
@synthesize skinTypes;
@synthesize skinTones;
@synthesize foundationCoveragePreferences;
@synthesize skinCareProgram;

// Party
@synthesize partyTypes;

NSUserDefaults *prefs;

- (void)applicationDidFinishLaunching:(UIApplication *)application {    

	// Settings
	prefs = [NSUserDefaults standardUserDefaults];
	
	default_tax = [prefs floatForKey:MKTaxKey];
	//default_tax = 9.25;
	
	// Profile
	self.skinTypes = [[NSMutableArray alloc] initWithObjects:@"Dry", @"Normal", @"Combination", @"Oily", nil];
	self.skinTones = [[NSMutableArray alloc] initWithObjects:@"Ivory (fair)", @"Beige (medium)", @"Bronze (dark)", nil];
	self.foundationCoveragePreferences = [[NSMutableArray alloc] initWithObjects:@"Full",@"Medium",@"Sheer",nil];
	self.skinCareProgram = [[NSMutableArray alloc] initWithObjects:@"Cleanser", @"Mask", @"Freshener", @"Moisturizer", @"Foundation", @"Soap and Water", nil];
	
	// Party
	self.partyTypes = [[NSMutableArray alloc] initWithObjects:@"Skin Care", @"Party Type 2", @"Party Type 3", nil];
	
	// LOAD PRODUCTS
	//MKProduct *moisturizer     = [[MKProduct alloc] initWithName:
	//							  @"Moisturizer" description:@"Makes my face wet" image:@"moisturizer.jpg"];
	//MKProduct *eyeShadow       = [[MKProduct alloc] initWithName:
	//							  @"Eye Shadow" description:@"Smear it under your eye for added effect"
	//													   image:@"eyeshadow.jpeg"];
	//MKProduct *HighIntensity   = [[MKProduct alloc] initWithName:
	//							  @"High Intensity" description:@"Do It Up (the Mohawk)" 
	//													   image:@"highintensity.jpeg"];
	//
	//self.mkproducts = [[NSMutableArray alloc] initWithObjects:moisturizer,eyeShadow,HighIntensity,
	//																   moisturizer,eyeShadow,HighIntensity,
	//				   moisturizer,eyeShadow,HighIntensity,
	//				   moisturizer,eyeShadow,HighIntensity,
	//				   moisturizer,eyeShadow,HighIntensity,
	//				   moisturizer,eyeShadow,HighIntensity,
	//				   moisturizer,eyeShadow,HighIntensity,
	//				  											   nil];
	
	CSVLoader *loader = [[CSVLoader alloc] init];
	self.mkproducts = [[NSMutableArray alloc] init];
	[loader loadProducts];
	
	self.mkclients = [[NSMutableArray alloc] initWithObjects:nil];
	self.mkparties = [[NSMutableArray alloc] initWithObjects:nil];
	self.mkguests = [[NSMutableArray alloc] initWithObjects:nil];
	self.mkreceipts = [[NSMutableArray alloc] initWithObjects:nil];
	self.mkpurchases = [[NSMutableArray alloc] initWithObjects:nil];
	
	// DB
	databaseName = @"mk.sql";
	
	// Get the path to the DB...?	
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
	
	[self checkAndCreateDatabase];
	
	//sqlite3 *database = nil;
	//sqlite3_open([databasePath UTF8String], &database);
	//const char *sql = "CREATE TABLE mkprofile (mkprofilekey INTEGER PRIMARY KEY, mkclientid int, type int, tone int, coverage int, program TEXT)";
	//sqlite3_stmt *createProfileTable;
	//sqlite3_prepare_v2(database, sql, -1, &createProfileTable, NULL);
	//sqlite3_step(createProfileTable);
	
	[MKClient getInitialData:databasePath];
	[MKParty getInitialData:databasePath];
	[MKReceipt getInitialData:databasePath];
	[MKPurchase getInitialData:databasePath];
	[MKPartyGuestReceipt getInitialData:databasePath];
	[MKProfile getInitialData:databasePath];
	//[self readContentFromDatabase];
	
	[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
	self.mkProductNavigation.navigationBar.barStyle = UIBarStyleBlackOpaque;
	self.mkClientNavigation.navigationBar.barStyle = UIBarStyleBlackOpaque;
	self.mkPartyNavigation.navigationBar.barStyle = UIBarStyleBlackOpaque;
	
	[window addSubview:[tabBarController view]];
    [window makeKeyAndVisible];
	
	// GPS Location Manager
	CLLocationManager *locationManager;
	locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self;
	[locationManager startUpdatingLocation];
}

- (void) applicationWillTerminate:(UIApplication *)application {
	[MKClient finalizeStatements];
	[MKParty finalizeStatements];
	[MKReceipt finalizeStatements];
	[MKPurchase finalizeStatements];
	[MKPartyGuestReceipt finalizeStatements];
}

- (void) checkAndCreateDatabase {
	BOOL success;
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	success = [fileManager fileExistsAtPath:databasePath];
	
	if (success) {
		return;
	}
	
	NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
	
	
	NSLog(@"%@", databasePathFromApp);
	[fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
	[fileManager release];
}

- (void) readContentFromDatabase {
	sqlite3 *database;
	
	if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
		//[self readMKClientsFromDatabase:database];
		//[self readMKPartiesFromDatabase:database];
	}
	
	sqlite3_close(database);
}

- (void) readMKClientsFromDatabase:(sqlite3*)database {
	// Init List
	self.mkclients = [[NSMutableArray alloc] initWithObjects:nil];
	
	const char *sqlStatement = "select * from mkclient";
	sqlite3_stmt *compiledStatement;
	if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
		while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
			// Read th edata from the result row
			int clientid = sqlite3_column_int(compiledStatement, 0);
			NSString *aFirstName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
			NSString *aLastName =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
			NSString *aAddress =   [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
			NSString *aEmail =     [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
			NSString *aPhone =     [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
			
			MKClient *mkclient = [[MKClient alloc] initWithID:clientid first:aFirstName last:aLastName address:aAddress email:aEmail phone:aPhone];
			
			[self.mkclients addObject:mkclient];
			[mkclient release];
			
			NSLog(@"Contact: %i, %@, %@, %@, %@, %@", clientid, aFirstName, aLastName, aAddress, aEmail, aPhone);			
		}
	}
	sqlite3_finalize(compiledStatement);
}

- (void) readMKPartiesFromDatabase:(sqlite3*)database {
	// Init List
	self.mkparties = [[NSMutableArray alloc] initWithObjects:nil];
	
	const char *sqlStatement = "select * from mkparty";
	sqlite3_stmt *compiledStatement;
	if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
		while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
			// Read th edata from the result row
			int partyid = sqlite3_column_int(compiledStatement, 0);
			int hostId = sqlite3_column_int(compiledStatement, 1);
			NSString* guestsString = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
			NSArray* guestsValues = [guestsString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
			NSString *aAddress =   [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
			int partyType = sqlite3_column_int(compiledStatement, 5);
			
			MKClient *host = [self getMKClient:hostId];
			MKParty *mkparty = [[MKParty alloc] init:host location:aAddress];
			
			for (int i =0; i < [guestsValues count]; i++) {
				int guestID = [[guestsValues objectAtIndex:i] intValue];
				MKClient *clientguest = [self getMKClient:guestID];
				MKPartyGuestReceipt *guest = [[MKPartyGuestReceipt alloc] init:clientguest];
				[mkparty.mkguests addObject:guest];
				[guest release];
				[clientguest release];
			}
			
			[self.mkparties addObject:mkparty];
			[mkparty release];
			[host release];
		}
	}
	sqlite3_finalize(compiledStatement);
}

- (CLLocationCoordinate2D) getCoordinate {
	return coordinate;
}

// Settings
- (id) updateTax:(float)new_tax {
	[prefs setFloat:new_tax forKey:MKTaxKey];
	[prefs synchronize];
	[self setDefault_tax:new_tax];
}


// GET ENTITIES

- (id) getMKClient:(int)objectid {
	for (int i = 0; i < [self.mkclients count]; i++) {
		SQLObject *sql = (SQLObject*)[self.mkclients objectAtIndex:i];
		if (sql.objectid == objectid) {
			return sql;
		}
	}
	return nil;
}

- (id) getMKParty:(int)objectid {
	for (int i = 0; i < [self.mkparties count]; i++) {
		SQLObject *sql = (SQLObject*)[self.mkparties objectAtIndex:i];
		if (sql.objectid == objectid) {
			return sql;
		}
	}
	return nil;
}

- (id) getMKReceipt:(int)objectid {
	for (int i = 0; i < [self.mkreceipts count]; i++) {
		SQLObject *sql = (SQLObject*)[self.mkreceipts objectAtIndex:i];
		if (sql.objectid == objectid) {
			return sql;
		}
	}
	return nil;
}

- (id) getMKProduct:(NSString*)productId {
	return [self getMKProduct:self.mkproducts productId:productId];
}

- (id) getMKProduct:(NSMutableArray*)group productId:(NSString*)productId {
	for (int i = 0; i < [group count]; i++) {
		MKProd *mkprod = (MKProd*)[group objectAtIndex:i];
		if ([[mkprod getType] isEqualToString:@"Group"]) {
			MKProductGroup *mkgroup = (MKProductGroup*)mkprod;
			id obj = [self getMKProduct:mkgroup.MKProducts productId:productId];
			if (obj != nil) {
				return obj;
			}
		} else {
			MKProduct *mkproduct = (MKProduct*)mkprod;
			if ([mkproduct.product_id isEqualToString:productId]) {
				return mkprod;
			}
		}
	}
	return nil;
}

//  ADD ENTITIES

- (void) addMKProduct:(MKProd*)mk parent:(NSString*)parent {
	if ([parent isEqualToString:@"None"]) {
		[self.mkproducts addObject:mk];
	} else {
		[self addMKProduct:mk group:self.mkproducts parent:parent];
	}
}
- (void) addMKProduct:(MKProd*)mk group:(NSMutableArray*)group parent:(NSString*) parent {
	for (int i = 0; i < [group count]; i++) {
		MKProd *mkprod = (MKProd*)[group objectAtIndex:i];
		if ([[mkprod getType] isEqualToString:@"Group"]) {
			MKProductGroup *mkgroup = (MKProductGroup*)mkprod;
			if ([mkgroup.name isEqualToString:parent]) {
				[mkgroup addMK:mk];
			} else {
				[self addMKProduct:mk group:[mkgroup MKProducts] parent:parent];
			}
		}
	}
}

- (void) addMKClient:(MKClient*)mk {
	[mk addMKClient];
	[mkclients addObject:mk];
	[[NSNotificationCenter defaultCenter] postNotificationName:MKClientsUpdate object:self];
}

- (void) addMKReceipt:(MKClient *)mk {
	MKReceipt *newReceipt = [[MKReceipt alloc] init];
	[self addMKReceipt:newReceipt client:mk];
}

- (void) addMKReceipt:(MKReceipt*)mk client:(MKClient *)mkclient {
	[mk addMKReceipt:mkclient];
	[mkclient addReceipt:mk];	
	// Not needed - put notification inside MKClient addReceipt method
	//[[NSNotificationCenter defaultCenter] postNotificationName:MKReceiptsUpdate object:self];
}

- (void) addMKPurchase:(MKPurchase*)mk receipt:(MKReceipt*)mkreceipt {
	[mk addMKPurchase:mkreceipt];
	[mkreceipt addPurchase:mk];
	[[NSNotificationCenter defaultCenter] postNotificationName:MKReceiptUpdate object:self];
}

- (void) addMKParty:(MKParty*)mk {
	// Update DB
	[mk addMKParty];
	[mkparties addObject:mk];
	// Notify App
	[[NSNotificationCenter defaultCenter] postNotificationName:MKPartiesUpdate object:self];
}

- (void) addMKPartyGuest:(MKClient*)mk party:(MKParty*)party {
	MKPartyGuestReceipt *mkguest = [[MKPartyGuestReceipt alloc] init:mk];
	// Update DB
	[mkguest addMKGuest:party];
	
	[party addMKGuest:mkguest];
	//[party addGuest:mk];
	// Notify App
	[[NSNotificationCenter defaultCenter] postNotificationName:MKPartyUpdate object:self];
}

//  EDIT ENTITIES

- (void) editMKClient:(MKClient *)mk newClient:(MKClient *)new_mk {
	[mk setFirstName:new_mk.firstName];
	[mk setLastName:new_mk.lastName];
	[mk setAddress:new_mk.address];
	[mk setPhone:new_mk.phone];
	[mk setEmail:new_mk.email];
	
	[new_mk release];
	// Update DB
	[mk updateMKClient];
	// Notify App
	[[NSNotificationCenter defaultCenter] postNotificationName:MKClientUpdate object:self];
}

- (void) editMKParty:(MKParty *)mk newParty:(MKParty *)new_mk {
	[mk setDate:new_mk.date];
	[mk setLocation:new_mk.location];
	// Delete Previous Host Guest
	[mk.host deleteMKGuest];	
	[mk setHost:new_mk.host];
	[new_mk release];
	// Update DB
	[mk updateMKParty];
	// Notify App
	[[NSNotificationCenter defaultCenter] postNotificationName:MKPartyUpdate object:self];	
}

- (void) editReceipt:(MKReceipt*)mk newTax:(float)new_tax {
	[mk setTax:new_tax];
	// Update DB
	[mk updateMKReceipt];
	// Notify App
	[[NSNotificationCenter defaultCenter] postNotificationName:MKReceiptUpdate object:self];
}

- (void) editReceipt:(MKReceipt*)mk newDiscount:(float)new_discount {
	[mk setDiscount:new_discount];
	// Update DB
	[mk updateMKReceipt];
	// Notify App
	[[NSNotificationCenter defaultCenter] postNotificationName:MKReceiptUpdate object:self];
}

- (void) editPurchase:(MKPurchase*)mk newDiscount:(float)new_discount {
	[mk setDiscount:new_discount];
	// Update DB
	[mk updateMKPurchase];
	// Notify App
	[[NSNotificationCenter defaultCenter] postNotificationName:MKPurchaseUpdate object:self];
	[[NSNotificationCenter defaultCenter] postNotificationName:MKReceiptUpdate object:self];
}

//  DELETE ENTITIES

- (void) deleteMKClient:(MKClient *)mk {
	// Check Guest of Party
	BOOL delete = YES;
	for (int i = 0; i < [self.mkparties count]; i++) {
		MKParty *party = [self.mkparties objectAtIndex:i];
		if ([party containsGuest:mk]) {
		//if ([party.mkguests containsObject:mk]) {
			delete = NO;
			break;
		}
	}
	
	if (!delete) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Delete Client" message:@"For consistency, all clients attending at least 1 party cannot be deleted" delegate:self 
											  cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	} else {
	[self deleteObjectFromList:mk 
					  	     list:self.mkclients 
						  message:[NSString stringWithFormat:@"Delete %@?", mk.firstName] 
					notification:MKClientsUpdate];

	}
}

- (void) deleteMKParty:(MKParty *)mk {
	[self deleteObjectFromList:mk 
						  list:self.mkparties 
					   message:[NSString stringWithFormat:@"Delete This Party?"] 
				  notification:MKPartiesUpdate];
}

- (void) deleteMKPartyGuest:(MKPartyGuestReceipt *)mk mkparty:(MKParty *)mkparty {
	// Check Host
	if (mk.mkclient == mkparty.host.mkclient) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Delete Host" message:@"To delete party, please do so from the party list view" delegate:self 
											  cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	} else {
		[self deleteObjectFromList:mk 
							list:mkparty.mkguests 
							message:[NSString stringWithFormat:@"Delete %@ from Party?", mk.mkclient.firstName] 
					notification:MKPartyUpdate];
	}
}

- (void) deleteMKReceipt:(MKReceipt *)receipt mkclient:(MKClient *)mk {
	// Check Guest of Party
	BOOL delete = YES;
	for (int i = 0; i < [self.mkparties count]; i++) {
		MKParty *party = [self.mkparties objectAtIndex:i];
		if ([party containsReceipt:receipt]) {
			//if ([party.mkguests containsObject:mk]) {
			delete = NO;
			break;
		}
	}
	
	if (!delete) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Delete Receipt" message:@"For consistency, if a receipt is associated with a party, it cannot be deleted" delegate:self 
											  cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	} else {
		[self deleteObjectFromList:receipt 
							  list:mk.receipts 
						   message:[NSString stringWithFormat:@"Delete This Receipt?"] 
					notification:MKReceiptsUpdate];
	}
}

- (void) deleteMKPurchase:(MKPurchase *)purchase receipt:(MKReceipt *)receipt {
	[self deleteObjectFromList:purchase 
						  list:receipt.purchases 
					   message:[NSString stringWithFormat:@"Delete This Purchase?"] 
				  notification:MKReceiptUpdate];
}

SQLObject *objToDelete;
NSMutableArray *listFromDelete;
NSString *deleteMsg;
NSString *notification;

- (void) deleteObjectFromList:(id*)obj list:(NSMutableArray*)list message:(NSString*)msg notification:(NSString*)notify {
	objToDelete = obj;
	listFromDelete = list;
	deleteMsg = msg;
	notification =  notify;
	
	// open a alert with an OK and cancel button
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:deleteMsg message:@"" delegate:self 
										  cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
	[alert show];
	[alert release];
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	// the user clicked one of the OK/Cancel buttons
	if (buttonIndex == 1)
	{
		//NSLog(@"ok");
		//Mary_KayAppDelegate *appDelegate = (Mary_KayAppDelegate *)[[UIApplication sharedApplication] delegate];
		//[appDelegate.mkclients removeObject:deleteMKClient];
		//[self.tableView reloadData];
		[objToDelete deleteSQLObject];
		[listFromDelete removeObject:objToDelete];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:notification object:self];
		objToDelete = nil;
		[objToDelete release];
	}
	else
	{
		//NSLog(@"cancel");
	}
}

- (void) deleteMKClient {
}

// CLLocationManagerDelegate
- (void) locationManager:(CLLocationManager*)manager
	 didUpdateToLocation:(CLLocation*) newLocation
			fromLocation:(CLLocation*) oldLocation{
	
	coordinate = newLocation.coordinate;
}

- (void) locationManager:(CLLocationManager*)manager
		didFailWithError:(NSError*)error {
	NSLog(@"Error: %@", [error description]);
}


- (void)dealloc {
	[tabBarController release];
	[mkProductNavigation release];
	[mkClientNavigation release];
	[mkPartyNavigation release];
	[window release];
    [super dealloc];
}


@end
