//
//  AccountViewController.h
//  Twitter
//
//  Created by Chia-Chi Lin on 11/8/14.
//  Copyright (c) 2014 Chia-Chi Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@protocol AccountViewDelegate;

@interface AccountViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak) id <AccountViewDelegate> delegate;

@end

@protocol AccountViewDelegate <NSObject>

- (void)didSelectAccountRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)switchUser:(User *)user;
- (void)closeAccountManager;

@end