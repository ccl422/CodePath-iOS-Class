//
//  ProfileViewController.h
//  Twitter
//
//  Created by Chia-Chi Lin on 11/6/14.
//  Copyright (c) 2014 Chia-Chi Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

typedef NS_ENUM(NSInteger, ProfileViewStyle) {
    ProfileViewStyleLogout,
    ProfileViewStyleDone
};

@interface ProfileViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *profileHeaderView;

- (id)init;
- (id)initWithUser:(User *)user withStyle:(ProfileViewStyle)style;

@end
