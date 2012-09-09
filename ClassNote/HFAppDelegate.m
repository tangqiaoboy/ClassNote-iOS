//
//  HFAppDelegate.m
//  ClassNote
//
//  Created by XiaoYin Wang on 12-6-25.
//  Copyright (c) 2012年 HackFisher. All rights reserved.
//

#import "HFAppDelegate.h"

#import "HFViewController.h"
#import "GuideViewController.h"
#import "YISplashScreen.h"
#import "YISplashScreenAnimation.h"

#define SHOWS_MIGRATION_ALERT   0   // 0 or 1
#define ANIMATION_TYPE          1   // 0-2

@implementation HFAppDelegate

@synthesize window = _window;

- (void)startApp
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
#if ANIMATION_TYPE == 0
    
    // simple fade out
    [YISplashScreen hide];
    
#elif ANIMATION_TYPE == 1
    
    // manual
    [YISplashScreen hideWithAnimations:^(CALayer* splashLayer) {
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.7];
        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [CATransaction setCompletionBlock:^{
            
        }];
        
        splashLayer.position = CGPointMake(splashLayer.position.x, splashLayer.position.y-splashLayer.bounds.size.height);
        
        [CATransaction commit];
    }];
    
#else
    
    // page curl
    [YISplashScreen hideWithAnimations:[YISplashScreenAnimation pageCurlAnimation]];
    
#endif
    
    // main window
    window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    // Override point for customization after application launch.
    //增加标识，用于判断是否是第一次启动应用...
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) { 
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"]; 
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"]; 
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        GuideViewController *appStartController = [[GuideViewController alloc] init];
        appStartController.delegate = self;
        
        window.rootViewController = appStartController;
    }else {
        HFViewController *vc = [[HFViewController alloc] init];
        
        NSManagedObjectContext *context = [self managedObjectContext];
        if (!context) {
            NSLog(@"ManagedObjectContext created failed. %@", "Nothing");
        }
        
        vc.managedObjectContext = context;
        
        navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
        
        [vc release];
        
        [window addSubview:navigationController.view];
    }
    
    [window makeKeyAndVisible];
}

#pragma mark -

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == _confirmAlert) {
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Migrating..." message:@"Please wait..." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        [alert show];
        
        //
        // NOTE: add CoreData migration logic here
        //
        
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            [alert dismissWithClickedButtonIndex:0 animated:YES];
            
            _completeAlert = [[UIAlertView alloc] initWithTitle:@"Migration Complete" message:@"Test is complete." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [_completeAlert show];
        });
        
    }
    else if (alertView == _completeAlert) {
        
        // call after migration finished
        [self startApp];
        
    }
}

- (void)dealloc
{
    [_window release];
    [navigationController release];
    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // show splash
    [YISplashScreen show];
    
#if SHOWS_MIGRATION_ALERT
    
    // show migration confirm alert
    _confirmAlert = [[UIAlertView alloc] initWithTitle:@"Migration Start" message:@"This is test." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [_confirmAlert show];
    
#else
    
    // start app immediately
    [self startApp];
    
#endif
    
    return YES;
}

- (UIViewController *)goingToMain {
    HFViewController *vc = [[HFViewController alloc] init];
    
    NSManagedObjectContext *context = [self managedObjectContext];
    if (!context) {
        NSLog(@"ManagedObjectContext created failed. %@", "Nothing");
    }
    
    vc.managedObjectContext = context;
    
    navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [vc release];
    
    return navigationController;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSError *error;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Update to handle the error appropriately.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            exit(-1);  // Fail
        } 
    }
}

//

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
    
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
    
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    
    
    NSString *storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"CoreDataBooks.sqlite"];
    /*
     Set up the store.
     For the sake of illustration, provide a pre-populated default store.
     */
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // If the expected store doesn't exist, copy the default store.
    if (![fileManager fileExistsAtPath:storePath]) {
        NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:@"ClassNote" ofType:@"sqlite"];
        if (defaultStorePath) {
            [fileManager copyItemAtPath:defaultStorePath toPath:storePath error:NULL];
        }
    }
    
    NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];    
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    
    NSError *error;
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);  // Fail
    }    
    
    return persistentStoreCoordinator;
}


#pragma mark -
#pragma mark Application's documents directory

/**
 Returns the path to the application's documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

@end
