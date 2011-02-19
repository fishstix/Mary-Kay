//
//  MKProduct.h
//  Mary Kay
//
//  Created by Charles Fisher on 8/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKProd.h"

@interface MKProduct : MKProd {
	NSString *product_id;
	NSString *name;
	NSString *description;
	//NSInteger price;
	float price;
	
	
	// IMAGE
	NSURLConnection *connection;
	NSMutableData *data;
	UIImage *image;	
}

@property (nonatomic, copy) NSString *product_id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, assign) float price;
//@property (nonatomic, assign) NSInteger price;
@property (nonatomic, retain) UIImage *image;

- (id)initWithName:(NSString*)n description:(NSString *)desc image:(NSString*)image;
- (id)initWithName:(NSString*)n id:(NSString*)id cost:(float)c;

- (void) removeImage;

@end
