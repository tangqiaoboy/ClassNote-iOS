//
//  HFClassEditViewControllerViewController.h
//  ClassNote
//
//  Created by XiaoYin Wang on 12-6-26.
//  Copyright (c) 2012年 HackFisher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFClass.h"
#import "HFLesson.h"

@protocol AddHFClassViewControllerDelegate;

@interface HFClassEditViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>{
    HFClass *hfClass;
    
    id <AddHFClassViewControllerDelegate> delegate;

    NSArray * daysInWeek;
    NSInteger dayInWeek;
    NSInteger start;
    NSInteger end;
    HFLesson *hfLesson;
    
    bool keyboardShown;
    UITextField *activeField;
}
@property (nonatomic, retain) HFClass *hfClass;
@property (nonatomic, retain) HFLesson *hfLesson;

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UITextField *lessonText;
@property (retain, nonatomic) IBOutlet UITextField *classRoomText;
@property (retain, nonatomic) IBOutlet UIPickerView *dayInWeekPickerView;
@property (retain, nonatomic) IBOutlet UILabel *dayInWeekLabel;
@property (retain, nonatomic) IBOutlet UILabel *startLabel;
@property (retain, nonatomic) IBOutlet UILabel *endLabel;
@property (retain, nonatomic) IBOutlet UILabel *lessonLabel;
@property (retain, nonatomic) IBOutlet UILabel *classRoomLabel;

@property (nonatomic, assign) id <AddHFClassViewControllerDelegate> delegate;

@property (nonatomic, assign) NSInteger dayInWeek;
@property (nonatomic, assign) NSInteger start;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end

@protocol AddHFClassViewControllerDelegate
- (void)addViewController:(HFClassEditViewController *)controller didFinishWithSave:(BOOL)save;
@end
