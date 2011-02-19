//
//  TimeViewController.h
//  MaryKay
//
//  Created by Charles Fisher on 5/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TimeViewDelegate <NSObject>
@required
- (void)takeNewTime:(NSDate *)newTime;
- (UINavigationController *)navController;          // Return the navigation controller
@end

@interface TimeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    UIDatePicker            *datePicker;
    UITableView             *dateTableView;
    NSDate                  *date;
    
    id <TimeViewDelegate>   delegate;   // weak ref
}
@property (nonatomic, retain) UIDatePicker *datePicker;
@property (nonatomic, retain) UITableView *dateTableView;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, assign)  id <TimeViewDelegate> delegate;
-(IBAction)dateChanged;
@end
