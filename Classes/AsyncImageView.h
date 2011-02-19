//
//  AsyncImageView.h
//  MaryKay
//
//  Created by Charles Fisher on 5/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AsyncImageView : UIView {
	NSURLConnection *connection;
	NSMutableData *data;

}

@end
