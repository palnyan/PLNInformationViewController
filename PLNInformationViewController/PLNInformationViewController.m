//
//  PLNInformationViewController.m
//  PLNInformationViewController
//
//  Created by Haruka Togawa on 10/9/15.
//  Copyright © 2015 Haruka Togawa. All rights reserved.
//

#import "PLNInformationViewController.h"
#import <sys/sysctl.h>
#import <MessageUI/MessageUI.h>

#define AppStoreURL_iOS6_OR_Earlier @"itms-apps://itunes.apple.com/app/id%@"
#define AppStoreURL_iOS7_OR_Later @"https://itunes.apple.com/jp/app/id%@&mt=8"

@interface PLNInformationViewController () <MFMailComposeViewControllerDelegate> {
	UIBarButtonItem *_dismissButtonItem;
	UIView *_headerView;
	UIImageView *_headerImageView;
	UILabel *_headerNameLabel;
	UITextView *_licenseTextView;
	
	NSMutableDictionary *_info;
}

- (void)_initialize;

@end

@implementation PLNInformationViewController

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

- (id)initWithFile:(NSString *)file {
	if (self = [self init]) {
		NSString *path = [[NSBundle mainBundle] pathForResource:file ofType:@"plist"];
		_components = [NSArray arrayWithContentsOfFile:path];
	}
	return self;
}

- (void)_initialize {
	_info = [[NSMutableDictionary alloc] init];
	NSDictionary *infoDictionary = [NSBundle mainBundle].infoDictionary;
	[_info setValue:infoDictionary[@"CFBundleName"] forKey:@"BundleName"];
	[_info setValue:infoDictionary[@"CFBundleShortVersionString"] forKey:@"Version"];
	[_info setValue:infoDictionary[@"CFBundleVersion"] forKey:@"Build"];
	[_info setValue:[self deviceModel] forKey:@"DeviceModel"];
	[_info setValue:[[UIDevice currentDevice] systemVersion] forKey:@"SystemVersion"];
//	_iconFile = infoDictionary[@"CFBundleIcons"][@"CFBundlePrimaryIcon"][@"CFBundleIconFiles"][0];
//	
	_dismissButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Dismiss", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(dismiss:)];
	
	_headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, 77.0f)];
	_headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	self.tableView.tableHeaderView = _headerView;

	_headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 57.0f, 57.0f)];
	_headerImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
	_headerImageView.image = [UIImage imageNamed:[NSBundle mainBundle].infoDictionary[@"CFBundleIcons"][@"CFBundlePrimaryIcon"][@"CFBundleIconFiles"][0]];
	if ([_headerImageView respondsToSelector:@selector(layer)]) {
		_headerImageView.layer.cornerRadius = 8.0f;
	}
	_headerImageView.clipsToBounds = YES;
	[_headerView addSubview:_headerImageView];
	
	_headerNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(77.0f, 25.0f, _headerView.frame.size.width-87.0f, 24.0f)];
	_headerNameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	_headerNameLabel.text = NSLocalizedString(_info[@"BundleName"], nil);
	_headerNameLabel.font = [UIFont boldSystemFontOfSize:18.0f];
	_headerNameLabel.backgroundColor = [UIColor clearColor];
	[_headerView addSubview:_headerNameLabel];

	_licenseTextView = [[UITextView alloc] initWithFrame:CGRectMake(0.0f, 4.0f, self.view.bounds.size.width, 172.0f)];
	_licenseTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	if ([_licenseTextView respondsToSelector:@selector(layer)]) {
		_licenseTextView.layer.cornerRadius = 8.0f;
	}
	_licenseTextView.layer.cornerRadius = 10.0f;
	_licenseTextView.clipsToBounds = YES;
	_licenseTextView.editable = NO;
	_licenseTextView.scrollIndicatorInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
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
			self.navigationItem.leftBarButtonItem = _dismissButtonItem;
		}
		else {
			self.navigationItem.leftBarButtonItem = nil;
		}
	}
}

#pragma mark - Properties

