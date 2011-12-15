//
//  NewVehicle.m
//  ServiceRecord
//
//  Created by Chris Hulbert on 22/11/11.
//  Copyright (c) 2011 Splinter Software. All rights reserved.
//

#import "NewVehicle.h"
#import "Data.h"

@implementation NewVehicle

@synthesize makeModel;
@synthesize numberPlate;
@synthesize delegate;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.makeModel becomeFirstResponder];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)tapCancel:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
- (IBAction)tapSave:(id)sender {
    if (!self.makeModel.text.length) {
        [[[[UIAlertView alloc] initWithTitle:@"Can't save yet" message:@"You need to enter a make/model" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease] show];
        return;
    }
    if (!self.numberPlate.text.length) {
        [[[[UIAlertView alloc] initWithTitle:@"Can't save yet" message:@"You need to enter a number plate" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease] show];
        return;
    }
    
    Vehicle* v = [[[Vehicle alloc] init] autorelease];
    v.makeModel = self.makeModel.text;
    v.plate = self.numberPlate.text;
    [[DataVehicles i] add:v];
    [self dismissModalViewControllerAnimated:YES];

    // Let the parent know
    if ([self.delegate respondsToSelector:@selector(newVehicleAdded:)]) {
        [self.delegate performSelector:@selector(newVehicleAdded:) withObject:v];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField==self.makeModel) [self.numberPlate becomeFirstResponder];
    if (textField==self.numberPlate) [self.makeModel becomeFirstResponder];
    return NO;
}

@end
