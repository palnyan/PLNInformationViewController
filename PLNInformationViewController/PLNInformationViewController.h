//
//  PLNInformationViewController.h
//  PLNInformationViewController
//
//  Created by Haruka Togawa on 10/9/15.
//  Copyright © 2015 Haruka Togawa. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PLNInformationViewControllerDelegate;

@interface PLNInformationViewController : UITableViewController

@property (weak, nonatomic) id <PLNInformationViewControllerDelegate> delegate;

- (id)initWithFile:(NSString *)file;

@property (strong, nonatomic) NSArray *components;

@end

@protocol PLNInformationViewControllerDelegate <NSObject>

@optional
- (void)informationViewController:(PLNInformationViewController *)controller openURL:(NSURL *)URL;
- (void)informationViewController:(PLNInformationViewController *)controller openLicenseInfo:(NSDictionary *)info;

@end
