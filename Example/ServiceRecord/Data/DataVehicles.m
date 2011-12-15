//
//  DataVehicles.m
//  ServiceRecord
//
//  Created by Chris Hulbert on 23/11/11.
//  Copyright (c) 2011 Splinter Software. All rights reserved.
//

#import "DataVehicles.h"
#import "Vehicle.h"
#import "ConciseKit.h"
#import "DataUtils.h"
#import "JSON.h"
#import "Service.h"

static NSString* VehicleDataFile = @"Vehicle.json";
static NSString* ExportFile = @"Printable service history.html";
static NSString* ServiceFileNamePrefix = @"_Service.json";

@implementation DataVehicles

+ (DataVehicles*)i {
    static DataVehicles* instance=nil;
    if (!instance) {
        instance = [[DataVehicles alloc] init];
    }
    return instance;
}

- (NSArray*)list {
    NSArray* arr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[$ documentPath] error:nil];
    NSMutableArray* vehicles = [NSMutableArray array];
    for (NSString* folder in arr) {
        NSString* path = [[$ documentPath] stringByAppendingPathComponent:folder];
        NSString* dataFile = [path stringByAppendingPathComponent:VehicleDataFile];
        NSString* dataContents = [NSString stringWithContentsOfFile:dataFile encoding:NSUTF8StringEncoding error:nil];
        NSDictionary* dict = [dataContents JSONValue];
        if (dict) {
            Vehicle* v = [Vehicle fromDict:dict];
            if (v) {
                [vehicles addObject:v];
            }
        }
    }
    return vehicles;
}

- (NSString*)pathForVehicle:(Vehicle*)v {
    NSString* folderName = [DataUtils cleanForPath:v.makeModel];
    NSString* fullPath = [[$ documentPath] stringByAppendingPathComponent:folderName];
    return fullPath;
}

