//
//  HFViewController.h
//  ClassNote
//
//  Created by XiaoYin Wang on 12-6-25.
//  Copyright (c) 2012年 HackFisher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTGridViewController.h"
#import "HFClassEditViewController.h"
#import "HFClass.h"

@interface HFViewController : DTGridViewController<AddHFClassViewControllerDelegate> {
    NSArray *colours;
    
    NSManagedObjectContext *managedObjectContext;
    
    NSMutableArray * lessonsArray;
    
    UIBarButtonItem *addButton;
}

@property (copy, nonatomic) NSString *databaseFilePath;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) NSMutableArray *lessonsArray;

@property (nonatomic, retain) UIBarButtonItem *addButton;

- (void)addLesson;

- (void)applicationWillResignActive:(NSNotification *)notification;

@end
