//
//  SyncTask.h
//
//  Created by Chris Hulbert on 12/12/11.
//  Copyright (c) 2011 Splinter Software. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    SyncTaskTypeNone = 0,
    SyncTaskTypeFileDownload,
    SyncTaskTypeFileUpload,
    SyncTaskTypeFileRemoteDelete,
    SyncTaskTypeFileLocalDelete,
    SyncTaskTypeFolderLocalAdd,
    SyncTaskTypeFolderRemoteAdd,
    SyncTaskTypeFolderLocalDelete,
    SyncTaskTypeFolderRemoteDelete
} SyncTaskType;

@interface SyncTask : NSObject
@property(assign) SyncTaskType taskType;
@property(retain) NSString* path;

+ (SyncTask*)syncTaskWithType:(SyncTaskType)taskType andPath:(NSString*)path;

@end
