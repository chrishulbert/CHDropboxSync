//
//  EditPlate.m
//  ServiceRecord
//
//  Created by Chris Hulbert on 24/11/11.
//  Copyright (c) 2011 Splinter Software. All rights reserved.
//

#import "EditPlate.h"
#import "Data.h"

@implementation EditPlate

@synthesize vehicle;
@synthesize text;

- (void)dealloc {
    [super dealloc];
    self.vehicle = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Number Plate";
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.text.text = self.vehicle.plate;
    [self.text becomeFirstResponder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)saveAndClose {
    self.vehicle.plate = self.text.text;
    [[DataVehicles i] update:self.vehicle];
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField==self.text) {
        [self saveAndClose];
    }
    return NO;
}

@end
