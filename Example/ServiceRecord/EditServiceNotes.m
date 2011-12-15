//
//  EditServiceNotes.m
//  ServiceRecord
//
//  Created by Chris Hulbert on 25/11/11.
//  Copyright (c) 2011 Splinter Software. All rights reserved.
//

#import "EditServiceNotes.h"
#import "Data.h"

@implementation EditServiceNotes

@synthesize text;
@synthesize service;
@synthesize vehicle;

- (void)dealloc {
    self.text = nil;
    self.service = nil;
    self.vehicle = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(tapSave:)] autorelease];
    }
    return self;
}

+ (EditServiceNotes*)editorWithVehicle:(Vehicle*)v andService:(Service*)s {
    EditServiceNotes* c = [[[EditServiceNotes alloc] initWithNibName:@"EditServiceNotes" bundle:nil] autorelease];
    c.service = s;
    c.vehicle = v;
    c.title = @"Notes";
    return c;
}

#pragma mark - Save

- (IBAction)tapSave:(id)sender {
    self.service.notes = self.text.text;
    [[DataVehicles i] updateService:self.service forVehicle:self.vehicle];
    [self.navigationController popViewControllerAnimated:YES];    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.text.text = self.service.notes;
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
