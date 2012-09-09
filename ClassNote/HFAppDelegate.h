//
//  HFAppDelegate.h
//  ClassNote
//
//  Created by XiaoYin Wang on 12-6-25.
//  Copyright (c) 2012年 HackFisher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GuideViewController.h"

@interface HFAppDelegate : UIResponder <UIApplicationDelegate, GuideViewControllerDelegate, UIAlertViewDelegate> {
    UIWindow *window;
	UINavigationController *navigationController;
    
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    
    UIAlertView* _confirmAlert;
    UIAlertView* _completeAlert;

}

@property (nonatomic, retain) UIWindow *window;

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, readonly) NSString *applicationDocumentsDirectory;

@end
