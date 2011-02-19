//
//  Mary_KayAppDelegate.h
//  Mary Kay
//
//  Created by Charles Fisher on 8/22/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <sqlite3.h>
#import "MKProd.h"
#import "MKClient.h"
#import "MKReceipt.h"
#import "MKParty.h"
#import "MKPartyGuestReceipt.h"
#import "MKPurchase.h"

#define MKProductsUpdate @"MKProducts"
#define MKProductUpdate @"MKProduct"
#define MKClientsUpdate @"MKClients"
#define MKClientUpdate @"MKClient"
#define MKPartiesUpdate @"MKParties"
#define MKPartyUpdate @"MKParty"
#define MKReceiptsUpdate @"MKReceipts"
#define MKReceiptUpdate @"MKReceipt"
#define MKPurchaseUpdate @"MKPurchase"

@class MKProductNavigation;
@class MKProductListViewController;
@class MKClientNavigation;
@class MKPartyNavigation;

@interface Mary_KayAppDelegate : NSObject <UIApplicationDelegate, CLLocationManagerDelegate, UIAlertViewDelegate> {
    IBOutlet UIWindow *window;
	IBOutlet UITabBarController *tabBarController;
	
	IBOutlet MKProductNavigation *mkProductNavigation;
	//IBOutlet MKProductListViewController *mkProductListViewController;
	IBOutlet MKClientNavigation *mkClientNavigation;
	IBOutlet MKPartyNavigation *mkPartyNavigation;
	
	// Modal Add Views
	//MKAddClientViewController *MKAddClientView;
	
	// DB
	NSString *databaseName;
	NSString *databasePath;
	
	NSMutableArray *mkproducts;
	NSMutableArray *mkclients;
	NSMutableArray *mkparties;
	NSMutableArray *mkguests;
	NSMutableArray *mkreceipts;
	NSMutableArray *mkpurchases;
	
	// Settings
	float default_tax;
	
	// Profile
	NSMutableArray *skinTypes;
	NSMutableArray *skinTones;
	NSMutableArray *foundationCoveragePreferences;
	NSMutableArray *skinCareProgram;
	
	// party
	NSMutableArray *partyTypes;
	
	// GPS
	CLLocationCoordinate2D coordinate;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet MKProductNavigation *mkProductNavigation;
//@property (nonatomic, retain) IBOutlet MKProductListViewController *mkProductListViewController;
@property (nonatomic, retain) IBOutlet MKClientNavigation *mkClientNavigation;
@property (nonatomic, retain) IBOutlet MKPartyNavigation *mkPartyNavigation;
@property (nonatomic, retain) NSMutableArray *mkproducts;
@property (nonatomic, retain) NSMutableArray *mkclients;
@property (nonatomic, retain) NSMutableArray *mkparties;
@property (nonatomic, retain) NSMutableArray *mkguests;
@property (nonatomic, retain) NSMutableArray *mkreceipts;
@property (nonatomic, retain) NSMutableArray *mkpurchases;

// Settings
@property (nonatomic, assign) float default_tax;

// Profile
@property (nonatomic, retain) NSMutableArray *skinTypes;
@property (nonatomic, retain) NSMutableArray *skinTones;
@property (nonatomic, retain) NSMutableArray *foundationCoveragePreferences;
@property (nonatomic, retain) NSMutableArray *skinCareProgram;

// Party
@property (nonatomic, retain) NSMutableArray *partyTypes;

- (CLLocationCoordinate2D) getCoordinate;

// Settings
- (id) updateTax:(float)new_tax;

// Get Entities
- (id) getMKClient:(int)objectid;
- (id) getMKReceipt:(int)objectid;
- (id) getMKPurchase:(int)objectid;
- (id) getMKParty:(int)objectid;
- (id) getMKProduct:(NSString*)productId;
//- (id) getMKPartyGuest:(int)objectid;

// Add Entities
- (void) addMKProduct:(MKProd*)mk parent:(NSString*)parent;
- (void) addMKClient:(MKClient*)mk;
- (void) addMKReceipt:(MKClient*)mk;
- (void) addMKReceipt:(MKReceipt*)mk client:(MKClient *)mkclient;
- (void) addMKPurchase:(MKPurchase*)mk receipt:(MKReceipt*)mkreceipt;
- (void) addMKParty:(MKParty*)mk;
- (void) addMKPartyGuest:(MKClient*)mk party:(MKParty*)mkparty;

// Edit Entities
- (void) editMKClient:(MKClient*)mk newClient:(MKClient*)new_mk;
- (void) editMKParty:(MKParty*)mk newParty:(MKParty*)new_mk;
- (void) editReceipt:(MKReceipt*)mk newTax:(float)new_tax;
- (void) editReceipt:(MKReceipt*)mk newDiscount:(float)new_discount;
- (void) editPurchase:(MKPurchase*)mk newDiscount:(float)new_discount;

// Delete Entities
- (void) deleteMKClient:(MKClient*)mk;
- (void) deleteMKParty:(MKParty*)mk;
- (void) deleteMKPartyGuest:(MKPartyGuestReceipt*)mk mkparty:(MKParty*)mkparty;
- (void) deleteMKReceipt:(MKReceipt*)receipt mkclient:(MKClient*)mk;
- (void) deleteMKPurchase:(MKPurchase*)purchase receipt:(MKReceipt*)receipt;

@end

