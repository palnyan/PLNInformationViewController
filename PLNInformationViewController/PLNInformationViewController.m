//
//  PLNInformationViewController.m
//  PLNInformationViewController
//
//  Created by Haruka Togawa on 10/9/15.
//  Copyright © 2015 Haruka Togawa. All rights reserved.
//

#import "PLNInformationViewController.h"

@implementation PLNInformationViewController {
	UIBarButtonItem *_dismissButton;
}

- (id)init {
	if (self = [super initWithStyle:UITableViewStyleGrouped]) {
		[self _initialize];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
		[self _initialize];
	}
	return self;
}

- (id)initWithStyle:(UITableViewStyle)style {
	if (self = [super initWithStyle:style]) {
		[self _initialize];
	}
	return self;
}

- (void)_initialize {
//	NSDictionary *infoDictionary = [NSBundle mainBundle].infoDictionary;
//	_bundleName = infoDictionary[@"CFBundleDisplayName"];
//	_currentVersion = infoDictionary[@"CFBundleShortVersionString"];
//	_currentBuild = infoDictionary[@"CFBundleVersion"];
//	_iconFile = infoDictionary[@"CFBundleIcons"][@"CFBundlePrimaryIcon"][@"CFBundleIconFiles"][0];
//	
	_dismissButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Dismiss", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(dismiss:)];
	
//	_headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, 77.0f)];
//	_headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//	self.tableView.tableHeaderView = _headerView;
//	
//	_headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 57.0f, 57.0f)];
//	_headerImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
//	_headerImageView.image = [UIImage imageNamed:_iconFile];
//	if ([_headerImageView respondsToSelector:@selector(layer)]) {
//		_headerImageView.layer.cornerRadius = 8.0f;
//	}
//	_headerImageView.clipsToBounds = YES;
//	[_headerView addSubview:_headerImageView];
//	
//	_headerNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(77.0f, 25.0f, _headerView.frame.size.width-87.0f, 24.0f)];
//	_headerNameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//	_headerNameLabel.text = NSLocalizedString(_bundleName, nil);
//	_headerNameLabel.font = [UIFont boldSystemFontOfSize:18.0f];
//	_headerNameLabel.backgroundColor = [UIColor clearColor];
//	[_headerView addSubview:_headerNameLabel];
//	
//	_licenseTextView = [[UITextView alloc] initWithFrame:CGRectMake(0.0f, 4.0f, self.view.bounds.size.width, 142.0f)];
//	_licenseTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//	if ([_licenseTextView respondsToSelector:@selector(layer)]) {
//		_licenseTextView.layer.cornerRadius = 8.0f;
//	}
//	_licenseTextView.layer.cornerRadius = 10.0f;
//	_licenseTextView.clipsToBounds = YES;
//	_licenseTextView.editable = NO;
//	_licenseTextView.scrollIndicatorInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.title = NSLocalizedString(@"PLNInformationTitle", nil);
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	// If PLNInformationViewController pushed in root of navigation controller, show dismiss button on navigation bar.
	if (![self isInPopover]) {
		if (self.navigationController && self.navigationController.viewControllers[0] == self) {
			self.navigationItem.leftBarButtonItem = _dismissButton;
		}
	}
}

#pragma mark - Actions

- (void)dismiss:(id)sender {
	if (self.navigationController) {
		NSInteger i = [self.navigationController.viewControllers indexOfObject:self];
		if (i > 0) {
			[self.navigationController popViewControllerAnimated:YES];
			return;
		}
	}
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Helper methods

- (BOOL)isInPopover {
	UIView *currentView = self.view;
	while (currentView) {
		NSString *classNameOfCurrentView = NSStringFromClass([currentView class]);
		NSString *searchString = @"UIPopoverView";
		if ([classNameOfCurrentView rangeOfString:searchString options:NSCaseInsensitiveSearch].location != NSNotFound) {
			return YES;
		}
		currentView = currentView.superview;
	}
	return NO;
}


#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;//_components.count + 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 0) return nil;
	
//	NSDictionary *data = _components[section-1];
//	//	NSString *s = data[@"Type"];
//	
//	return data[@"Name"];
	return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return 1;
	}
//	else {
//		NSDictionary *data = _components[section-1];
//		NSString *s = data[@"Type"];
//		
//		if ([s isEqualToString:@"Copyrights"]) {
//			NSArray *services = data[@"Services"];
//			return services.count + 1;
//		}
//		else if ([s isEqualToString:@"License"]) {
//			return 1;
//		}
//	}
	return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) return 44.0f;
	
//	NSDictionary *data = _components[indexPath.section-1];
//	NSString *s = data[@"Type"];
//	
//	if ([s isEqualToString:@"Copyrights"]) {
//		if (indexPath.row == 0) {
//			return 80.0f;
//		}
//		return 44.0f;
//	}
//	else if ([s isEqualToString:@"Applications"]) {
//		return 80.0f;
//	}
//	else if ([s isEqualToString:@"License"]) {
//		return 150.0f;
//	}
	return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *ReuseIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ReuseIdentifier];
	}
//	else {
//		for (id v in cell.contentView.subviews) {
//			[v removeFromSuperview];
//		}
//	}
	return cell;
}

@end
