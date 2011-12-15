//
//  ServiceOverview.m
//  ServiceRecord
//
//  Created by Chris Hulbert on 24/11/11.
//  Copyright (c) 2011 Splinter Software. All rights reserved.
//

#import "ServiceOverview.h"
#import "Data.h"
#import "ConciseKit.h"
#import "MyImgCell.h"
#import "EditServiceNotes.h"
#import "EditServiceOdo.h"
#import "EditServiceDate.h"
#import "EditServiceSummary.h"
#import "EGOPhotoGlobal.h"
#import "MyPhoto.h"
#import "MyPhotoSource.h"

@implementation ServiceOverview

@synthesize service;
@synthesize vehicle;
@synthesize photoPaths;

-(void)dealloc {
    self.service=nil;
    self.vehicle=nil;
    self.photoPaths=nil;
    [super dealloc];
}

- (void)getData {
    self.photoPaths = [[DataVehicles i] photosForService:service andVehicle:vehicle];
}

+ (ServiceOverview*)serviceOverviewWithService:(Service*)service andVehicle:(Vehicle*)vehicle {
    ServiceOverview* so = [[[ServiceOverview alloc] initWithNibName:@"ServiceOverview" bundle:nil] autorelease];
    so.title = @"Service";
    so.service = service;
    so.vehicle = vehicle;
    [so getData];
    
    so.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:so action:@selector(takePhoto)] autorelease];
    
    return so;
}

#pragma mark - Take photos

#warning test with iphone, ipad1, ipad2
- (void)takePhoto {
    BOOL hasCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    if (!hasCamera) {
        [[[[UIAlertView alloc] initWithTitle:nil message:@"Your device does not have a camera" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil] autorelease] show];
        return;
    }

    UIImagePickerController* ipc = [[[UIImagePickerController alloc] init] autorelease];
    ipc.allowsEditing = NO;
    ipc.delegate = self;
    ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    
//    Present the user interface by calling the presentViewController:animated:completion: method of the currently active view controller, passing your configured image picker controller as the new view controller.
//    On iPad, present the user interface using a popover. Doing so is valid only if the sourceType property of the image picker controller is set to UIImagePickerControllerSourceTypeCamera. To use a popover controller, use the methods described in “Presenting and Dismissing the Popover” in UIPopoverController Class Reference.
//        

    [self presentModalViewController:ipc animated:YES];
#warning todo on ipad present as a popover? Test it at least
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // Save it 
    UIImage* newImage = [info $for:UIImagePickerControllerOriginalImage];
    [[DataVehicles i] savePhoto:newImage forService:self.service andVehicle:self.vehicle];
    
    // Refresh the thumbs list
    [self getData];
    [self.tableView reloadData];
    
    // Since we're using the normal image controls, you must dismiss after a photo
    [self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getData];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section==1) return @"Notes";
    if (section==2 && self.photoPaths.count) return @"Photos and receipts";
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) return 3;
    if (section==1) return 1;
    if (section==2) return self.photoPaths.count;
    return 0;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==1) {
        // Notes
        cell.textLabel.font = [UIFont systemFontOfSize:17];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section==0) {
//        return 34;
//    }
    if (indexPath.section==1) {
        // Notes
        if (self.service.notes.length) {
            int wid = tableView.frame.size.width-40;
//            UIFont* normalCellFont = [UIFont boldSystemFontOfSize:17];
            UIFont* cellFont = [UIFont systemFontOfSize:17];
            CGSize realHt = [self.service.notes sizeWithFont:cellFont constrainedToSize:CGSizeMake(wid,999)  lineBreakMode:UILineBreakModeWordWrap];
            return MAX(realHt.height+10, tableView.rowHeight);
        }
    }
    if (indexPath.section==2) {
        return 54;
    }
    return tableView.rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = $str(@"CellSection%d", indexPath.section);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        if (indexPath.section==2) {
            cell = [[[MyImgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        } else if (indexPath.section==1) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        } else {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        }
    }
    
    // Configure the cell...
    cell.textLabel.text = nil;
    cell.detailTextLabel.text = nil;
    cell.imageView.image = nil;
    
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            cell.textLabel.text = @"Summary";
            cell.detailTextLabel.text = service.summary;
        }
        if (indexPath.row==1) {
            cell.textLabel.text = @"Date";
            cell.detailTextLabel.text = [DataUtils niceDt:service.date];
        }
        if (indexPath.row==2) {
            cell.textLabel.text = @"Odometer";
            if (service.odometerReading>0) {
                cell.detailTextLabel.text = service.odometerString;
            } else {
                cell.detailTextLabel.text = @"n/a";
            }
        }
    }
    if (indexPath.section==1) {
        cell.textLabel.text = self.service.notes;
        cell.textLabel.numberOfLines=0;
        if (!self.service.notes.length) {
            cell.detailTextLabel.text = @"Tap here to add some notes";
        }
    }
    if (indexPath.section==2) {
        NSString* photoPath = [self.photoPaths $at:indexPath.row];
        NSString* photoFile = [photoPath lastPathComponent];
        NSString* photoName = [photoFile stringByDeletingPathExtension];
        NSString* photoTitl = photoName.length>9 ? [photoName substringFromIndex:9] : photoName;
        cell.textLabel.text = photoTitl;
        cell.imageView.image = [UIImage imageWithContentsOfFile:photoPath];
    }
    
    return cell;
}

// Allow them to delete photos
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section==2;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (indexPath.section==2) {
            // Delete the photo
            NSString* photoPath = [self.photoPaths $at:indexPath.row];
            [[NSFileManager defaultManager] removeItemAtPath:photoPath error:nil];
            // Delete it from the view
            [self getData];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }   
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id c=nil;
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            c = [EditServiceSummary editorWithVehicle:self.vehicle andService:self.service];
        }
        if (indexPath.row==1) {
            c = [EditServiceDate editorWithVehicle:self.vehicle andService:self.service];
        }
        if (indexPath.row==2) {
            c = [EditServiceOdo editorWithVehicle:self.vehicle andService:self.service];
        }
    }
    if (indexPath.section==1) { // Notes
        c = [EditServiceNotes editorWithVehicle:self.vehicle andService:self.service];
    }
    if (indexPath.section==2) { // Photos
        NSMutableArray* photos = [NSMutableArray array];
        for (int i=0;i<self.photoPaths.count;i++) {
            NSString* photoPath = [self.photoPaths $at:i];
            MyPhoto* photo = [[[MyPhoto alloc] initWithImageURL:[NSURL fileURLWithPath:photoPath]] autorelease];
            [photos addObject:photo];
        }
        MyPhotoSource *source = [[[MyPhotoSource alloc] initWithPhotos:photos] autorelease];
        c = [[[EGOPhotoViewController alloc] initWithPhotoSource:source andIndex:indexPath.row] autorelease];
    }

    if (c) {
        [self.navigationController pushViewController:c animated:YES];
    }
}

@end
