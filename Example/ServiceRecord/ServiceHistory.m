//
//  ServiceHistory.m
//  ServiceRecord
//
//  Created by Chris Hulbert on 23/11/11.
//  Copyright (c) 2011 Splinter Software. All rights reserved.
//

#import "ServiceHistory.h"
#import "Data.h"
#import "NewService.h"
#import "ConciseKit.h"
#import "ServiceOverview.h"

@implementation ServiceHistory

@synthesize vehicle;
@synthesize services;

- (void)dealloc {
    self.vehicle = nil;
    self.services = nil;
    [super dealloc];
}

- (id)initWithVehicle:(Vehicle*)v {
    self = [self initWithNibName:@"ServiceHistory" bundle:nil];
    if (self) {
        self.title = @"Services";
        self.vehicle = v;
        
        UIBarButtonItem* bbi = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNew)] autorelease];
        self.navigationItem.rightBarButtonItem = bbi;

    }
    return self;
}

+ (ServiceHistory*)serviceHistoryWithVehicle:(Vehicle*)v {
    return [[[ServiceHistory alloc] initWithVehicle:v] autorelease];
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.services = [[DataVehicles i] servicesForVehicle:self.vehicle]; 
    [self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return MAX(1, self.services.count);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    cell.textLabel.text = nil;
    cell.detailTextLabel.text = nil;
    
    if (self.services.count) {
        Service* s = [self.services objectAtIndex:indexPath.row];
        cell.textLabel.text = s.summary;
        cell.detailTextLabel.text = s.detailDescription;
        // list the # of photos eg @"13/Nov/11, 150,000kms, 3 photos";
        NSArray* photos = [[DataVehicles i] photosForService:s andVehicle:self.vehicle];
        if (photos.count==0) {
            cell.detailTextLabel.text = $str(@"%@; no photos", cell.detailTextLabel.text);
        } else if (photos.count==1) {
            cell.detailTextLabel.text = $str(@"%@; %d photo", cell.detailTextLabel.text, photos.count);
        } else {
            cell.detailTextLabel.text = $str(@"%@; %d photos", cell.detailTextLabel.text, photos.count);
        }
    } else {
        cell.detailTextLabel.text = @"Tap + at the top right to add a service";
    }
    
    return cell;
}

#pragma mark - Delete services

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return self.services.count;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete && self.services.count) {
        // Delete it
        Service* s = [self.services objectAtIndex:indexPath.row];
        [[DataVehicles i] deleteService:s forVehicle:self.vehicle];
        
        // Reload the array
        self.services = [[DataVehicles i] servicesForVehicle:self.vehicle]; 
        
        // Delete the row from the data source
        if (self.services.count) {
            [self.tableView deleteRowsAtIndexPaths:$arr(indexPath) withRowAnimation:UITableViewRowAnimationFade];
        } else {
            // When there's no services, we don't delete the row because it gets replaced by a 'tap +' help row
            [self.tableView reloadData];
        }
    }   
}

#pragma mark - Adding a new service

- (void)addNew {
    NewService* ns = [[[NewService alloc] initWithNibName:@"NewService" bundle:nil] autorelease];
    ns.parentController = self;
    ns.vehicle = self.vehicle;
    [self presentModalViewController:ns animated:YES];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.services.count) {
        Service* s = [self.services objectAtIndex:indexPath.row];
        ServiceOverview* so = [ServiceOverview serviceOverviewWithService:s andVehicle:self.vehicle];
        [self.navigationController pushViewController:so animated:YES];
    } else {
        [self addNew];
    }
}

#pragma mark - Callbacks for the new service controller

- (void)serviceCreatedByNewService:(Service*)s {
    // Reload the array
    self.services = [[DataVehicles i] servicesForVehicle:self.vehicle]; 
    [self.tableView reloadData];
    
    // Open it
    ServiceOverview* so = [ServiceOverview serviceOverviewWithService:s andVehicle:self.vehicle];
    [self.navigationController pushViewController:so animated:NO];
}

@end
