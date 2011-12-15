//
//  DataVehicles.h
//  ServiceRecord
//
//  Created by Chris Hulbert on 23/11/11.
//  Copyright (c) 2011 Splinter Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Vehicle;
@class Service;

@interface DataVehicles : NSObject

+ (DataVehicles*)i;
- (NSArray*)list;
- (void)add:(Vehicle*)vehicle;
- (void)addService:(Service*)service toVehicle:(Vehicle*)vehicle;
- (void)updateService:(Service*)service forVehicle:(Vehicle*)vehicle;
- (void)changeService:(Service*)service forVehicle:(Vehicle*)vehicle toDate:(NSDate*)date;
- (BOOL)existsServiceOnDate:(NSDate*)newDate forVehicle:(Vehicle*)vehicle;
- (NSArray*)servicesForVehicle:(Vehicle*)v;
- (void)update:(Vehicle*)vehicle;
- (NSArray*)photosForService:(Service*)service andVehicle:(Vehicle*)vehicle;
- (void)deleteVehicle:(Vehicle*)v;
- (void)deleteService:(Service*)s forVehicle:(Vehicle*)v;
- (void)savePhoto:(UIImage*)image forService:(Service*)service andVehicle:(Vehicle*)vehicle;
- (void)writeExport:(NSString*)html forVehicle:(Vehicle*)vehicle;

@end
