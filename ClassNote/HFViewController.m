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

@interface HFViewController ()

@end

@implementation HFViewController
/*
 * TODO: 编辑课程，和Class关联。在课程表上显示Class，完善课程。
 * Logo
 * 笔记界面，录音和拍照功能研究，图片声音存储。
 */

@synthesize managedObjectContext, lessonsDictionary, fetchedResultsController;

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
    
    weekdays = [[NSArray alloc] initWithObjects:
                NSLocalizedString(@"Sunday", @""),
                NSLocalizedString(@"Monday", @""),
                NSLocalizedString(@"Tuesday", @""),
                NSLocalizedString(@"Wednesday", @""),
                NSLocalizedString(@"Thursday", @""),
                NSLocalizedString(@"Friday", @""),
                NSLocalizedString(@"Saturday", @""),
                nil];
    
    lessonsDictionary = [NSMutableDictionary dictionaryWithCapacity:(7*12)];
	
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // edit button
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Edit", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(editLesson)] autorelease];
    
    // add button
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
                                                              target:self action:@selector(addLesson)];
    self.navigationItem.rightBarButtonItem = addButton;
    [addButton release];
    
    //
    self.title = NSLocalizedString(@"ClassNote", @"");
	self.gridView.delegate = self;
	self.gridView.dataSource = self;
	self.gridView.bounces = YES;
    
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
    
    NSArray *fetchedObjects = fetchedResultsController.fetchedObjects;
    
    //http://www.raywenderlich.com/934/core-data-on-ios-5-tutorial-getting-started
    for (HFClass *class in fetchedObjects) {
        NSNumber * key = [NSNumber numberWithInt:[class.dayinweek intValue] * 7 + [class.start intValue]];
        if (! [lessonsDictionary objectForKey:key]) {
            [lessonsDictionary setObject:class forKey:key];
        }
        NSLog(@"Room: %@", class.room);
        NSLog(@"DayInWeek: %@", class.dayinweek);
        NSLog(@"Start: %@", class.start);
        NSLog(@"LessionId: %@", class.lesson);
    }
    
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
    //self.lessonsDictionary = nil;
    // Release any properties that are loaded in viewDidLoad or can be recreated lazily.
	self.fetchedResultsController = nil;
}

- (void)addLesson {
    // Create and configure a new instance of the Event entity.
    HFClass *hfClass = (HFClass *)[NSEntityDescription insertNewObjectForEntityForName:@"HFClass" inManagedObjectContext:managedObjectContext];
    
    [hfClass setStart:[NSNumber numberWithInt:1]];
    [hfClass setEnd:[NSNumber numberWithInt:3]];
    [hfClass setDayinweek:[NSNumber numberWithInt:4]];
    
    NSError *error = nil;
    if (![managedObjectContext save:&error]) {
        // TODO: handle the erroe
        NSLog(@"Save failed.%@", @"Nothing");
    }
}

- (void)editLesson {
    HFClassEditViewController *vc = [[HFClassEditViewController alloc] initWithNibName:@"HFClassEditView" bundle:nil];
    vc.delegate = self;
//    
//    NSManagedObjectContext *addingContext = [[NSManagedObjectContext alloc] init];
//	self.addingManagedObjectContext = addingContext;
//	[addingContext release];
    
    vc.hfClass = (HFClass *)[NSEntityDescription insertNewObjectForEntityForName:@"HFClass" inManagedObjectContext:managedObjectContext];
    
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

// 强制横屏
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)dealloc {
    [colours release];
    [lessonsDictionary release];
    [managedObjectContext release];
    [fetchedResultsController release];
    [super dealloc];
}

