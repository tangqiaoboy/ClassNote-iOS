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

static const int CLASSES_IN_DAY = 12;
static const int DAYS_IN_WEEK = 7;

@interface HFViewController : DTGridViewController<AddHFClassViewControllerDelegate, NSFetchedResultsControllerDelegate> {
    NSArray *colours;
    NSArray *weekdays;
    
    NSManagedObjectContext *managedObjectContext;
    
    NSFetchedResultsController *fetchedResultsController;
    
    NSMutableDictionary * lessonsDictionary;
    
    NSInteger selectedRow;
    NSInteger selectedColumn;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, retain) NSMutableDictionary *lessonsDictionary;

- (void)addLesson;

- (void)applicationWillResignActive:(NSNotification *)notification;

@end
