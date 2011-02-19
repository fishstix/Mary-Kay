//
//  MKProfile.h
//  MaryKay
//
//  Created by Charles Fisher on 4/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQLObject.h"

@class MKClient;

@interface MKProfile : SQLObject {
	int skinType;
	int skinTone;
	int foundationCoverage;
	NSMutableArray *skinCareProgram;
	
	int mkclientid;
}

@property (nonatomic, assign) int skinType;
@property (nonatomic, assign) int skinTone;
@property (nonatomic, assign) int foundationCoverage;
@property (nonatomic, retain) NSMutableArray *skinCareProgram;

- (NSString*) getSkinType;
- (NSString*) getSkinTone;
- (NSString*) getFoundationCoverage;


- (void) addMKProfile:(MKClient*)mkclient;
- (void) updateMKProfile;
- (void) deleteMKProfile;
+ (void) getInitialData:(NSString*)dbPath;
+ (void) finalizeStatements;

@end
