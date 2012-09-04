//
//  HFLesson.h
//  ClassNote
//
//  Created by XiaoYin Wang on 12-9-5.
//  Copyright (c) 2012年 HackFisher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface HFLesson : NSManagedObject

@property (nonatomic, retain) NSString * book;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * teacher;

@end
