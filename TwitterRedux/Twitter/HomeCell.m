//
//  HomeCell.m
//  Twitter
//
//  Created by Chia-Chi Lin on 10/31/14.
//  Copyright (c) 2014 Chia-Chi Lin. All rights reserved.
//

#import "HomeCell.h"
#import "TwitterClient.h"
#import "ProfileViewController.h"

@implementation HomeCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onReply:(id)sender {
    UpdateViewController *vc = [[UpdateViewController alloc] init];
    vc.currentUser = [User currentUser];
    vc.delegate = self.vc;
    vc.inReplyId = self.tweet.id;
    vc.inReplyScreenName = self.tweet.user.screenname;
    [self.vc presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
}

- (IBAction)onRetweet:(id)sender {
    if (self.tweet.retweeted) {
        [[TwitterClient sharedInstance] deleteRetweetWithId:self.tweet.id completion:^(Tweet *tweet, NSError *error) {
            if (!error) {
                self.tweet.retweeted = NO;
                --self.tweet.retweetCount;
                self.retweetLabel.text = [NSString stringWithFormat:@"%ld", self.tweet.retweetCount];
                [self.retweetButton setImage:[UIImage imageNamed:@"retweetOff.png"] forState:UIControlStateNormal];
            }
        }];
    } else {
        [[TwitterClient sharedInstance] createRetweetWithId:self.tweet.id completion:^(Tweet *tweet, NSError *error) {
            if (!error) {
                self.tweet.retweeted = YES;
                ++self.tweet.retweetCount;
                self.retweetLabel.text = [NSString stringWithFormat:@"%ld", self.tweet.retweetCount];
                [self.retweetButton setImage:[UIImage imageNamed:@"retweetOn.png"] forState:UIControlStateNormal];
            }
        }];
    }
}

- (IBAction)onFavorite:(id)sender {
    if (self.tweet.favorited) {
        [[TwitterClient sharedInstance] deleteFavoriteWithParams:@{@"id":self.tweet.id} completion:^(Tweet *tweet, NSError *error) {
            if (!error) {
                self.tweet.favorited = NO;
                --self.tweet.favouritesCount;
                self.favoriteLabel.text = [NSString stringWithFormat:@"%ld", self.tweet.favouritesCount];
                [self.favoriteButton setImage:[UIImage imageNamed:@"favoriteOff.png"] forState:UIControlStateNormal];
            }
        }];
    } else {
        [[TwitterClient sharedInstance] createFavoriteWithParams:@{@"id":self.tweet.id} completion:^(Tweet *tweet, NSError *error) {
            if (!error) {
                self.tweet.favorited = YES;
                ++self.tweet.favouritesCount;
                self.favoriteLabel.text = [NSString stringWithFormat:@"%ld", self.tweet.favouritesCount];
                [self.favoriteButton setImage:[UIImage imageNamed:@"favoriteOn.png"] forState:UIControlStateNormal];
            }
        }];
    }
}

- (IBAction)onProfileImageTap:(UITapGestureRecognizer *)sender {
    [self.vc presentViewController:[[UINavigationController alloc] initWithRootViewController:[[ProfileViewController alloc] initWithUser:self.user withStyle:ProfileViewStyleDone]] animated:YES completion:nil];
}

@end
