//
//  HFClassEditViewControllerViewController.h
//  ClassNote
//
//  Created by XiaoYin Wang on 12-6-26.
//  Copyright (c) 2012年 HackFisher. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HFClassEditViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>{

    NSArray * daysInWeek;
    NSInteger dayInWeek;
    NSInteger start;
    NSInteger end;
}
@property (retain, nonatomic) IBOutlet UITextField *lessonText;
@property (retain, nonatomic) IBOutlet UITextField *classRoomText;

@property (retain, nonatomic) IBOutlet UIPickerView *dayInWeekPickerView;

@property (copy, nonatomic) NSString *databaseFilePath;

@end
