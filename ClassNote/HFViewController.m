//
//  HFViewController.m
//  ClassNote
//
//  Created by XiaoYin Wang on 12-6-25.
//  Copyright (c) 2012年 HackFisher. All rights reserved.
//

#import "HFViewController.h"
#import "HFClassEditViewController.h"
#import "HFClassGridViewCell.h"
#import "sqlite3.h"
#define kDatabaseName @"classnote.sqlite3"

@interface HFViewController ()

@end

@implementation HFViewController
/*
 * TODO: 编辑课程，和Class关联。在课程表上显示Class，完善课程。
 * 将SQLite换成CoreData，不用SQL，简单的数据模型
 * Logo
 * 笔记界面，录音和拍照功能研究，图片声音存储。
 */

@synthesize databaseFilePath, managedObjectContext;

- (id)init {
	if (![super init])
		return nil;
	
	colours = [[NSArray alloc] initWithObjects:
               [UIColor redColor],
               [UIColor blueColor],
               [UIColor greenColor],
               [UIColor magentaColor],
               [UIColor yellowColor],
               [UIColor whiteColor],
               [UIColor grayColor],
               [UIColor lightGrayColor],
               [UIColor purpleColor],
               [UIColor orangeColor],
               nil];
	
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(edit)] autorelease];
    
    self.title = @"ClassGrid";
	self.gridView.delegate = self;
	self.gridView.dataSource = self;
	self.gridView.bounces = YES;
    
    
    //获取数据库文件路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    self.databaseFilePath = [documentsDirectory stringByAppendingPathComponent:kDatabaseName];
    //打开或创建数据库
    sqlite3 *database;
    if (sqlite3_open([self.databaseFilePath UTF8String] , &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"打开数据库失败！");
    }
    //创建数据库表
    NSString *createSQL = @"CREATE TABLE IF NOT EXISTS LESSON (ID integer primary key autoincrement, NAME TEXT, TEACHER TEXT, BOOK TEXT);";
    char *errorMsg;
    if (sqlite3_exec(database, [createSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"创建数据库表错误: %s", errorMsg);
    }
    //创建数据库表
    createSQL = @"CREATE TABLE IF NOT EXISTS CLASS (ID integer primary key autoincrement, LESSON_ID integer, ROOM text, DAYINWEEK integer, START integer, END integer);";
    if (sqlite3_exec(database, [createSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"创建数据库表错误: %s", errorMsg);
    }
    //创建数据库表
    createSQL = @"CREATE TABLE IF NOT EXISTS TEXTNOTE (ID integer primary key autoincrement, CLASS_ID integer, NOTE TEXT, TIME timestamp);";
    if (sqlite3_exec(database, [createSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"创建数据库表错误: %s", errorMsg);
    }
        
    //关闭数据库
    sqlite3_close(database);
    //当程序进入后台时执行写入数据库操作
    UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(applicationWillResignActive:)
     name:UIApplicationWillResignActiveNotification
     object:app];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)edit {
    HFClassEditViewController *vc = [[HFClassEditViewController alloc] initWithNibName:@"HFClassEditView" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
    
    //打开或创建数据库
    sqlite3 *database;
    if (sqlite3_open([self.databaseFilePath UTF8String] , &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"打开数据库失败！");
    }
    
    //执行查询
    NSString *query = @"SELECT ID, NAME, TEACHER, BOOK FROM LESSON ORDER BY ID";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        //依次读取数据库表格LESSONS中每行的内容，并显示在对应的TextField
        while (sqlite3_step(statement) == SQLITE_ROW) {
            //获得数据
            int id = sqlite3_column_int(statement, 0);
            char *name = (char *)sqlite3_column_text(statement, 1);
            char *teacher = (char *)sqlite3_column_text(statement, 2);
            char *book = (char *)sqlite3_column_text(statement, 3);
            
            NSLog(@"The id is %d, name is %@, teacher is %@, book is %@", id, [[NSString alloc] initWithUTF8String:name], [[NSString alloc] initWithUTF8String:teacher], [[NSString alloc] initWithUTF8String:book]);
        }
        sqlite3_finalize(statement);
    }

    //关闭数据库
    sqlite3_close(database);
}

// 强制横屏
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)dealloc {
    [colours release];
    [super dealloc];
}

- (NSInteger)numberOfRowsInGridView:(DTGridView *)gridView {
	return 13;
}
- (NSInteger)numberOfColumnsInGridView:(DTGridView *)gridView forRowWithIndex:(NSInteger)theIndex {
	return 8;
}
- (CGFloat)gridView:(DTGridView *)gridView heightForRow:(NSInteger)rowIndex {
	return 20.0f;
}
- (CGFloat)gridView:(DTGridView *)gridView widthForCellAtRow:(NSInteger)rowIndex column:(NSInteger)columnIndex {
	return 60.0f;
}
- (DTGridViewCell *)gridView:(DTGridView *)gv viewForRow:(NSInteger)rowIndex column:(NSInteger)columnIndex {
	HFClassGridViewCell *cell = (HFClassGridViewCell *)[gv dequeueReusableCellWithIdentifier:@"cell"];
    
	if (!cell) {
        cell = [[[HFClassGridViewCell alloc] initWithReuseIdentifier:@"cell"] autorelease];
	}
	
    if (rowIndex == 0 && columnIndex == 0) {
        cell.backgroundColor = [UIColor whiteColor];
        cell.titleLabel.text = @"";
    } else if (rowIndex == 0) {
        cell.backgroundColor = [UIColor blackColor];
        cell.titleLabel.text = [NSString stringWithFormat:@"星期%d", columnIndex];
    } else if (columnIndex == 0) {
        cell.backgroundColor = [UIColor blueColor];
        cell.titleLabel.text = [NSString stringWithFormat:@"%d", rowIndex];
    } else {
        cell.backgroundColor = [UIColor whiteColor];
        cell.titleLabel.text = @"";
    }
	
	
	return cell;
}

- (void)applicationWillResignActive:(NSNotification *)notification {
    //打开数据库
    /**
    sqlite3 *database;
    if (sqlite3_open([self.databaseFilePath UTF8String], &database)
        != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"打开数据库失败！");
    }
    //向表格插入四行数据
    for (int i = 1; i <= 4; i++) { 
        //根据tag获得TextField
        UITextField *textField = (UITextField *)[self.view viewWithTag:i];
        //使用约束变量插入数据
        char *update = "INSERT OR REPLACE INTO FIELDS (TAG, FIELD_DATA) VALUES (?, ?);";
        sqlite3_stmt *stmt;
        if (sqlite3_prepare_v2(database, update, -1, &stmt, nil) == SQLITE_OK) {
            sqlite3_bind_int(stmt, 1, i);
            sqlite3_bind_text(stmt, 2, [textField.text UTF8String], -1, NULL);
        }
        char *errorMsg = NULL;
        if (sqlite3_step(stmt) != SQLITE_DONE)
            NSAssert(0, @"更新数据库表FIELDS出错: %s", errorMsg);
        sqlite3_finalize(stmt);
    }
    //关闭数据库
    sqlite3_close(database);
     **/
}

@end
