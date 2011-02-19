//
//  CSVLoader.m
//  MaryKay
//
//  Created by Charles Fisher on 5/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CSVLoader.h"
#import "MKProduct.h"
#import "MKProd.h"
#import "MKProductGroup.h"
#import "Mary_KayAppDelegate.h"

@implementation CSVLoader

- (void) loadProducts {
	//
	// load the points from our local resource
	//
	NSString* filePath = [[NSBundle mainBundle] pathForResource:@"products" ofType:@"csv"];
	NSString* fileContents = [NSString stringWithContentsOfFile:filePath];
	NSArray* productStrings = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
	Mary_KayAppDelegate *appDelegate = (Mary_KayAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSMutableArray *products = [[NSMutableArray alloc] initWithCapacity:productStrings.count];
	
	for(int idx = 0; idx < productStrings.count; idx++)
	{
		// break the string down even further to latitude and longitude fields. 
		NSString* currentProductString = [productStrings objectAtIndex:idx];
		NSArray* productValues = [currentProductString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
		if ([productValues count] < 3) {
			continue;
		}
		NSString* product_id  = [productValues objectAtIndex:0];
		NSString* product_name = [productValues objectAtIndex:1];
		float product_cost = [[productValues objectAtIndex:2] floatValue];
		NSString* parent = [productValues objectAtIndex:3];
		
		MKProd *mk;
		if ([product_id isEqualToString:@"0"]) {
			mk = [[MKProductGroup alloc] init:product_name];
		} else {
			mk = [[MKProduct alloc] initWithName:product_name id:product_id cost:product_cost];
		}
			 
		[appDelegate addMKProduct:mk parent:parent];
		//[products addObject:mk];
	}
	
	// SORT
	//NSSortDescriptor *nameDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES] autorelease];
	//NSArray *descriptors = [NSArray arrayWithObject:nameDescriptor]; 
	//return [products sortedArrayUsingDescriptors:descriptors];
	
	//return products;
}

@end
