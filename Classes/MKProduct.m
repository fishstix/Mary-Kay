//
//  MKProduct.m
//  Mary Kay
//
//  Created by Charles Fisher on 8/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MKProduct.h"
#import "Mary_KayAppDelegate.h"

@implementation MKProduct
@synthesize name,description,price,image,product_id;

- (id)initWithName: (NSString*)n description:(NSString*)desc image:(NSString*)imageName{
	self.name        = n;
	self.description = desc;
	self.price       = 9.9;
	self.image       = [UIImage imageNamed:imageName];
	return self;
}

- (id)initWithName:(NSString*)n id:(NSString*)i cost:(float)c {
	if (self = [super init]) {
		self.name = n;
		self.description = @"";
		self.price = c;
		self.product_id = i;
	}
	return self;
}

- (NSString*) getType {return @"Product";}
- (NSString*) getCellIdentifier {return @"MKProductCell";}
- (NSString*) getTableCellViewName {return @"MKProductCellView";}


- (void) loadImageFromURL {
	NSString *padded_id = [NSString stringWithFormat:@"%06d",[self.product_id intValue]];
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://content2.marykayintouch.com/public/PWS_US/Images/%@.jpg",padded_id]];
	
	if (connection != nil) { [connection release]; }
	//if (data != nil) { [data release]; }

	NSURLRequest *request = [NSURLRequest requestWithURL:url
											 cachePolicy:NSURLRequestUseProtocolCachePolicy
										 timeoutInterval:60.0];
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void) connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)incrementalData {
	if (data == nil) {
		data = [[NSMutableData alloc] initWithCapacity:2048];
	}
	[data appendData:incrementalData];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)theConnection {
	[connection release];
	connection = nil;
	
	image = [[UIImage alloc] initWithData:data];
	[data release];
	data = nil;
	[[NSNotificationCenter defaultCenter] postNotificationName:MKProductUpdate object:self];
}


- (UIImage*) getImage {
	if (image == nil) {
		[self loadImageFromURL];
	}
	return image;
}

- (void) removeImage {
	[image release];
	image = nil;
	
	[connection cancel];
	[connection release];
	connection = nil;
	//[data release];
	//data = nil;
}

//- (UIImage*) image {
//	UIImageView *iv = [[self subviews] objectAtIndex:0];
//	return [iv image];
//}



@end
