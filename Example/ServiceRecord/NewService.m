//
//  NewService.m
//  ServiceRecord
//
//  Created by Chris Hulbert on 23/11/11.
//  Copyright (c) 2011 Splinter Software. All rights reserved.
//

#import "NewService.h"
#import "Data.h"
#import <QuartzCore/QuartzCore.h>

@implementation NewService

@synthesize vehicle;
@synthesize df;
@synthesize summary;
@synthesize dateTxt,datePick;
@synthesize parentController;

- (void)dealloc {
    self.vehicle = nil;
    self.df=nil;
    [super dealloc];
}

- (IBAction)tapSave:(id)sender {
    if (!self.summary.text.length) {
        [[[[UIAlertView alloc] initWithTitle:@"Can't save yet" message:@"You need to enter a summary of the service, eg 'Grease and oil change' or 'Major service'" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease] show];
        return;
    }
    NSDate* parsedDate = [self.df dateFromString:self.dateTxt.text];
    if (!parsedDate) {
        [[[[UIAlertView alloc] initWithTitle:@"Can't save yet" message:@"You need to enter a date of the service" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease] show];
        return;
    }
    BOOL alreadyExists = [[DataVehicles i] existsServiceOnDate:parsedDate forVehicle:self.vehicle];
    if (alreadyExists) {
        [[[[UIAlertView alloc] initWithTitle:@"Can't save yet" message:@"You already have a service record for that day for this vehicle" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease] show];
        return;
    }
    
    Service* s = [[[Service alloc] init] autorelease];
    s.summary = self.summary.text;
    s.date = parsedDate;
    
    [[DataVehicles i] addService:s toVehicle:self.vehicle];
    
    [self dismissModalViewControllerAnimated:YES];
        
    if ([parentController respondsToSelector:@selector(serviceCreatedByNewService:)]) {
        [parentController performSelector:@selector(serviceCreatedByNewService:) withObject:s];
    }
}

- (IBAction)tapCancel:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    [self.summary becomeFirstResponder];

    self.df = [[[NSDateFormatter alloc] init] autorelease];
    self.df.dateStyle = NSDateFormatterMediumStyle;
    
    self.datePick = [[[UIDatePicker alloc] init] autorelease];
    self.datePick.datePickerMode = UIDatePickerModeDate;
    [self.datePick addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventValueChanged];
    self.dateTxt.inputView = self.datePick;
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


#pragma mark - Text field delegate stuff

- (IBAction)changeDate:(id)sender {
    self.dateTxt.text = [self.df stringFromDate:self.datePick.date];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField==self.summary) {
        [self.dateTxt becomeFirstResponder];
    }
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField==self.dateTxt) {
        [self changeDate:nil];
    }
}

@end
