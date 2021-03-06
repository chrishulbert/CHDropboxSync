//
//  AppDelegate.m
//  ServiceRecord
//
//  Created by Chris Hulbert on 22/11/11.
//  Copyright (c) 2011 Splinter Software. All rights reserved.
//

#import "AppDelegate.h"
#import "ConciseKit.h"
#import "SettingsRoot.h"
#import "ChooseVehicle.h"
#import "Data.h"
#import "DropboxSDK.h"
#import "CHDropboxSync.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    // Override point for customization after application launch.
    
    // First tab
    ChooseVehicle* chooseVehicle = [[[ChooseVehicle alloc] initWithNibName:@"ChooseVehicle" bundle:nil] autorelease];
    UINavigationController* tab1 = [[[UINavigationController alloc] initWithRootViewController:chooseVehicle] autorelease];
    tab1.title = @"Vehicles";
    tab1.tabBarItem.image = [UIImage imageNamed:@"jeep"];
    
    // Second tab
    SettingsRoot* settings = [[[SettingsRoot alloc] initWithNibName:@"SettingsRoot" bundle:nil] autorelease];
    UINavigationController* settingsNav = [[[UINavigationController alloc] initWithRootViewController:settings] autorelease];
    settingsNav.title = @"Dropbox";
    settingsNav.tabBarItem.image = [UIImage imageNamed:@"dropbox_tab"];
        
    // Tab controller
    self.tabBarController = [[[UITabBarController alloc] init] autorelease];
    self.tabBarController.viewControllers = $arr(tab1, settingsNav);
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    // Dropbox
#warning Put your app-folder-type dropbox keys in here
    DBSession* dbSession = [[[DBSession alloc] initWithAppKey:@"BLAH" appSecret:@"YADA" root:kDBRootAppFolder] autorelease];
    [DBSession setSharedSession:dbSession];    
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    if ([[DBSession sharedSession] handleOpenURL:url]) {
        if ([[DBSession sharedSession] isLinked]) {
            NSLog(@"App linked successfully!");
            [CHDropboxSync forgetStatus];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Linked" object:nil];
            // At this point you can start making API calls
        }
        return YES;
    }
    // Add whatever other url handling code your app requires here
    return NO;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
