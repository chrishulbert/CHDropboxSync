//
//  VehicleOverview.h
//  ServiceRecord
//
//  Created by Chris Hulbert on 22/11/11.
//  Copyright (c) 2011 Splinter Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Vehicle;

@interface VehicleOverview : UITableViewController

@property(nonatomic,retain) Vehicle* vehicle;
@property(retain) NSDate* mostRecentServiceDate;

+ (VehicleOverview*)vehicleOverviewFor:(Vehicle*)v;

@end
