//
//  MainViewController.m
//  Twitter
//
//  Created by Chia-Chi Lin on 11/5/14.
//  Copyright (c) 2014 Chia-Chi Lin. All rights reserved.
//

#import "MainViewController.h"
#import "MenuViewController.h"
#import "TweetsViewController.h"
#import "ProfileViewController.h"
#import "AccountViewController.h"
#import "TwitterClient.h"
#import <GPUImage.h>

@interface MainViewController () <MenuViewDelegate, AccountViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIView *tabView;
@property (strong, nonatomic) MenuViewController *menuVC;
@property (strong, nonatomic) UINavigationController *homeVC;
@property (strong, nonatomic) UINavigationController *mentionsVC;
@property (strong, nonatomic) ProfileViewController *profileRootVC;
@property (strong, nonatomic) UINavigationController *profileVC;
@property (strong, nonatomic) AccountViewController *accountVC;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.accountVC = [[AccountViewController alloc] init];
    self.accountVC.delegate = self;
    [self.view addSubview:self.accountVC.view];
    
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onTabLongPress:)];
    [longPressGestureRecognizer setMinimumPressDuration:1];
    [self.tabView addGestureRecognizer:longPressGestureRecognizer];
    
    self.menuVC = [[MenuViewController alloc] init];
    self.menuVC.delegate = self;
    [self.view addSubview:self.menuVC.view];
    
    self.homeVC = [[UINavigationController alloc] initWithRootViewController:[[TweetsViewController alloc] initWithStyle:TweetsViewStyleHome]];
    
    self.mentionsVC = [[UINavigationController alloc] initWithRootViewController:[[TweetsViewController alloc] initWithStyle:TweetsViewStyleMentions]];
    
    self.profileRootVC = [[ProfileViewController alloc] init];
    self.profileVC = [[UINavigationController alloc] initWithRootViewController:self.profileRootVC];
    
    [self showHome];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    CGRect menuFrame = self.view.bounds;
    menuFrame.size.width *= 0.9;
    menuFrame.origin.x = -menuFrame.size.width;
    self.menuVC.view.frame = menuFrame;
    
    CGRect parentFrame = self.view.bounds;
    CGFloat frameHeight = parentFrame.size.height - 200.0;
    CGRect accountFrame = CGRectMake(parentFrame.size.width * 0.1, -frameHeight, parentFrame.size.width * 0.8, frameHeight);
    self.accountVC.view.frame = accountFrame;
}

- (void)didSelectMenuRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hideMenu];
    if (indexPath.row == 0) {
        [self showProfile];
    } else if (indexPath.row == 1) {
        [self showHome];
    } else if (indexPath.row == 2) {
        [self showMentions];
    }
}

- (void)didSelectAccountRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *availableUsers = [User availableUsers];
    NSMutableDictionary *dictionary = [availableUsers objectForKey:[[availableUsers allKeys] objectAtIndex:indexPath.row]];
    [[TwitterClient sharedInstance].requestSerializer removeAccessToken];
    [[TwitterClient sharedInstance].requestSerializer saveAccessToken:[BDBOAuthToken tokenWithToken:dictionary[@"access_token"] secret:dictionary[@"access_secret"] expiration:nil]];
    
    [self switchUser:[[User alloc] initWithDictionary:[availableUsers objectForKey:[[availableUsers allKeys] objectAtIndex:indexPath.row]]]];

    [self hideAccountTable];
}

- (void)switchUser:(User *)user {
    [User setCurrentUser:user];
    
    for (UIView * view in self.mainView.subviews) {
        [view removeFromSuperview];
    }
    
    self.homeVC = [[UINavigationController alloc] initWithRootViewController:[[TweetsViewController alloc] initWithStyle:TweetsViewStyleHome]];
    
    self.mentionsVC = [[UINavigationController alloc] initWithRootViewController:[[TweetsViewController alloc] initWithStyle:TweetsViewStyleMentions]];
    
    self.profileRootVC = [[ProfileViewController alloc] init];
    self.profileVC = [[UINavigationController alloc] initWithRootViewController:self.profileRootVC];
    
    [self.menuVC resetUser];
    
    [self showHome];
}

- (void)closeAccountManager {
    [self hideAccountTable];
}

