//
//  SettingsRoot.h
//  ServiceRecord
//
//  Created by Chris Hulbert on 22/11/11.
//  Copyright (c) 2011 Splinter Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHDropboxSync;

@interface SettingsRoot : UITableViewController<UIAlertViewDelegate>

@property(retain) CHDropboxSync* syncer;

@end
