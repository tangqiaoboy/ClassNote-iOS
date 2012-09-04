//
//  HFClassEditViewControllerViewController.h
//  ClassNote
//
//  Created by XiaoYin Wang on 12-6-26.
//  Copyright (c) 2012年 HackFisher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFClass.h"

@protocol AddHFClassViewControllerDelegate;

@interface HFClassEditViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>{
    HFClass *hfClass;
    id <AddHFClassViewControllerDelegate> delegate;

    NSArray * daysInWeek;
    NSInteger dayInWeek;
    NSInteger start;
    NSInteger end;
    bool keyboardShown;
    UITextField *activeField;
}
@property (nonatomic, retain) HFClass *hfClass;

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UITextField *lessonText;
@property (retain, nonatomic) IBOutlet UITextField *classRoomText;
@property (retain, nonatomic) IBOutlet UIPickerView *dayInWeekPickerView;

@property (nonatomic, assign) id <AddHFClassViewControllerDelegate> delegate;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end

@protocol AddHFClassViewControllerDelegate
- (void)addViewController:(HFClassEditViewController *)controller didFinishWithSave:(BOOL)save;
@end
