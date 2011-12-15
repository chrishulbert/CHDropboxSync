//
//  ServiceOverview.h
//  ServiceRecord
//
//  Created by Chris Hulbert on 24/11/11.
//  Copyright (c) 2011 Splinter Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Service;
@class Vehicle;

@interface ServiceOverview : UITableViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

+ (ServiceOverview*)serviceOverviewWithService:(Service*)service andVehicle:(Vehicle*)vehicle;
@property(retain) Service* service;
@property(retain) Vehicle* vehicle;
@property(retain) NSArray* photoPaths;

@end
