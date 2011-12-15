//
//  Exporter.m
//  ServiceRecord
//
//  Created by Chris Hulbert on 7/12/11.
//  Copyright (c) 2011 Splinter Software. All rights reserved.
//

#import "Exporter.h"
#import "Data.h"
#import "ConciseKit.h"

@implementation Exporter

+ (void)goForService:(Service*)s forVehicle:(Vehicle*)v html:(NSMutableString*)html first:(BOOL)first {
    if (!first) {
        [html appendString:@"<hr />\n"];
    }
    
    [html appendString:$str(@"<h3>%@</h3>\n", s.summary)];
    
    NSDateFormatter* df = $new(NSDateFormatter);
    df.dateStyle = NSDateFormatterLongStyle;
    [html appendString:$str(@"<p><strong>Date:</strong> %@</p>\n", [df stringFromDate:s.date])];
    [html appendString:$str(@"<p><strong>Odometer:</strong> %@</p>\n", s.odometerReading ? s.odometerString : @"n/a")];

    NSString* notesHtml = [s.notes stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    notesHtml = [notesHtml stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
    notesHtml = [notesHtml stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;\n"];
    notesHtml = [notesHtml stringByReplacingOccurrencesOfString:@">" withString:@"&gt;\n"];
    notesHtml = [notesHtml stringByReplacingOccurrencesOfString:@"\n" withString:@"<br />\n"];
    if (s.notes) {
        [html appendString:$str(@"<p><strong>Notes:</strong><br />%@</p>\n", notesHtml)];
    } else {
        [html appendString:@"<p><strong>Notes:</strong> n/a</p>\n"];
    }

    [html appendString:$str(@"<p><strong>Photos:</strong><br />\n")];
    NSArray* photoPaths = [[DataVehicles i] photosForService:s andVehicle:v];
    for (NSString* p in photoPaths) {
        NSString* fn = [p lastPathComponent];
        [html appendString:$str(@"<img src='%@' style='width:auto;height:25em;' /><br />\n",fn)];
    }
    if (!photoPaths.count) {
        [html appendString:@"<em>No photos</em>\n"];
    }
    [html appendString:@"</p>\n"];
}

+ (void)goForVehicle:(Vehicle*)v {
    NSMutableString* html = [NSMutableString string];
    [html appendString:@"<!DOCTYPE html>\n"];
    [html appendString:@"<html>\n"];
    [html appendString:@"<head>\n"];
    [html appendString:@"<meta charset=\"utf-8\" />\n"];
    [html appendString:@"<title>Service History</title>\n"];
    [html appendString:@"<style>body {font-family:'helvetica neue',arial; width:50em; margin:auto;}</style>\n"];
    [html appendString:@"</head>\n"];
    [html appendString:@"<body>\n"];
    
    [html appendString:@"<h1>Service History</h1>\n"];
    
    [html appendString:$str(@"<h2>%@</h2>\n", v.makeModel)];
    
    [html appendString:$str(@"<p><strong>Make / Model:</strong> %@</p>\n", v.makeModel)];
    [html appendString:$str(@"<p><strong>Plate:</strong> %@</p>\n", v.plate)];
    [html appendString:$str(@"<p><strong>Service Interval:</strong> %@</p>\n", v.serviceIntervalDesc)];

    [html appendString:@"<h2>Services <small><em>(oldest first)</em></small></h2>\n"];

    NSArray* services = [[DataVehicles i] servicesForVehicle:v];
    NSArray* sorted = [services sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]]];
    BOOL first=YES;
    for (Service* s in sorted) {
        [self goForService:s forVehicle:v html:html first:first];
        first=NO;
    }
    if (!sorted.count) {
        [html appendString:@"<p><em>No services</em></p>"];
    }
    
    [html appendString:@"</body>\n</html>\n"];
    
    [[DataVehicles i] writeExport:html forVehicle:v];
}

// Export for all
+ (void)go {
    for (Vehicle* v in [[DataVehicles i] list]) {
        [self goForVehicle:v];
    }
}

@end
