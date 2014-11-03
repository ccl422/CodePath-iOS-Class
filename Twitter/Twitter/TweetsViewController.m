//
//  TweetsViewController.m
//  Twitter
//
//  Created by Chia-Chi Lin on 10/29/14.
//  Copyright (c) 2014 Chia-Chi Lin. All rights reserved.
//

#import "TweetsViewController.h"
#import "User.h"
#import "Tweet.h"
#import "TwitterClient.h"
#import "HomeCell.h"
#import <UIImageView+AFNetworking.h>
#import <SVProgressHUD.h>
#import "UpdateViewController.h"
#import "TweetDetailViewController.h"

@interface TweetsViewController () <UITableViewDelegate, UITableViewDataSource, UpdateViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSDate *tweetLoadTime;
@property (strong, nonatomic) NSMutableArray *tweets;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSLock *reloadLock;

@end

@implementation TweetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Home";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(onLogout:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self action:@selector(onNewStatus)];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeCell" bundle:nil] forCellReuseIdentifier:@"HomeCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(reloadTweets) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    self.reloadLock = [[NSLock alloc] init];
    
    [self reloadTweets];
}

- (void)viewWillAppear:(BOOL)animated {
    [self reloadTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLogout:(id)sender {
    [User logout];
}

- (void)onNewStatus {
    UpdateViewController *vc = [[UpdateViewController alloc] init];
    vc.currentUser = [User currentUser];
    vc.delegate = self;
    vc.inReplyId = nil;
    vc.inReplyScreenName = nil;
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
}

- (void)reloadTweets {
    if ([self.reloadLock tryLock]) {
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        [[TwitterClient sharedInstance] homeTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
            self.tweets = [[NSMutableArray alloc] initWithArray:tweets];
            [self reloadTable];
        
            [SVProgressHUD popActivity];
            [self.refreshControl endRefreshing];
            [self.reloadLock unlock];
        }];
    } else {
        NSLog(@"no lock");
    }
}

- (void)reloadTweetsFromId:(NSString *)maxId {
    if ([self.reloadLock tryLock]) {
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        [[TwitterClient sharedInstance] homeTimelineWithParams:@{@"max_id":maxId} completion:^(NSArray *tweets, NSError *error) {
            [self.tweets addObjectsFromArray:tweets];
            [self reloadTable];
        
            [SVProgressHUD popActivity];
            [self.refreshControl endRefreshing];
            [self.reloadLock unlock];
        }];
    }
}

- (void)reloadTable {
    self.tweetLoadTime = [NSDate date];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Tweet *tweet = self.tweets[indexPath.row];
    
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCell"];
    [cell.profileImageView setImageWithURL:[NSURL URLWithString:tweet.user.profileImageUrl]];
    cell.nameLabel.text = tweet.user.name;
    cell.screenNameLabel.text = [NSString stringWithFormat:@"@%@", tweet.user.screenname];
    cell.timeLabel.text = [self timeDifference:tweet.createdAt];
    cell.tweetLabel.text = tweet.text;
    cell.tweetLabel.preferredMaxLayoutWidth = cell.tweetLabel.bounds.size.width;
    cell.retweetLabel.text = [NSString stringWithFormat:@"%ld", tweet.retweetCount];
    cell.favoriteLabel.text = [NSString stringWithFormat:@"%ld", tweet.favouritesCount];
    [cell.replyButton setImage:[UIImage imageNamed:@"reply.png"] forState:UIControlStateNormal];
    if (tweet.retweeted) {
        [cell.retweetButton setImage:[UIImage imageNamed:@"retweetOn.png"] forState:UIControlStateNormal];
    } else {
        [cell.retweetButton setImage:[UIImage imageNamed:@"retweetOff.png"] forState:UIControlStateNormal];
    }
    if (tweet.favorited) {
        [cell.favoriteButton setImage:[UIImage imageNamed:@"favoriteOn.png"] forState:UIControlStateNormal];
    } else {
        [cell.favoriteButton setImage:[UIImage imageNamed:@"favoriteOff.png"] forState:UIControlStateNormal];
    }
    cell.tweet = tweet;
    cell.vc = self;
    
    if (indexPath.row == self.tweets.count - 1) {
        [self reloadTweetsFromId:tweet.id];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetDetailViewController *vc = [[TweetDetailViewController alloc] init];
    vc.tweet = self.tweets[indexPath.row];
    vc.vc = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSString *)timeDifference:(NSDate *)creationTime {
    NSTimeInterval diffInSec = [self.tweetLoadTime timeIntervalSinceDate:creationTime];
    
    if (diffInSec < 60) {
        return [NSString stringWithFormat:@"%ds", (int)diffInSec];
    } else if (diffInSec < 60 * 60) {
        return [NSString stringWithFormat:@"%dm", (int)(diffInSec / 60)];
    } else if (diffInSec < 60 * 60 * 24) {
        return [NSString stringWithFormat:@"%dh", (int)(diffInSec / 60 / 60)];
    } else {
        return [NSString stringWithFormat:@"%dd", (int)(diffInSec / 60 / 60 / 24)];
    }
}

- (void)cancelUpdate:(UpdateViewController *)vc {
    [vc dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendUpdate:(UpdateViewController *)vc withStatus:(Tweet *)tweet {
    [[TwitterClient sharedInstance] updateWithParams:@{@"status":tweet.text} completion:^(Tweet *newTweet, NSError *error) {
        tweet.id = newTweet.id;
    }];
    [self.tweets insertObject:tweet atIndex:0];
    [self reloadTable];
    [vc dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendUpdate:(UpdateViewController *)vc withStatus:(Tweet *)tweet inReplyId:(NSString *)inReplyId {
    [[TwitterClient sharedInstance] updateWithParams:@{@"status":tweet.text, @"in_reply_to_status_id":inReplyId} completion:^(Tweet *newTweet, NSError *error) {
        tweet.id = newTweet.id;
    }];
    [self.tweets insertObject:tweet atIndex:0];
    [self reloadTable];
    [vc dismissViewControllerAnimated:YES completion:nil];
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