- (NSInteger)numberOfRowsInGridView:(DTGridView *)gridView {
	return 14;
}
- (NSInteger)numberOfColumnsInGridView:(DTGridView *)gridView forRowWithIndex:(NSInteger)theIndex {
    if (theIndex == 13) {
        return 1;
    } else {
        return 8;
    }
}
- (CGFloat)gridView:(DTGridView *)gv heightForRow:(NSInteger)rowIndex {
	return gv.frame.size.height/[self numberOfRowsInGridView:gv];
}
- (CGFloat)gridView:(DTGridView *)gv widthForCellAtRow:(NSInteger)rowIndex column:(NSInteger)columnIndex {
	return gv.frame.size.width/[self numberOfColumnsInGridView:gv forRowWithIndex:rowIndex];
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
        cell.backgroundColor = [UIColor yellowColor];
        cell.titleLabel.text = [weekdays objectAtIndex: columnIndex-1];
    } else if (rowIndex == 13) {
        cell.backgroundColor = [UIColor greenColor];
        cell.titleLabel.text = [NSString stringWithFormat:@"For Editing%@", @""];
    } else if (columnIndex == 0) {
        cell.backgroundColor = [UIColor blueColor];
        cell.titleLabel.text = [NSString stringWithFormat:@"%d", rowIndex];
    } else {
//        [self fetchedResultsController] 
        cell.backgroundColor = [UIColor whiteColor];
        NSNumber * key = [NSNumber numberWithInt:(columnIndex-1) * 7 + rowIndex - 1];
        HFClass * class = [lessonsDictionary objectForKey:key];
        if (class) {
            cell.titleLabel.text = [class.lesson description];
        } else {
            cell.titleLabel.text = @"";
        }
    }
	
	
	return cell;
}

- (void)addViewController:(HFClassEditViewController *)controller didFinishWithSave:(BOOL)save {
	
	if (save) {
        // do save
        // Create and configure a new instance of the Event entity.
        NSError *error;
		if (![managedObjectContext save:&error]) {
			// Update to handle the error appropriately.
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			exit(-1);  // Fail
		}
    }
    
    //[self dismissModalViewControllerAnimated:YES];
}

/**
 Returns the fetched results controller. Creates and configures the controller if necessary.
 */
- (NSFetchedResultsController *)fetchedResultsController {
    
    if (fetchedResultsController != nil) {
        return fetchedResultsController;
    }
    
	// Create and configure a fetch request with the Book entity.
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"HFClass" inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
	
	// Create the sort descriptors array.
	NSSortDescriptor *dayinweekDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dayinweek" ascending:YES];
	NSSortDescriptor *startDescriptor = [[NSSortDescriptor alloc] initWithKey:@"start" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:dayinweekDescriptor, startDescriptor, nil];
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	// Create and initialize the fetch results controller.
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:@"dayinweek" cacheName:@"Root"];
	self.fetchedResultsController = aFetchedResultsController;
	fetchedResultsController.delegate = self;
	
	// Memory management.
	[aFetchedResultsController release];
	[fetchRequest release];
	[dayinweekDescriptor release];
	[startDescriptor release];
	[sortDescriptors release];
	
	return fetchedResultsController;
}

/**
 Delegate methods of NSFetchedResultsController to respond to additions, removals and so on.
 */

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller is about to start sending change notifications, so prepare the table view for updates.

}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    /*
	switch (type) {
        case NSFetchedResultsChangeInsert:
        {
            HFClass *class = (HFClass *)anObject;
            NSNumber * key = [NSNumber numberWithInt:[class.dayinweek intValue] * 7 + [class.start intValue]];
            if ([lessonsDictionary objectForKey:key]){
                NSLog(@"The class for key %d already exists.", [key intValue]);
            }
            [lessonsDictionary setObject:class forKey:key];
            break;
        }
        case NSFetchedResultsChangeMove:
        {
            break;
        }
        case NSFetchedResultsChangeDelete:
        {
            HFClass *class = (HFClass *)anObject;
            NSNumber * key = [NSNumber numberWithInt:[class.dayinweek intValue] * 7 + [class.start intValue]];
            [lessonsDictionary removeObjectForKey:key];
        }
        case NSFetchedResultsChangeUpdate:
        {
            
            HFClass *class = (HFClass *)anObject;
            NSNumber * key = [NSNumber numberWithInt:[class.dayinweek intValue] * 7 + [class.start intValue]];
             
            // do nothing.
        }
        default:
            break;
    }
	*/
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	
	
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.view setNeedsDisplay];
	
}

- (void)applicationWillResignActive:(NSNotification *)notification {
    // The application is about to become inactive.
}

@end
