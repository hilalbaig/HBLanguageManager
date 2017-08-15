//
//  LanguagesTableViewController.h
//  Internationalization
//
//  Created by Hilal Baig on 5/2/17.
//  Copyright © 2017 HilalB. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - Delegates
@class LanguagesTableViewController;

@protocol LanguagesTableViewControllerDelegate <NSObject>
- (void)controller:(LanguagesTableViewController*)controller didSelectLanguage:(NSString*)language;
@end


@interface LanguagesTableViewController : UITableViewController
@property (nonatomic, assign) id<LanguagesTableViewControllerDelegate> delegate;

@end
