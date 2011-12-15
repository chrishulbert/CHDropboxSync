//
//  Service.h
//  ServiceRecord
//
//  Created by Chris Hulbert on 23/11/11.
//  Copyright (c) 2011 Splinter Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Service : NSObject

@property(nonatomic,retain) NSString* summary;
@property(nonatomic,retain) NSString* notes;
@property(nonatomic,assign) int odometerReading;
@property(nonatomic,retain) NSDate* date;

+ (Service*)fromDict:(NSDictionary*)dict;
- (NSDictionary*)asDict;
- (NSString*)detailDescription;
- (NSString*)odometerString;

@end
