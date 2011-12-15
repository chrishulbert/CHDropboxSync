//
//  EditPlate.h
//  ServiceRecord
//
//  Created by Chris Hulbert on 24/11/11.
//  Copyright (c) 2011 Splinter Software. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Vehicle;

@interface EditPlate : UIViewController<UITextFieldDelegate>

@property(retain) Vehicle* vehicle;
@property(assign) IBOutlet UITextField* text;

@end
