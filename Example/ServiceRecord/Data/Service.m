//
//  Service.m
//  ServiceRecord
//
//  Created by Chris Hulbert on 23/11/11.
//  Copyright (c) 2011 Splinter Software. All rights reserved.
//

#import "Service.h"
#import "Data.h"
#import "ConciseKit.h"

@implementation Service

@synthesize summary;
@synthesize notes;
@synthesize odometerReading;
@synthesize date;

-(void)dealloc {
    self.summary = nil;
    self.notes = nil;
    self.odometerReading = 0;
    self.date = nil;
    [super dealloc];
}

+ (Service*)fromDict:(NSDictionary*)dict {
    if (!$safe([dict $for:@"summary"])) return nil;
    Service* s = [[[Service alloc] init] autorelease];
    s.summary = $safe([dict $for:@"summary"]);
    s.notes = $safe([dict $for:@"notes"]);
    s.odometerReading = [$safe([dict $for:@"odometerReading"]) intValue];
    s.date = [DataUtils parseDt:$safe([dict $for:@"date"])];
    return s;
}

- (NSDictionary*)asDict {
    return $dict(
                 nilToNull(self.summary), @"summary",
                 nilToNull(self.notes), @"notes",
                 $int(self.odometerReading), @"odometerReading",
                 nilToNull([DataUtils isoDt:self.date]), @"date");
}

- (NSString*)odometerString {
    if (self.odometerReading<1000) return $str(@"%d", self.odometerReading);
    return $str(@"%d,%03d", self.odometerReading/1000, self.odometerReading%1000);
}

- (NSString*)detailDescription {
    if (!self.date) return nil;
    
    NSDateFormatter* df = $new(NSDateFormatter);
    df.dateStyle = NSDateFormatterMediumStyle;
    if (self.odometerReading) {
        return $str(@"%@; %@", [df stringFromDate:self.date], self.odometerString);
    } else {
        return [df stringFromDate:self.date];
    }
}

@end
