//
//  DTGridViewAppDelegate.m
//  DTGridView
//
//  Created by Daniel Tull on 10.02.2010.
//  Copyright Daniel Tull 2010. All rights reserved.
//

#import "DTGridViewAppDelegate.h"
#import "HFViewController.h"
@implementation DTGridViewAppDelegate

@synthesize window;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
    window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
	UITableViewController *vc = [[UITableViewController alloc] initWithStyle:UITableViewStyleGrouped];
	
    //UITableViewController *vc = [[[UITableViewController alloc] init] autorelease];
    
	navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
	
	vc.title = @"DTGridView";
    //vc.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(edit)] autorelease];
	vc.tableView.delegate = self;
	vc.tableView.dataSource = self;
	[vc release];
	
	[window addSubview:navigationController.view];
	//window.rootViewController = navigationController;
    
    
    // Override point for customization after application launch
    [window makeKeyAndVisible];
}


- (void)dealloc {
	[navigationController release];
    [window release];
    [super dealloc];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	if (section == 0) return 1;
	if (section == 1) return 3;
	
	return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	if (section == 0) return @"Please attribute me when using my source code by linking to my website. Thank you.";
	if (section == 2) return @"©2008-2010 Daniel Tull\nwww.danieltull.co.uk";

	return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
	
	if (!cell)
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	NSString *cellText = nil;
	
	if (indexPath.section == 0 && indexPath.row == 0)
		cellText = @"Source License";
	else if (indexPath.section == 1 && indexPath.row == 0)
		cellText = @"DTGridView";
	else if (indexPath.section == 1 && indexPath.row == 1)
		cellText = @"DTInfiniteGridView";
	else if (indexPath.section == 1 && indexPath.row == 2)
		cellText = @"DTSnapGridView";
	
	cell.textLabel.text = cellText;
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
}

@end
