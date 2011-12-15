//
//  DataUtils.h
//  ServiceRecord
//
//  Created by Chris Hulbert on 23/11/11.
//  Copyright (c) 2011 Splinter Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Vehicle;

@interface DataUtils : NSObject

+ (NSString*)cleanForPath:(NSString*)s;
+ (NSString*)cleanPhotoForPath:(NSString*)s;
+ (NSString*)isoDt:(NSDate*)date;
+ (NSDate*)parseDt:(NSString*)str;
+ (NSString*)dueInDescForVehicle:(Vehicle*)vehicle mostRecentServiceDate:(NSDate*)mostRecentServiceDate;
+ (NSString*)overviewDueInDescForVehicle:(Vehicle*)vehicle mostRecentServiceDate:(NSDate*)mostRecentServiceDate;
+ (NSString*)niceDt:(NSDate*)date;

@end
