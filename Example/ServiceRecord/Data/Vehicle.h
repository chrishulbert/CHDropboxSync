//
//  Vehicle.h
//  ServiceRecord
//
//  Created by Chris Hulbert on 23/11/11.
//  Copyright (c) 2011 Splinter Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Vehicle : NSObject

@property(nonatomic,retain) NSString* makeModel;
@property(nonatomic,retain) NSString* plate;
@property(nonatomic,assign) int serviceIntervalMonths;

+ (Vehicle*)fromDict:(NSDictionary*)dict;
- (NSDictionary*)asDict;
- (NSString*)serviceIntervalDesc;

@end
