//
//  DealCell.h
//  Yelp
//
//  Created by Chia-Chi Lin on 10/25/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SevenSwitch.h>

@protocol DealCellDelegate;

@interface DealCell : UITableViewCell

@property (strong, nonatomic) SevenSwitch *dealSwitch;
@property (weak) id<DealCellDelegate> delegate;

@end

@protocol DealCellDelegate <NSObject>

- (void)dealSwitchChanged:(BOOL)isOn;

@end
