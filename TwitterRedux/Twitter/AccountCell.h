//
//  AccountCell.h
//  Twitter
//
//  Created by Chia-Chi Lin on 11/8/14.
//  Copyright (c) 2014 Chia-Chi Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountViewController.h"
#import "User.h"

@interface AccountCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) AccountViewController *vc;
@property (strong, nonatomic) User *user;

- (IBAction)onAccountCellPan:(UIPanGestureRecognizer *)sender;

@end
