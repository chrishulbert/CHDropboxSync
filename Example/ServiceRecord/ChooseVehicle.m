//
//  ChooseVehicle.m
//  ServiceRecord
//
//  Created by Chris Hulbert on 22/11/11.
//  Copyright (c) 2011 Splinter Software. All rights reserved.
//

#import "ChooseVehicle.h"
#import "ConciseKit.h"
#import "VehicleOverview.h"
#import "NewVehicle.h"
#import "Data.h"

@implementation ChooseVehicle

@synthesize vehicles;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Service History";
        UIBarButtonItem* bbi = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNew)] autorelease];
        self.navigationItem.rightBarButtonItem = bbi;
    }
    return self;
}

-(void)dealloc {
    self.vehicles=nil;
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil] autorelease];
}

- (void)viewWillAppear:(BOOL)animated {
    self.vehicles = [[DataVehicles i] list];
    [self.tableView reloadData];
    
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.vehicles.count)
        return 1;
    else
        return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return self.vehicles.count;
    }
    if (section==1) {
        return 1;
    }
    return 0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section==0) {
        return @"Your vehicles";
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = $str(@"CellSection%d", indexPath.section);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Vehicles
    cell.textLabel.text = nil;
    cell.detailTextLabel.text = nil;
    
    if (indexPath.section==0) {
        Vehicle* v = [self.vehicles $at:indexPath.row];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = v.makeModel;
        cell.detailTextLabel.text = v.plate;
        
        // make it show, if the service is due in a month: @"AB-12-XY; Service due in 123 days/overdue";
        NSArray* arr = [[DataVehicles i] servicesForVehicle:v];
        NSDate* mostRecentServiceDate = arr.count ? [[arr objectAtIndex:0] date] : nil;
        NSString* dueText = [DataUtils overviewDueInDescForVehicle:v mostRecentServiceDate:mostRecentServiceDate];
        if (dueText.length) {
            cell.detailTextLabel.text = $str(@"%@; %@", cell.detailTextLabel.text, dueText);
        }
    }
    
    // Add new vehicle
    if (indexPath.section==1) {
        cell.detailTextLabel.text = @"Tap + at the top right to add vehicles";
    }
    
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return indexPath.section==0;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        // Delete it
        Vehicle* v = [self.vehicles $at:alertView.tag];
        [[DataVehicles i] deleteVehicle:v];
        
        // Reload the array
        self.vehicles = [[DataVehicles i] list];
        
        // Delete the row from the data source
        if (!self.vehicles.count) {
            [self.tableView reloadData];
        } else {
            [self.tableView deleteRowsAtIndexPaths:$arr([NSIndexPath indexPathForRow:alertView.tag inSection:0]) withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete && indexPath.section==0) {
        Vehicle* v = [self.vehicles $at:indexPath.row];
        NSString* m = $str(@"Are you REALLY sure you wish to delete all your service records for %@?", v.makeModel);
        UIAlertView* av = [[[UIAlertView alloc] initWithTitle:nil message:m delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil] autorelease];
        av.tag = indexPath.row;
        [av show];
    }   
}

#pragma mark - Adding a new vehicle

- (void)addNew {
    NewVehicle* newVehicle = [[[NewVehicle alloc] initWithNibName:@"NewVehicle" bundle:nil] autorelease];
    newVehicle.delegate = self;
    [self presentModalViewController:newVehicle animated:YES];
}

// Called by the newvehicle view
- (void)newVehicleAdded:(Vehicle*)v {
    self.vehicles = [[DataVehicles i] list];
    [self.tableView reloadData];
    
    VehicleOverview* vo = [VehicleOverview vehicleOverviewFor:v];
    [self.navigationController pushViewController:vo animated:NO];    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section==0) {
        Vehicle* v = [self.vehicles $at:indexPath.row];
        VehicleOverview* vo = [VehicleOverview vehicleOverviewFor:v];
        [self.navigationController pushViewController:vo animated:YES];
    }
    if (indexPath.section==1) {
        [self addNew];
    }
}

@end