- (void)setComponents:(NSArray *)components {
	_components = components;
	[self.tableView reloadData];
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

- (void)openURL:(NSURL *)URL {
	if (!URL) return;
	
	if ([_delegate respondsToSelector:@selector(informationViewController:openURL:)]) {
		[_delegate informationViewController:self openURL:URL];
	}
	else {
		[[UIApplication sharedApplication] openURL:URL];
	}
}

- (BOOL)systemVersionIsLaterThanVersion:(NSString *)version {
	NSString *currentSystemVersion = [[UIDevice currentDevice] systemVersion];
	if ([version compare:currentSystemVersion options:NSNumericSearch] != NSOrderedDescending) {
		// version <= currentSystemVersion
		return YES;
	}
	// version > currentSystemVersion
	return NO;
}

- (NSString *)deviceModel {
	size_t size;
	sysctlbyname("hw.machine", NULL, &size, NULL, 0);
	char *machine = malloc(size);
	sysctlbyname("hw.machine", machine, &size, NULL, 0);
	NSString *deviceModel = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
	free(machine);
	return deviceModel;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return _components.count + 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 0) return nil;
	
	NSDictionary *data = _components[section-1];
	return data[@"Name"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return 1;
	}
	else {
		NSDictionary *data = _components[section-1];
		NSString *type = data[@"Type"];
		
		if ([type isEqualToString:@"Copyrights"]) {
			NSArray *services = data[@"Services"];
			return services.count + 1;
		}
		else if ([type isEqualToString:@"License"]) {
			return 1;
		}
	}
	return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) return 44.0f;
	
	NSDictionary *data = _components[indexPath.section-1];
	NSString *type = data[@"Type"];
	if ([type isEqualToString:@"Copyrights"]) {
		if (indexPath.row == 0) {
			return 80.0f;
		}
	}
	else if ([type isEqualToString:@"Applications"]) {
		return 80.0f;
	}
	else if ([type isEqualToString:@"License"]) {
		id description = data[@"Description"];
		NSLog(@"description class:%@", [description class]);
		if ([description isKindOfClass:[NSString class]]) {
			NSLog(@"NSString");
			return 180.0f;
		} else if ([description isKindOfClass:[NSDictionary class]]) {
			NSLog(@"NSDic");
			return 44.0f;
		}
		return 180.0f;
	}
	return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *ReuseIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ReuseIdentifier];
	}
	else {
		for (id v in cell.contentView.subviews) {
			[v removeFromSuperview];
		}
	}
	
	cell.textLabel.text = nil;
	cell.detailTextLabel.text = nil;
	cell.imageView.image = nil;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.accessoryType = UITableViewCellAccessoryNone;
	cell.accessoryView = nil;
	
	if (indexPath.section == 0) {
		cell.textLabel.text = NSLocalizedString(@"Version", nil);
		cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ (%@)", [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"], [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"]];
	} else {
		NSDictionary *data = _components[indexPath.section-1];
		NSString *type = data[@"Type"];
		if ([type isEqualToString:@"Copyrights"]) {
			if (indexPath.row == 0) {
				cell.textLabel.text = data[@"VendorName"];
				if ([data.allKeys containsObject:@"VendorLogo"]) {
					cell.imageView.image = [UIImage imageNamed:data[@"VendorLogo"]];
					NSLog(@"logo:%@(%@)", data[@"VendorLogo"], cell.imageView.image);
					if ([cell.imageView respondsToSelector:@selector(layer)]) {
						cell.imageView.layer.cornerRadius = 8.0f;
					}
					cell.imageView.clipsToBounds = YES;
				}
			}
			else {
				NSArray *services = data[@"Services"];
				NSDictionary *service = services[indexPath.row-1];
				NSString *type = service[@"Type"];
				NSString *title = service[@"Title"];
				NSString *subtitle = service[@"Subtitle"];
				
				cell.textLabel.text = title;
				if ([type isEqualToString:@"URL"]) {
					NSString *stringURL = service[@"URL"];
					cell.detailTextLabel.text = [service.allKeys containsObject:@"Subtitle"] ? subtitle : stringURL;
					cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				}
				else if ([type isEqualToString:@"Mail"]) {
					NSString *toAddress = service[@"ToAddress"];
					cell.detailTextLabel.text = [service.allKeys containsObject:@"Subtitle"] ? subtitle : toAddress;
				}
				else if ([type isEqualToString:@"AppStoreReview"]) {
				}
				cell.selectionStyle = UITableViewCellSelectionStyleDefault;
			}
		}
		else if ([type isEqualToString:@"License"]) {
			id description = data[@"Description"];
			if ([description isKindOfClass:[NSString class]]) {
				_licenseTextView.text = data[@"Description"];
				[cell.contentView addSubview:_licenseTextView];
			} else if ([description isKindOfClass:[NSDictionary class]]) {
				NSLog(@"NSDic");
				cell.selectionStyle = UITableViewCellSelectionStyleDefault;
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			}
		}
	}
	
	return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if (indexPath.section == 0) return;
	
	NSDictionary *data = _components[indexPath.section-1];
	NSString *type = data[@"Type"];
	if ([type isEqualToString:@"Copyrights"]) {
		if (indexPath.row > 0) {
			NSArray *services = data[@"Services"];
			NSDictionary *service = services[indexPath.row-1];
			NSString *type = service[@"Type"];
			if ([type isEqualToString:@"URL"]) {
				NSString *stringURL = service[@"URL"];
				NSURL *URL = [NSURL URLWithString:stringURL];
				[self openURL:URL];
			}
			else if ([type isEqualToString:@"Mail"]) {
				MFMailComposeViewController *vc = [[MFMailComposeViewController alloc] init];
				if (vc == nil) return;
				
				vc.mailComposeDelegate = self;
				[vc setToRecipients:service[@"ToRecipients"]];
				NSString *subject = service[@"Subject"];
				NSString *body = service[@"Body"];
				for (NSString *key in _info.allKeys) {
					NSString *placeholder = [NSString stringWithFormat:@"{%@}", key];
					subject = [subject stringByReplacingOccurrencesOfString:placeholder withString:_info[key]];
					body = [body stringByReplacingOccurrencesOfString:placeholder withString:_info[key]];
				}
				[vc setSubject:subject];
				[vc setMessageBody:body isHTML:NO];
				[self presentViewController:vc animated:YES completion:nil];
			}
			else if ([type isEqualToString:@"AppStoreReview"]) {
				NSString *stringURL;
				if ([self systemVersionIsLaterThanVersion:@"7.0"]) {
					stringURL = AppStoreURL_iOS7_OR_Later;
				}
				else {
					stringURL = AppStoreURL_iOS6_OR_Earlier;
				}
				stringURL = [NSString stringWithFormat:stringURL, service[@"AppleID"]];
				[self openURL:[NSURL URLWithString:stringURL]];
//				NSString *title = service[@"Title"];
//				_appleID = [service[@"AppleID"] integerValue];
//				if (NSStringFromClass([SKStoreProductViewController class]) != nil) {
//					SKStoreProductViewController *vc = [[SKStoreProductViewController alloc] init];
//					[vc loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:@(_appleID)} completionBlock:nil];
//					vc.delegate = self;
//					[self presentViewController:vc animated:YES completion:nil];
//				}
//				else if ([service.allKeys containsObject:@"Message"]) {
//					NSString *message = service[@"Message"];
//					NSString *cancelButtonTitle = NSLocalizedString(@"No thanks", nil);
//					NSString *rateButtonTitle = NSLocalizedString(@"Rate it!", nil);
//					UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:rateButtonTitle, nil];
//					[alert show];
//				}
//				else {
//					[self openAppStoreReviewWithAppleID:_appleID];
//				}
			}
		}
		
		
	} else if ([type isEqualToString:@"License"]) {
		id description = data[@"Description"];
		if ([description isKindOfClass:[NSDictionary class]]) {
			NSLog(@"NSDic");
			if ([_delegate respondsToSelector:@selector(informationViewController:openLicenseInfo:)]) {
				[_delegate informationViewController:self openLicenseInfo:description];
			}
		}
	}
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
