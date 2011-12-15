//
//  EditServiceDate.h
//  ServiceRecord
//
//  Created by Chris Hulbert on 1/12/11.
//  Copyright (c) 2011 Splinter Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Service;
@class Vehicle;

@interface EditServiceDate : UIViewController

@property(assign) IBOutlet UITextField* text;

@property(retain) Service* service;
@property(retain) Vehicle* vehicle;
@property(retain) NSDateFormatter* df;
@property(assign) IBOutlet UIDatePicker* datePick;

+ (EditServiceDate*)editorWithVehicle:(Vehicle*)v andService:(Service*)s;

@end
