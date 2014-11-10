//
//  ProfileImageViewController.m
//  Twitter
//
//  Created by Chia-Chi Lin on 11/7/14.
//  Copyright (c) 2014 Chia-Chi Lin. All rights reserved.
//

#import "ProfileImageViewController.h"
#import <UIImageView+AFNetworking.h>

@interface ProfileImageViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;

@end

@implementation ProfileImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.profileImageView setImageWithURL:[NSURL URLWithString:self.user.profileImageUrl]];
    [self.backgroundImageView setImageWithURL:[NSURL URLWithString:self.user.profileBackgroudImageUrl]];
    self.nameLabel.text = self.user.name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", self.user.screenname];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
