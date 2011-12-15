//
//  Vehicle.m
//  ServiceRecord
//
//  Created by Chris Hulbert on 23/11/11.
//  Copyright (c) 2011 Splinter Software. All rights reserved.
//

#import "Vehicle.h"
#import "ConciseKit.h"

@implementation Vehicle

@synthesize makeModel, plate, serviceIntervalMonths;

- (void)dealloc {
    self.makeModel = nil;
    self.plate = nil;
    [super dealloc];
}

+ (Vehicle*)fromDict:(NSDictionary*)dict {
    if (!$safe([dict $for:@"makeModel"])) return nil;
    
    Vehicle* v = [[[Vehicle alloc] init] autorelease];
    v.makeModel = $safe([dict $for:@"makeModel"]);
    v.plate = $safe([dict $for:@"plate"]);
    v.serviceIntervalMonths = [$safe([dict $for:@"serviceIntervalMonths"]) intValue];
    return v;
}

- (NSDictionary*)asDict {
    return $dict(
        nilToNull(self.makeModel), @"makeModel",
        nilToNull(self.plate), @"plate",
        $int(self.serviceIntervalMonths), @"serviceIntervalMonths");
}

- (NSString*)serviceIntervalDesc {
    if (self.serviceIntervalMonths<=0) return @"By odometer";
    return $str(@"%d months", self.serviceIntervalMonths);
}

@end
