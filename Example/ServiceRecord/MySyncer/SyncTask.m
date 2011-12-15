//
//  SyncTask.m
//
//  Created by Chris Hulbert on 12/12/11.
//  Copyright (c) 2011 Splinter Software. All rights reserved.
//

#import "SyncTask.h"

@implementation SyncTask

@synthesize taskType;
@synthesize path;

- (void)dealloc {
    self.path = nil;
    [super dealloc];
}

+ (SyncTask*)syncTaskWithType:(SyncTaskType)taskType andPath:(NSString*)path {
    SyncTask* st = [[[SyncTask alloc] init] autorelease];
    st.taskType = taskType;
    st.path = path;
    return st;
}

@end
