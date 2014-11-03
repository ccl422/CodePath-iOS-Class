//
//  UpdateViewController.h
//  Twitter
//
//  Created by Chia-Chi Lin on 11/1/14.
//  Copyright (c) 2014 Chia-Chi Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Tweet.h"

@protocol UpdateViewDelegate;

@interface UpdateViewController : UIViewController

@property (strong, nonatomic) User *currentUser;
@property (weak) id <UpdateViewDelegate> delegate;
@property (strong, nonatomic) NSString *inReplyScreenName;
@property (strong, nonatomic) NSString *inReplyId;

@end

@protocol UpdateViewDelegate <NSObject>

- (void)cancelUpdate:(UpdateViewController *)vc;
- (void)sendUpdate:(UpdateViewController *)vc withStatus:(Tweet *)tweet;
- (void)sendUpdate:(UpdateViewController *)vc withStatus:(Tweet *)tweet inReplyId:(NSString *)inReplyId;

@end