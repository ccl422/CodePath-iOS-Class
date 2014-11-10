//
//  ProfileViewController.m
//  Twitter
//
//  Created by Chia-Chi Lin on 11/6/14.
//  Copyright (c) 2014 Chia-Chi Lin. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileImageViewController.h"
#import "ProfileDescriptionViewController.h"

@interface ProfileViewController () <UIScrollViewDelegate>

@property (strong, nonatomic) User *user;
@property (nonatomic) ProfileViewStyle profileStyle;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingLabel;
@property (weak, nonatomic) IBOutlet UILabel *followerLabel;
@property (strong, nonatomic) ProfileImageViewController *profileImageVC;
@property (strong, nonatomic) ProfileDescriptionViewController *profileDescriptionVC;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (self.user.screenname == [User currentUser].screenname) {
        self.title = @"Me";
    } else {
        self.title = self.user.name;
    }
    
    if (self.profileStyle == ProfileViewStyleLogout) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(onLogout)];
    } else if (self.profileStyle == ProfileViewStyleDone){
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(onDone)];
    }
    
    self.profileImageVC = [[ProfileImageViewController alloc] init];
    self.profileImageVC.user = self.user;
    [self.profileHeaderView addSubview:self.profileImageVC.view];
    
    self.profileDescriptionVC = [[ProfileDescriptionViewController alloc] init];
    self.profileDescriptionVC.user = self.user;
    [self.profileHeaderView addSubview:self.profileDescriptionVC.view];
    
    self.profileHeaderView.delegate = self;
    
    self.tweetLabel.text = [NSString stringWithFormat:@"    %ld", self.user.statusesCount];
    self.followingLabel.text = [NSString stringWithFormat:@"    %ld", self.user.friendsCount];
    self.followerLabel.text = [NSString stringWithFormat:@"    %ld", self.user.followersCount];
}

- (void)viewDidLayoutSubviews {
    CGRect frame = self.profileHeaderView.bounds;
    frame.origin.y = 0;
    self.profileImageVC.view.frame = frame;
    frame.origin.x += frame.size.width;
    self.profileDescriptionVC.view.frame = frame;
    self.profileHeaderView.contentSize = CGSizeMake(frame.size.width * 2, frame.size.height);
    self.profileHeaderView.contentOffset = CGPointMake(0, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)init {
    if (self = [super init]) {
        self.user = [User currentUser];
        self.profileStyle = ProfileViewStyleLogout;
    }
    return self;
}

- (id)initWithUser:(User *)user withStyle:(ProfileViewStyle)style {
    if (self = [super init]) {
        self.user = user;
        self.profileStyle = style;
    }
    return self;

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat scrollWidth = self.profileHeaderView.bounds.size.width;
    CGFloat scrollLocation = self.profileHeaderView.contentOffset.x;
    self.profileImageVC.backgroundImageView.alpha = 0.5 + (scrollWidth - scrollLocation) / scrollWidth / 2;
    self.profileDescriptionVC.backgroundImageView.alpha = 0.5 + scrollLocation / scrollWidth / 2;
}

- (void)onLogout {
    [User logout];
}

- (void)onDone {
    [self dismissViewControllerAnimated:YES completion:nil];
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
