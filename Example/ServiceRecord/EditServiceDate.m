//
//  EditServiceDate.m
//  ServiceRecord
//
//  Created by Chris Hulbert on 1/12/11.
//  Copyright (c) 2011 Splinter Software. All rights reserved.
//

#import "EditServiceDate.h"
#import "Data.h"

@implementation EditServiceDate

@synthesize text;
@synthesize vehicle;
@synthesize service;
@synthesize df;
@synthesize datePick;

- (void)dealloc {
    self.vehicle=nil;
    self.service=nil;
    self.df=nil;
    [super dealloc];
}

+ (EditServiceDate*)editorWithVehicle:(Vehicle*)v andService:(Service*)s {
    EditServiceDate* c = [[[EditServiceDate alloc] initWithNibName:@"EditServiceDate" bundle:nil] autorelease];
    c.service = s;
    c.vehicle = v;
    c.title = @"Service Date";
    return c;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(tapSave:)] autorelease];
        
        self.df = [[[NSDateFormatter alloc] init] autorelease];
        self.df.dateStyle = NSDateFormatterMediumStyle;
    }
    return self;
}

#pragma mark - Save

- (IBAction)tapSave:(id)sender {
    NSDate* parsedDate = [self.df dateFromString:self.text.text];
    if (!parsedDate) {
        [[[[UIAlertView alloc] initWithTitle:@"Can't save yet" message:@"You need to enter a date of the service" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease] show];
        return;
    }
    
    if ([parsedDate isEqualToDate:self.service.date]) {
        // No change?
        return;
    }

    if ([[DataVehicles i] existsServiceOnDate:parsedDate forVehicle:self.vehicle]) {
        [[[[UIAlertView alloc] initWithTitle:@"Can't save yet" message:@"There already is a different service for the date you entered" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease] show];
        return;
    }
    
    [[DataVehicles i] changeService:self.service forVehicle:self.vehicle toDate:parsedDate];
    
    [self.navigationController popViewControllerAnimated:YES];    
}

- (IBAction)changeDate:(id)sender {
    self.text.text = [self.df stringFromDate:self.datePick.date];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.text.text = self.service.date ? [self.df stringFromDate:self.service.date] : nil;
    self.datePick.date = self.service.date;
    
    [self.datePick addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventValueChanged];

    self.text.inputView = self.datePick;
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

@end
