//
//  MenuViewController.m
//  Twitter
//
//  Created by Chia-Chi Lin on 11/5/14.
//  Copyright (c) 2014 Chia-Chi Lin. All rights reserved.
//

#import "MenuViewController.h"
#import "User.h"
#import <UIImageView+AFNetworking.h>

@interface MenuViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self resetUser];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)resetUser {
    User *user = [User currentUser];
    [self.profileImageView setImageWithURL:[NSURL URLWithString:user.profileImageUrl]];
    self.nameLabel.text = user.name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", user.screenname];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Profile";
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"Home";
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"Mentions";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.delegate didSelectMenuRowAtIndexPath:indexPath];
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
