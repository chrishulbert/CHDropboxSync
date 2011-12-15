//
//  DataUtils.m
//  ServiceRecord
//
//  Created by Chris Hulbert on 23/11/11.
//  Copyright (c) 2011 Splinter Software. All rights reserved.
//

#import "DataUtils.h"
#import "ConciseKit.h"
#import "Vehicle.h"

@implementation DataUtils

+ (NSString*)cache {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}
+ (NSString*)docs {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}
BOOL isClean(unichar c);
BOOL isClean(unichar c) {
    if (c>='0' && c<='9') return YES;
    if (c>='A' && c<='Z') return YES;
    if (c>='a' && c<='z') return YES;
    return NO;
}

+ (NSString*)cleanForPath:(NSString*)s {
    NSMutableString* clean = [NSMutableString string];
    for (int i=0;i<s.length;i++) {
        unichar c = [s characterAtIndex:i];
        if (isClean(c)) {
            [clean appendString:[NSString stringWithCharacters:&c length:1]];
        } else {
            [clean appendString:@"_"];
        }
    }
    return clean;
}

+ (NSString*)cleanPhotoForPath:(NSString*)s {
    NSMutableString* clean = [NSMutableString string];
    for (int i=0;i<s.length;i++) {
        unichar c = [s characterAtIndex:i];
        if (isClean(c)) {
            [clean appendString:[NSString stringWithCharacters:&c length:1]];
        } else {
            if (c==' ') {
                [clean appendString:@" "];
            } else if (c=='\\' || c=='/' || c=='-') {
                [clean appendString:@"-"];
            } else if (c==':') {
                [clean appendString:@"."];
            } else {
                [clean appendString:@"_"];
            }
        }
    }
    return clean;
}

+ (NSString*)isoDt:(NSDate*)date {
    if (!date) return nil;
    int comps = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents* dc = [[NSCalendar currentCalendar] components:comps fromDate:date];
    return $str(@"%04d%02d%02d", dc.year, dc.month, dc.day);
}

+ (NSDate*)parseDt:(NSString*)str {
    int yyyymmdd = [str intValue];
    if (!yyyymmdd) return nil;
    NSDateComponents *dc = [[[NSDateComponents alloc] init] autorelease];
    dc.year = yyyymmdd/10000;
    dc.month = yyyymmdd/100%100;
    dc.day = yyyymmdd%100;
    return [[NSCalendar currentCalendar] dateFromComponents:dc];
}

+ (NSString*)dueInDescForVehicle:(Vehicle*)vehicle mostRecentServiceDate:(NSDate*)mostRecentServiceDate {
    if (vehicle.serviceIntervalMonths && mostRecentServiceDate) {
        // Add X months to the most recent date
        int comps = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
        NSDateComponents* dc = [[NSCalendar currentCalendar] components:comps fromDate:mostRecentServiceDate];
        dc.month += vehicle.serviceIntervalMonths;
        NSDate* dueDate = [[NSCalendar currentCalendar] dateFromComponents:dc];
        // Find the difference
        NSDateComponents* diff = [[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:[NSDate date] toDate:dueDate options:0];
        if (diff.day>30) {
            NSDateFormatter* df = $new(NSDateFormatter);
            df.dateStyle = NSDateFormatterMediumStyle;
            return [df stringFromDate:dueDate];
        } else if (diff.day>0) {
            return $str(@"Due in %d days", diff.day);
        } else if (diff.day==0) {
            return @"Due today";
        } else {
            return $str(@"Overdue by %d days", -diff.day);
        }
    }
    return @"n/a";
}

+ (NSString*)overviewDueInDescForVehicle:(Vehicle*)vehicle mostRecentServiceDate:(NSDate*)mostRecentServiceDate {
    if (vehicle.serviceIntervalMonths && mostRecentServiceDate) {
        // Add X months to the most recent date
        int comps = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
        NSDateComponents* dc = [[NSCalendar currentCalendar] components:comps fromDate:mostRecentServiceDate];
        dc.month += vehicle.serviceIntervalMonths;
        NSDate* dueDate = [[NSCalendar currentCalendar] dateFromComponents:dc];
        // Find the difference
        NSDateComponents* diff = [[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:[NSDate date] toDate:dueDate options:0];
        if (diff.day>30) {
            return nil;
        } else if (diff.day>0) {
            return $str(@"Due in %d days", diff.day);
        } else if (diff.day==0) {
            return @"Due today";
        } else {
            return $str(@"Overdue by %d days", -diff.day);
        }
    }
    return nil;
}

+ (NSString*)niceDt:(NSDate*)date {
    NSDateFormatter* df = $new(NSDateFormatter);
    df.dateStyle = NSDateFormatterMediumStyle;
    return [df stringFromDate:date];
}

@end
