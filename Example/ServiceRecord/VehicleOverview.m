//
//  VehicleOverview.m
//  ServiceRecord
//
//  Created by Chris Hulbert on 22/11/11.
//  Copyright (c) 2011 Splinter Software. All rights reserved.
//

//     UIImagePickerController

#import "VehicleOverview.h"
#import "Data.h"
#import "ServiceHistory.h"
#import "EditServiceDuration.h"
#import "ConciseKit.h"
#import "EditPlate.h"

@implementation VehicleOverview

@synthesize vehicle;
@synthesize mostRecentServiceDate;

-(void)dealloc {
    self.vehicle=nil;
    self.mostRecentServiceDate = nil;
    [super dealloc];
}

- (id)initWithVehicle:(Vehicle*)v {
    self = [self initWithNibName:@"VehicleOverview" bundle:nil];
    if (self) {
        self.vehicle = v;
        self.title = self.vehicle.makeModel;
    }
    return self;
}

+ (VehicleOverview*)vehicleOverviewFor:(Vehicle*)v {
    return [[[VehicleOverview alloc] initWithVehicle:v] autorelease];
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Get the most recent service
    NSArray* arr = [[DataVehicles i] servicesForVehicle:self.vehicle];
    self.mostRecentServiceDate = arr.count ? [[arr objectAtIndex:0] date] : nil;
    
    [self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section==0) {
        return @"Vehicle details";
    }
    if (section==1) {
        return @"Services";
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 3;
    }
    if (section==1) {
        return 3;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    cell.textLabel.text = nil;
    cell.detailTextLabel.text = nil;
    cell.accessoryType = 0;
    
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            cell.textLabel.text = @"Make/Model";
            cell.detailTextLabel.text = self.vehicle.makeModel;
        }
        if (indexPath.row==1) {
            cell.textLabel.text = @"Number plate";
            cell.detailTextLabel.text = self.vehicle.plate;
        }
        if (indexPath.row==2) {
            cell.textLabel.text = @"Service interval";
            cell.detailTextLabel.text = self.vehicle.serviceIntervalDesc;
        }
    }
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            cell.textLabel.text = @"Next service"; // Or overdue
            cell.detailTextLabel.text = [DataUtils dueInDescForVehicle:self.vehicle mostRecentServiceDate:self.mostRecentServiceDate];
        }
        if (indexPath.row==1) {
            cell.textLabel.text = @"Last service";
            NSDateFormatter* df = $new(NSDateFormatter);
            df.dateStyle = NSDateFormatterMediumStyle;
            cell.detailTextLabel.text = self.mostRecentServiceDate ? 
                [df stringFromDate:self.mostRecentServiceDate] : @"n/a";
        }
        if (indexPath.row==2) {
            cell.textLabel.text = @"View / add services";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            [[[[UIAlertView alloc] initWithTitle:@"Error" message:@"Sorry, you can't change the make/model. If you must, you can close this app and manually rename the folder in Dropbox." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease] show];
        }
        if (indexPath.row==1) {
            EditPlate* c = [[[EditPlate alloc] initWithNibName:@"EditPlate" bundle:nil] autorelease];
            c.vehicle = self.vehicle;
            [self.navigationController pushViewController:c animated:YES];
        }
        if (indexPath.row==2) {
            EditServiceDuration* esd = [[[EditServiceDuration alloc] initWithNibName:@"EditServiceDuration" bundle:nil] autorelease];
            esd.vehicle = self.vehicle;
            [self.navigationController pushViewController:esd animated:YES];
        }
    }
        
    if (indexPath.section==1) {
        if (indexPath.row<=1) {
            [[[[UIAlertView alloc] initWithTitle:nil message:@"This value is automatically calculated by looking at your service history, you can't change it." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease] show];
        }
        if (indexPath.row==2) {
            ServiceHistory* sh = [ServiceHistory serviceHistoryWithVehicle:self.vehicle];
            [self.navigationController pushViewController:sh animated:YES];
        }
    }
}

@end
