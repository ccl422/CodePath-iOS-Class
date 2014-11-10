//
//  TweetDetailViewController.h
//  Twitter
//
//  Created by Chia-Chi Lin on 11/2/14.
//  Copyright (c) 2014 Chia-Chi Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "TweetsViewController.h"
#import "UpdateViewController.h"

@interface TweetDetailViewController : UIViewController

@property (strong, nonatomic) Tweet *tweet;
@property (weak, nonatomic) TweetsViewController <UpdateViewDelegate> *vc;

@end
