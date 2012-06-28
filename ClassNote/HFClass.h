//
//  HFClass.h
//  ClassNote
//
//  Created by XiaoYin Wang on 12-6-28.
//  Copyright (c) 2012年 HackFisher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface HFClass : NSManagedObject

@property (nonatomic, retain) NSNumber * dayinweek;
@property (nonatomic, retain) NSNumber * end;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * lesson_id;
@property (nonatomic, retain) NSString * room;
@property (nonatomic, retain) NSNumber * start;

@end
