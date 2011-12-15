//
//  NewVehicle.h
//  ServiceRecord
//
//  Created by Chris Hulbert on 22/11/11.
//  Copyright (c) 2011 Splinter Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewVehicle : UIViewController<UITextFieldDelegate>

@property(nonatomic,assign) IBOutlet UITextField* makeModel;
@property(nonatomic,assign) IBOutlet UITextField* numberPlate;
@property(assign) id delegate;

- (IBAction)tapCancel:(id)sender;
- (IBAction)tapSave:(id)sender;


@end
