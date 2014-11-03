//
//  HomeCell.h
//  Twitter
//
//  Created by Chia-Chi Lin on 10/31/14.
//  Copyright (c) 2014 Chia-Chi Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "TweetsViewController.h"
#import "UpdateViewController.h"

@interface HomeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) Tweet *tweet;
@property (weak, nonatomic) TweetsViewController <UpdateViewDelegate> *vc;

@end
