//
//  ProfileDescriptionViewController.h
//  Twitter
//
//  Created by Chia-Chi Lin on 11/7/14.
//  Copyright (c) 2014 Chia-Chi Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface ProfileDescriptionViewController : UIViewController

@property (strong, nonatomic) User *user;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@end