- (void)add:(Vehicle*)vehicle {
    // Make the folder
    NSString* fullPath = [self pathForVehicle:vehicle];
    [[NSFileManager defaultManager] createDirectoryAtPath:fullPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    // Make the file
    NSString* dataFile = [fullPath stringByAppendingPathComponent:VehicleDataFile];
    NSString* dataContents = vehicle.asDict.JSONRepresentation;
    [dataContents writeToFile:dataFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

- (void)update:(Vehicle*)vehicle {
    // Find the folder
    NSString* folder = [self pathForVehicle:vehicle];
    NSString* dataFile = [folder stringByAppendingPathComponent:VehicleDataFile];
    NSString* dataContents = vehicle.asDict.JSONRepresentation;
    [dataContents writeToFile:dataFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

- (void)writeExport:(NSString*)html forVehicle:(Vehicle*)vehicle {
    // Note: Only write to the file *if* there's a difference
    // So read the existing file to see if necessary
    NSString* folder = [self pathForVehicle:vehicle];
    NSString* dataFile = [folder stringByAppendingPathComponent:ExportFile];
    NSString* oldContents = [NSString stringWithContentsOfFile:dataFile encoding:NSUTF8StringEncoding error:nil];
    if (!$eql(html, oldContents)) {
        [html writeToFile:dataFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}

- (void)writeService:(Service*)service forVehicle:(Vehicle*)vehicle {
    // Make the file
    NSString* vehiclePath = [self pathForVehicle:vehicle];
    NSString* serviceFileName = $str(@"%@%@", [DataUtils isoDt:service.date], ServiceFileNamePrefix);
    NSString* servicePath = [vehiclePath stringByAppendingPathComponent:serviceFileName];
    NSString* dataContents = service.asDict.JSONRepresentation;
    [dataContents writeToFile:servicePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

- (void)addService:(Service*)service toVehicle:(Vehicle*)vehicle {
    [self writeService:service forVehicle:vehicle];
}

- (void)updateService:(Service*)service forVehicle:(Vehicle*)vehicle {
    [self writeService:service forVehicle:vehicle];
}

// Call me before creating a service or changing the date of an existing service to avoid clashes
- (BOOL)existsServiceOnDate:(NSDate*)newDate forVehicle:(Vehicle*)vehicle {
    NSString* vehiclePath = [self pathForVehicle:vehicle];
    NSString* newServiceFileName = $str(@"%@%@", [DataUtils isoDt:newDate], ServiceFileNamePrefix);
    NSString* newServicePath = [vehiclePath stringByAppendingPathComponent:newServiceFileName];
    return [[NSFileManager defaultManager] fileExistsAtPath:newServicePath];
}

- (void)changeService:(Service*)service forVehicle:(Vehicle*)vehicle toDate:(NSDate*)newDate {
    // Rename the service
    NSString* vehiclePath = [self pathForVehicle:vehicle];
    NSString* oldServiceFileName = $str(@"%@%@", [DataUtils isoDt:service.date], ServiceFileNamePrefix);
    NSString* oldServicePath = [vehiclePath stringByAppendingPathComponent:oldServiceFileName];
    NSString* newServiceFileName = $str(@"%@%@", [DataUtils isoDt:newDate], ServiceFileNamePrefix);
    NSString* newServicePath = [vehiclePath stringByAppendingPathComponent:newServiceFileName];
    [[NSFileManager defaultManager] moveItemAtPath:oldServicePath toPath:newServicePath error:nil];
    
    // Rename the photos
    NSArray* arr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:vehiclePath error:nil];
    NSString* oldPhotoPrefix = [DataUtils isoDt:service.date];
    NSString* newPhotoPrefix = [DataUtils isoDt:newDate];
    for (NSString* oldFilename in arr) {
        // Item is eg 20111123_Service.json
        if ([oldFilename hasPrefix:oldPhotoPrefix]) {
            // Rename it!
            NSString* newFilename = [oldFilename stringByReplacingOccurrencesOfString:oldPhotoPrefix withString:newPhotoPrefix];
            NSString* oldPath = [vehiclePath stringByAppendingPathComponent:oldFilename];
            NSString* newPath = [vehiclePath stringByAppendingPathComponent:newFilename];
            [[NSFileManager defaultManager] moveItemAtPath:oldPath toPath:newPath error:nil];
        }
    }
    
    // Now update the file contents
    service.date = newDate;
    [self updateService:service forVehicle:vehicle];
}

- (void)deleteVehicle:(Vehicle*)v {
    NSString* vehiclePath = [self pathForVehicle:v];
    [[NSFileManager defaultManager] removeItemAtPath:vehiclePath error:nil];
}

- (void)deleteService:(Service*)s forVehicle:(Vehicle*)v {
    // Remove photos and the service json file
    NSString* vehiclePath = [self pathForVehicle:v];
    NSArray* arr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:vehiclePath error:nil];
    NSString* prefix = [DataUtils isoDt:s.date];
    for (NSString* filename in arr) {
        if ([filename hasPrefix:prefix]) {
            NSString* filepath = [vehiclePath stringByAppendingPathComponent:filename];
            [[NSFileManager defaultManager] removeItemAtPath:filepath error:nil];
        }
    }
}

- (NSArray*)servicesForVehicle:(Vehicle*)v {
    NSString* vehiclePath = [self pathForVehicle:v];
    NSArray* arr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:vehiclePath error:nil];
    NSMutableArray* services = [NSMutableArray array];
    for (NSString* item in arr) {
        // Item is eg 20111123_Service.json
        // Does it look like a service file?
        if ([item rangeOfString:ServiceFileNamePrefix].length) {
            // Expand item to its full path
            NSString* path = [vehiclePath stringByAppendingPathComponent:item];
            // Read it
            NSString* dataContents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
            // JSON parse it
            NSDictionary* dict = [dataContents JSONValue];
            // Did it read ok?
            if (dict) {
                Service* s = [Service fromDict:dict];
                if (s) {
                    [services addObject:s];
                }
            }
        }
    }
    // Sort it
    [services sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]]];
    return services;
}

// A list of the paths of photos for that service
- (NSArray*)photosForService:(Service*)service andVehicle:(Vehicle*)vehicle {
    NSString* vehiclePath = [self pathForVehicle:vehicle];
    NSArray* arr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:vehiclePath error:nil];
    NSString* prefix = $str(@"%@_", [DataUtils isoDt:service.date]);
    NSMutableArray* photos = [NSMutableArray array];
    for (NSString* filename in arr) {
        NSRange rng = [filename rangeOfString:prefix];
        if (rng.length && rng.location==0) {
            if ([[[filename pathExtension] lowercaseString] isEqualToString:@"jpg"]) {
                NSString* filePath = [vehiclePath stringByAppendingPathComponent:filename];
                [photos addObject:filePath];
            }
        }
    }
    [photos sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [((NSString*)obj1) compare:obj2];
    }];
    return photos;
}

- (NSString*)findAvailableFile:(NSString*)pathNoExt ext:(NSString*)ext {
    int count=1;
    while(true) {
        NSString* fullFilename = $str(@"%@.%@", pathNoExt, ext);
        if (count>1) {
            fullFilename = $str(@"%@ (%d).%@", pathNoExt, count, ext);
        }
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:fullFilename]) {
            return fullFilename;
        }
    }
}

- (void)savePhoto:(UIImage*)image forService:(Service*)service andVehicle:(Vehicle*)vehicle {
    NSString* vehiclePath = [self pathForVehicle:vehicle];
    NSString* prefix = $str(@"%@_", [DataUtils isoDt:service.date]);
    NSDateFormatter* df = $new(NSDateFormatter);
    df.dateStyle = NSDateFormatterShortStyle;
    df.timeStyle = NSDateFormatterShortStyle;
    NSString* nowStrDirty = [df stringFromDate:[NSDate date]]; // Unusable as a filename due to : and /
    NSString* nowStr = [DataUtils cleanPhotoForPath:nowStrDirty];
    NSString* baseName = $str(@"%@%@", prefix, nowStr);
    NSString* basePath = [vehiclePath stringByAppendingPathComponent:baseName];
    NSString* availablePath = [self findAvailableFile:basePath ext:@"jpg"];
    NSData* jpgData = UIImageJPEGRepresentation(image, 0.7);
    [jpgData writeToFile:availablePath atomically:YES];
}

@end
