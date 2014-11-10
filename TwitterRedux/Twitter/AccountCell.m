//
//  AccountCell.m
//  Twitter
//
//  Created by Chia-Chi Lin on 11/8/14.
//  Copyright (c) 2014 Chia-Chi Lin. All rights reserved.
//

#import "AccountCell.h"
#import "User.h"

@implementation AccountCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onAccountCellPan:(UIPanGestureRecognizer *)sender {
    CGPoint velocity = [sender velocityInView:self.vc.view];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        if (fabsf(velocity.y) < fabsf(velocity.x)) {
            if (velocity.x > 0) {
                if ([self.user.screenname isEqualToString:[User currentUser].screenname]) {
                    NSLog(@"removing current user");
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Removing Current User" message:@"Cannot remove current user." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                    return;
                }
                
                [User deleteUser:self.user];
                [self.vc.tableView reloadData];
            }
        }
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        
    }
}

@end
