//
//  TweetDetailViewController.m
//  Twitter
//
//  Created by Chia-Chi Lin on 11/2/14.
//  Copyright (c) 2014 Chia-Chi Lin. All rights reserved.
//

#import "TweetDetailViewController.h"
#import <UIImageView+AFNetworking.h>
#import "TwitterClient.h"

@interface TweetDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@end

@implementation TweetDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Tweet";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Reply" style:UIBarButtonItemStylePlain target:self action:@selector(onReply:)];
}

- (void)viewWillLayoutSubviews {
    [self.profileImageView setImageWithURL:[NSURL URLWithString:self.tweet.user.profileImageUrl]];
    self.nameLabel.text = self.tweet.user.name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", self.tweet.user.screenname];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yy, hh:mm a"];
    self.timeLabel.text = [formatter stringFromDate:self.tweet.createdAt];
    self.tweetLabel.text = self.tweet.text;
    self.tweetLabel.preferredMaxLayoutWidth = self.tweetLabel.bounds.size.width;
    self.retweetLabel.text = [NSString stringWithFormat:@"%ld", self.tweet.retweetCount];
    self.favoriteLabel.text = [NSString stringWithFormat:@"%ld", self.tweet.favouritesCount];
    [self.replyButton setImage:[UIImage imageNamed:@"reply.png"] forState:UIControlStateNormal];
    if (self.tweet.retweeted) {
        [self.retweetButton setImage:[UIImage imageNamed:@"retweetOn.png"] forState:UIControlStateNormal];
    } else {
        [self.retweetButton setImage:[UIImage imageNamed:@"retweetOff.png"] forState:UIControlStateNormal];
    }
    if (self.tweet.favorited) {
        [self.favoriteButton setImage:[UIImage imageNamed:@"favoriteOn.png"] forState:UIControlStateNormal];
    } else {
        [self.favoriteButton setImage:[UIImage imageNamed:@"favoriteOff.png"] forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
