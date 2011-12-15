//
//  EditServiceNotes.h
//  ServiceRecord
//
//  Created by Chris Hulbert on 25/11/11.
//  Copyright (c) 2011 Splinter Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Vehicle;
@class Service;

@interface EditServiceNotes : UIViewController<UITextViewDelegate>

@property(assign) IBOutlet UITextView* text;
@property(retain) Vehicle* vehicle;
@property(retain) Service* service;

+ (EditServiceNotes*)editorWithVehicle:(Vehicle*)v andService:(Service*)s;

@end