- (IBAction)onViewPan:(UIPanGestureRecognizer *)sender {
    static CGPoint beganLocation;
    static UIImage *clonedImage;
    static UIImageView *blurredImageView = nil;
    static CGFloat blurredImageViewBeganHeight;
    
    CGPoint location = [sender locationInView:self.view];
    CGPoint velocity = [sender velocityInView:self.view];
        
    if (sender.state == UIGestureRecognizerStateBegan) {
        if (fabsf(velocity.y) < fabsf(velocity.x)) {
            if (velocity.x > 0) {
                [self showMenu];
            } else if (velocity.x < 0) {
                [self hideMenu];
            }
            
            return;
        }
        
        beganLocation = location;
            
        UIGraphicsBeginImageContext(self.profileRootVC.profileHeaderView.bounds.size);
        [self.profileRootVC.profileHeaderView drawViewHierarchyInRect:self.profileRootVC.profileHeaderView.bounds afterScreenUpdates:NO];
        clonedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
            
        GPUImageGaussianBlurFilter *blurFilter = [[GPUImageGaussianBlurFilter alloc] init];
        blurFilter.blurRadiusInPixels = 0.5;
            
        blurredImageView = [[UIImageView alloc] initWithImage:[blurFilter imageByFilteringImage:clonedImage]];
        blurredImageView.frame = self.profileRootVC.profileHeaderView.frame;
        [self.view insertSubview:blurredImageView aboveSubview:self.menuVC.view];
            
        blurredImageViewBeganHeight = blurredImageView.frame.size.height;
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        CGFloat panOffset = location.y - beganLocation.y;
            
        if (blurredImageView != nil && panOffset >= 0.0) {
            GPUImageGaussianBlurFilter *blurFilter = [[GPUImageGaussianBlurFilter alloc] init];
            blurFilter.blurRadiusInPixels = 0.5 + panOffset / self.profileRootVC.view.frame.size.height / 2;
            [blurredImageView setImage:[blurFilter imageByFilteringImage:clonedImage]];
                
            CGRect frame = blurredImageView.frame;
            frame.size.height = blurredImageViewBeganHeight + panOffset;
            blurredImageView.frame = frame;
        }
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        if (blurredImageView != nil) {
            [blurredImageView removeFromSuperview];
            blurredImageView = nil;
        }
    }
}

- (void)showMenu {
    if (self.menuVC.view.frame.origin.x < 0.0) {
        [self addChildViewController:self.menuVC];
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:3 options:0 animations:^{
            CGRect frame = self.menuVC.view.frame;
            frame.origin.x = 0.0;
            self.menuVC.view.frame = frame;
        } completion:^(BOOL finished) {
            [self.menuVC didMoveToParentViewController:self];
        }];
    }
}

- (void)hideMenu {
    if (self.menuVC.view.frame.origin.x >= 0.0) {
        [self addChildViewController:self.menuVC];
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:3 options:0 animations:^{
            CGRect frame = self.menuVC.view.frame;
            frame.origin.x = -frame.size.width;
            self.menuVC.view.frame = frame;
        } completion:^(BOOL finished) {
            [self.menuVC didMoveToParentViewController:self];
        }];
    }
}

- (void)showHome {
    [self addChildViewController:self.homeVC];
    self.homeVC.view.frame = self.mainView.frame;
    [self.mainView addSubview:self.homeVC.view];
    [self.homeVC didMoveToParentViewController:self];
}

- (void)showMentions {
    [self addChildViewController:self.mentionsVC];
    self.mentionsVC.view.frame = self.mainView.frame;
    [self.mainView addSubview:self.mentionsVC.view];
    [self.mentionsVC didMoveToParentViewController:self];
}

- (void)showProfile {
    [self addChildViewController:self.profileVC];
    self.profileVC.view.frame = self.mainView.frame;
    [self.mainView addSubview:self.profileVC.view];
    [self.profileVC didMoveToParentViewController:self];
}

- (void)onTabLongPress:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self showAccountTable];
    } else if (sender.state == UIGestureRecognizerStateChanged) {
    } else if (sender.state == UIGestureRecognizerStateEnded) {
    }
}

- (void)showAccountTable {
    if (self.accountVC.view.frame.origin.y < 0.0) {
        [self addChildViewController:self.accountVC];
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:3 options:0 animations:^{
            CGRect frame = self.accountVC.view.frame;
            frame.origin.y = 100.0;
            frame.size.height = self.view.bounds.size.height - 200.0;
            self.accountVC.view.frame = frame;
        } completion:^(BOOL finished) {
            [self.accountVC didMoveToParentViewController:self];
        }];
    }
}

- (void)hideAccountTable {
    if (self.accountVC.view.frame.origin.y >= 0.0) {
        [self addChildViewController:self.accountVC];
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:3 options:0 animations:^{
            CGRect frame = self.accountVC.view.frame;
            frame.origin.y = -frame.size.height;
            self.accountVC.view.frame = frame;
        } completion:^(BOOL finished) {
            [self.accountVC didMoveToParentViewController:self];
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
