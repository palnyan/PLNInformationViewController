//
//  ViewController.m
//  PLNInformationViewControllerDemo
//
//  Created by Haruka Togawa on 10/9/15.
//  Copyright © 2015 Haruka Togawa. All rights reserved.
//

#import "ViewController.h"
#import "PLNInformationViewController.h"

@interface ViewController () {
	PLNInformationViewController *vc;
}

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	vc = [[PLNInformationViewController alloc] initWithFile:@"PLNInformation"];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *ReuseIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
	if (indexPath.row == 0) {
		cell.textLabel.text = @"push";
	} else {
		cell.textLabel.text = @"present modal";
	}
	return cell;
}

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
	if (indexPath.row == 0) {
	} else {
//		cell.textLabel.text = @"present modal";
	}
}

@end
