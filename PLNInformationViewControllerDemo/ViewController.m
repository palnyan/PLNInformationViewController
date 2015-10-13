//
//  ViewController.m
//  PLNInformationViewControllerDemo
//
//  Created by Haruka Togawa on 10/9/15.
//  Copyright © 2015 Haruka Togawa. All rights reserved.
//

#import "ViewController.h"
#import "PLNInformationViewController.h"

@interface ViewController () <PLNInformationViewControllerDelegate> {
	PLNInformationViewController *vc;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *popoverButtonItem;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
//	vc = [[PLNInformationViewController alloc] initWithFile:@"PLNInformation"];
	
	vc = [[PLNInformationViewController alloc] init];
	NSString *path = [[NSBundle mainBundle] pathForResource:@"PLNInformation" ofType:@"plist"];
	vc.components = [NSArray arrayWithContentsOfFile:path];
	vc.delegate = self;
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		self.navigationItem.rightBarButtonItem = _popoverButtonItem;
	}
}

#pragma mark - Actions

- (IBAction)popover:(id)sender {
	UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
	UIPopoverController *pc = [[UIPopoverController alloc] initWithContentViewController:nc];
	[pc presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:TRUE];
}

#pragma mark - UITableViewControllerDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *ReuseIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
	if (indexPath.row == 0) {
		cell.textLabel.text = @"Push";
	} else {
		cell.textLabel.text = @"Modal";
	}
	return cell;
}

#pragma mark UITableViewControllerDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:TRUE];
	
	switch (indexPath.row) {
		case 0:
			[self.navigationController pushViewController:vc animated:TRUE];
			break;
		default: {
			UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
			[self presentViewController:nc animated:TRUE completion:nil];
			break;
		}
	}
}

#pragma mark - PLNInformationViewControllerDelegate

- (void)informationViewController:(PLNInformationViewController *)controller openLicenseInfo:(NSDictionary *)info {
	NSLog(@"License:%@", info);
}

@end
