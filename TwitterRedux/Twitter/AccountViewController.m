//
//  AccountViewController.m
//  Twitter
//
//  Created by Chia-Chi Lin on 11/8/14.
//  Copyright (c) 2014 Chia-Chi Lin. All rights reserved.
//

#import "AccountViewController.h"
#import "AccountCell.h"
#import "User.h"
#import "TwitterClient.h"
#import <UIImageView+AFNetworking.h>

@interface AccountViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"AccountCell" bundle:nil] forCellReuseIdentifier:@"AccountCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Accounts";
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [User availableUsers].count + 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *availableUsers = [User availableUsers];
    AccountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccountCell"];
    
    if (indexPath.row == availableUsers.count) {
        [cell.profileImageView setImage:[UIImage imageNamed:@"favoriteOn.png"]];
        cell.nameLabel.text = @"Add";
        cell.screenNameLabel.text = @"Add an account.";
        return cell;
    }
    
    if (indexPath.row == availableUsers.count + 1) {
        [cell.profileImageView setImage:[UIImage imageNamed:@"favoriteOn.png"]];
        cell.nameLabel.text = @"Cancel";
        cell.screenNameLabel.text = @"Close window.";
        return cell;
    }
    
    User *user = [[User alloc] initWithDictionary:[availableUsers objectForKey:[[availableUsers allKeys] objectAtIndex:indexPath.row]]];
    [cell.profileImageView setImageWithURL:[NSURL URLWithString:user.profileImageUrl]];
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:cell action:@selector(onAccountCellPan:)];
    [cell addGestureRecognizer:panGestureRecognizer];
    cell.nameLabel.text = user.name;
    cell.screenNameLabel.text = [NSString stringWithFormat:@"@%@", user.screenname];
    cell.vc = self;
    cell.user = user;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSDictionary *availableUsers = [User availableUsers];
    
    if (indexPath.row == availableUsers.count) {
        [[TwitterClient sharedInstance] loginWithCompletion:^(User *user, NSError *error) {
            if (user != nil) {
                // Modally present tweets view
                NSLog(@"Welcome to %@", user.name);
                [tableView reloadData];
                [self.delegate switchUser:user];
            } else {
                // Present error view
            }
        }];
        return;
    }
    
    if (indexPath.row == availableUsers.count + 1) {
        [self.delegate closeAccountManager];
        return;
    }
    
    [self.delegate didSelectAccountRowAtIndexPath:indexPath];
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
