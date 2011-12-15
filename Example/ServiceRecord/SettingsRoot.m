//
//  SettingsRoot.m
//  ServiceRecord
//
//  Created by Chris Hulbert on 22/11/11.
//  Copyright (c) 2011 Splinter Software. All rights reserved.
//

#import "SettingsRoot.h"
#import "DropboxSDK.h"
#import "Exporter.h"
#import "CHDropboxSync.h"
#import "ConciseKit.h"

@implementation SettingsRoot

@synthesize syncer;

- (void)dealloc {
    self.syncer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Dropbox";
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(linked:) name:@"Linked" object:nil];
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    cell.textLabel.text=nil;
    cell.detailTextLabel.text = nil;
    cell.accessoryView = nil;
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            cell.textLabel.text = @"Account";
            if ([[DBSession sharedSession] isLinked]) {
                cell.detailTextLabel.text = @"Linked";
            } else {
                cell.detailTextLabel.text = @"Not linked";
            }        
        }
        if (indexPath.row==1) {
            cell.textLabel.text = @"Synchronize now";
        }
    }
    
    return cell;
}

#pragma mark - Table view delegate

// For the alert: Are you sure you wish to unlink?
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        [[DBSession sharedSession] unlinkAll];
        [self.tableView reloadData];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            if (![[DBSession sharedSession] isLinked]) {
                [[DBSession sharedSession] link];
            } else {
                [[[[UIAlertView alloc] initWithTitle:@"Log out" 
                                             message:@"Are you sure you wish to unlink your Dropbox account?" 
                                            delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Unlink", nil] autorelease] show];
            }
        }
        if (indexPath.row==1) {
            // Export any printable html if necessary before the sync
            [Exporter go];
            
            // Now do the sync
            self.syncer = $new(CHDropboxSync);
            self.syncer.delegate = self;
            [self.syncer doSync];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Syncer

// Sync has finished, so you can dealloc it now
- (void)syncComplete {
    self.syncer = nil;
}

#pragma mark - Linked notification

- (void)linked:(NSNotification*)n {
    [self.tableView reloadData];
}

@end
