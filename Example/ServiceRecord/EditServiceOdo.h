//
//  EditServiceOdo.h
//  ServiceRecord
//
//  Created by Chris Hulbert on 1/12/11.
//  Copyright (c) 2011 Splinter Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Service;
@class Vehicle;

@interface EditServiceOdo : UIViewController<UITextFieldDelegate>

@property(assign) IBOutlet UITextField* text;

@property(retain) Service* service;
@property(retain) Vehicle* vehicle;

+ (EditServiceOdo*)editorWithVehicle:(Vehicle*)v andService:(Service*)s;

@end
