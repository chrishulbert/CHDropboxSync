//
//  EditServiceSummary.m
//  ServiceRecord
//
//  Created by Chris Hulbert on 1/12/11.
//  Copyright (c) 2011 Splinter Software. All rights reserved.
//

#import "EditServiceSummary.h"
#import "Data.h"
#import "ConciseKit.h"

@implementation EditServiceSummary

@synthesize text;
@synthesize vehicle;
@synthesize service;

- (void)dealloc {
    self.vehicle=nil;
    self.service=nil;
    [super dealloc];
}

+ (EditServiceSummary*)editorWithVehicle:(Vehicle*)v andService:(Service*)s {
    EditServiceSummary* c = [[[EditServiceSummary alloc] initWithNibName:@"EditServiceSummary" bundle:nil] autorelease];
    c.service = s;
    c.vehicle = v;
    c.title = @"Service Summary";
    return c;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(tapSave:)] autorelease];
    }
    return self;
}

#pragma mark - Save

- (IBAction)tapSave:(id)sender {
    if (!self.text.text.length) {
        [[[[UIAlertView alloc] initWithTitle:@"Can't save yet" message:@"You need to enter a service summary" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease] show];
        return;
    }

    self.service.summary = self.text.text;
    [[DataVehicles i] updateService:self.service forVehicle:self.vehicle];
    [self.navigationController popViewControllerAnimated:YES];    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self tapSave:nil];
    return YES;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.text.text = self.service.summary;
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
