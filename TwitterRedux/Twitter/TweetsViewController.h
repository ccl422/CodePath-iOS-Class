//
//  TweetsViewController.h
//  Twitter
//
//  Created by Chia-Chi Lin on 10/29/14.
//  Copyright (c) 2014 Chia-Chi Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TweetsViewStyle) {
    TweetsViewStyleHome,
    TweetsViewStyleMentions
};

@interface TweetsViewController : UIViewController

- (id)init;
- (id)initWithStyle:(TweetsViewStyle)style;

@end
