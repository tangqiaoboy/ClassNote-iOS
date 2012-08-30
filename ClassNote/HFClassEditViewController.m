//
//  HFClassEditViewControllerViewController.m
//  ClassNote
//
//  Created by XiaoYin Wang on 12-6-26.
//  Copyright (c) 2012年 HackFisher. All rights reserved.
//

#import "HFClassEditViewController.h"
#import "sqlite3.h"
#define kDatabaseName @"database.sqlite3"

@interface HFClassEditViewController ()

@end

@implementation HFClassEditViewController

@synthesize lessonText;
@synthesize classRoomText;
@synthesize dayInWeekPickerView;
@synthesize databaseFilePath;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        self.databaseFilePath = [documentsDirectory stringByAppendingPathComponent:kDatabaseName];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    lessonText.delegate = self;
    classRoomText.delegate = self;
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(done)] autorelease];
    
    daysInWeek = [[NSArray alloc] initWithObjects:@"Sun.", @"Mon.",@"Tues.",@"Wed.",@"Thur.", @"Fri.", @"Sat.", nil];
    
    dayInWeek = 0;
    
    start = 1;
    end = 2;
    
    [dayInWeekPickerView selectRow:dayInWeek inComponent:0 animated:false];
    [dayInWeekPickerView selectRow:(start-1) inComponent:1 animated:false];
    [dayInWeekPickerView selectRow:(end-1) inComponent:2 animated:false];
}

- (void)viewDidUnload
{
    [self setLessonText:nil];
    [self setClassRoomText:nil];
    [self setDayInWeekPickerView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)done {
    //打开或创建数据库
    sqlite3 *database;
    if (sqlite3_open([self.databaseFilePath UTF8String] , &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"打开数据库失败！");
    }
    
    char *update = "INSERT OR REPLACE INTO CLASS (LESSON_ID, ROOM, DAYINWEEK, START, END) VALUES (?, ?, ?, ?, ?);";
    sqlite3_stmt *stmt;
    
    int lesson_id = 1;
    if (sqlite3_prepare_v2(database, update, -1, &stmt, nil) == SQLITE_OK) {
        sqlite3_bind_int(stmt, 1, lesson_id);
        sqlite3_bind_text(stmt, 2, [classRoomText.text UTF8String], -1, NULL);
        sqlite3_bind_int(stmt, 3, dayInWeek);
        sqlite3_bind_int(stmt, 4, start);
        sqlite3_bind_int(stmt, 5, end);
    }
    char *errorMsg = NULL;
    if (sqlite3_step(stmt) != SQLITE_DONE)
        NSAssert(0, @"更新数据库表CLASS出错: %s", errorMsg);
    sqlite3_finalize(stmt);
    
    // 编辑完成，退回到主界面
    [self.navigationController popViewControllerAnimated:TRUE];
    
    //执行查询
    NSString *query = @"SELECT ID, LESSON_ID, ROOM, DAYINWEEK, START, END FROM CLASS ORDER BY ID";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        //依次读取数据库表格LESSONS中每行的内容，并显示在对应的TextField
        while (sqlite3_step(statement) == SQLITE_ROW) {
            //获得数据
            int id = sqlite3_column_int(statement, 0);
            int lesson_id = sqlite3_column_int(statement, 1);
            char *room = (char *)sqlite3_column_text(statement, 2);
            
            NSLog(@"The id is %d, lesson_id is %d, room is %@", id, lesson_id, [[NSString alloc] initWithUTF8String:room]);
        }
        sqlite3_finalize(statement);
    }
    
    //关闭数据库
    sqlite3_close(database);
}


- (void)dealloc {
    [daysInWeek release];
    [lessonText release];
    [classRoomText release];
    [dayInWeekPickerView release];
    [super dealloc];
}


// TODO: 分成3栏， 星期几， 开始节，结束节
// UIPickerViewDataSouce
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return 7;
    } else {
        return 12;
    }
}

// returns width of column and height of row for each component. 
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 80.0f;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 25.0f;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    //NSLog(@"component is %d", component);
    if ( component == 0) {
        return [daysInWeek objectAtIndex:row];
    } else {
        return [NSString stringWithFormat:@"%d", row +1];
    }
}
//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
//    
//}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        dayInWeek = row;
    } else if (component == 1) {
        start = (row + 1);
    } else if (component == 2) {
        end = (row + 1);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.lessonText) {
        [theTextField resignFirstResponder];
        return NO;
    } else if (theTextField == self.classRoomText) {
        [theTextField resignFirstResponder];
        return NO;
    }
    return YES;
}
@end
