//
//  NewService.h
//  ServiceRecord
//
//  Created by Chris Hulbert on 23/11/11.
//  Copyright (c) 2011 Splinter Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Vehicle;

@interface NewService : UIViewController<UITextFieldDelegate>

@property(retain) Vehicle* vehicle;
@property(retain) NSDateFormatter* df;
@property(assign) id parentController;

@property(assign) IBOutlet UITextField* summary;
@property(assign) IBOutlet UITextField* dateTxt;
@property(assign) IBOutlet UIDatePicker* datePick;

- (IBAction)tapSave:(id)sender;
- (IBAction)tapCancel:(id)sender;

@end
