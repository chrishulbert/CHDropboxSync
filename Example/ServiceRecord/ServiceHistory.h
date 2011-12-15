//
//  ServiceHistory.h
//  ServiceRecord
//
//  Created by Chris Hulbert on 23/11/11.
//  Copyright (c) 2011 Splinter Software. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Vehicle;

@interface ServiceHistory : UITableViewController

@property(retain) Vehicle* vehicle;
@property(retain) NSArray* services;

+ (ServiceHistory*)serviceHistoryWithVehicle:(Vehicle*)v;

@end
