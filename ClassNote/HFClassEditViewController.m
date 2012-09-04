//
//  HFClassEditViewControllerViewController.m
//  ClassNote
//
//  Created by XiaoYin Wang on 12-6-26.
//  Copyright (c) 2012年 HackFisher. All rights reserved.
//

#import "HFClassEditViewController.h"

@interface HFClassEditViewController ()

@end

@implementation HFClassEditViewController

@synthesize lessonText;
@synthesize classRoomText;
@synthesize dayInWeekPickerView;
@synthesize delegate;
@synthesize hfClass;
@synthesize scrollView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"New Lesson";
    
    lessonText.delegate = self;
    classRoomText.delegate = self;
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
                                                                                           target:self action:@selector(cancel:)] autorelease];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave 
                                                                                            target:self action:@selector(save:)] autorelease];
    
    daysInWeek = [[NSArray alloc] initWithObjects:@"Sun.", @"Mon.",@"Tues.",@"Wed.",@"Thur.", @"Fri.", @"Sat.", nil];
    
    dayInWeek = 0;
    
    start = 1;
    end = 2;
    
    [dayInWeekPickerView selectRow:dayInWeek inComponent:0 animated:false];
    [dayInWeekPickerView selectRow:(start-1) inComponent:1 animated:false];
    [dayInWeekPickerView selectRow:(end-1) inComponent:2 animated:false];
    
    [self registerForKeyboardNotifications];
}

- (void)viewDidUnload
{
    [self setLessonText:nil];
    [self setClassRoomText:nil];
    [self setDayInWeekPickerView:nil];
    [self setView:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)cancel:(id)sender {
	[delegate addViewController:self didFinishWithSave:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)save:(id)sender {
    //[hfClass setLesson_id:[NSNumber numberWithInt:1]];
    [hfClass setStart:[NSNumber numberWithInteger:start]];
    [hfClass setEnd:[NSNumber numberWithInteger:end]];
    [hfClass setDayinweek:[NSNumber numberWithInteger:dayInWeek]];
    [hfClass setRoom:classRoomText.text];
    
	[delegate addViewController:self didFinishWithSave:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)dealloc {
    [daysInWeek release];
    [lessonText release];
    [classRoomText release];
    [dayInWeekPickerView release];
    [scrollView release];
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

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasHidden:)
                                                 name:UIKeyboardDidHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    CGRect aRect = self.view.frame;
    
    NSDictionary* info = [aNotification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    kbRect = [self.view convertRect:kbRect fromView:nil];
    
    CGSize kbSize = kbRect.size;

    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    //CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y + activeField.frame.size.height - kbSize.height + 60); // 52 is the status bar'height plus the topbar's height
        [scrollView setContentOffset:scrollPoint animated:YES];
    }     
}


// Called when the UIKeyboardDidHideNotification is sent
- (void)keyboardWasHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
}

@end
