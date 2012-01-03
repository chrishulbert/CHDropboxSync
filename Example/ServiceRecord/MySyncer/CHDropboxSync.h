//
//  CHDropboxSync.h
//
//  Created by Chris Hulbert on 11/12/11.
//  Copyright (c) 2011 Splinter Software. All rights reserved.
//  MIT license - no warranties!

#import <Foundation/Foundation.h>
#import "DropboxSDK.h"

@interface CHDropboxSync : NSObject<DBRestClientDelegate, UIAlertViewDelegate>

@property(assign) id delegate;

- (void)doSync;
+ (void)forgetStatus;

@end
