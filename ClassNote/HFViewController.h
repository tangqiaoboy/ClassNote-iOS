//
//  HFViewController.h
//  ClassNote
//
//  Created by XiaoYin Wang on 12-6-25.
//  Copyright (c) 2012年 HackFisher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTGridViewController.h"

@interface HFViewController : DTGridViewController {
    NSArray *colours;
}

@property (copy, nonatomic) NSString *databaseFilePath;

- (void)applicationWillResignActive:(NSNotification *)notification;

@end
