//
//  MenuViewController.h
//  Twitter
//
//  Created by Chia-Chi Lin on 11/5/14.
//  Copyright (c) 2014 Chia-Chi Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuViewDelegate;

@interface MenuViewController : UIViewController

@property (weak) id <MenuViewDelegate> delegate;

- (void)resetUser;

@end

@protocol MenuViewDelegate <NSObject>

- (void)didSelectMenuRowAtIndexPath:(NSIndexPath *)indexPath;

@end
