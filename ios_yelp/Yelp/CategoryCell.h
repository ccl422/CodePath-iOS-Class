//
//  CategoryCell.h
//  Yelp
//
//  Created by Chia-Chi Lin on 10/25/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SevenSwitch.h>

@protocol CategoryCellDelegate;

@interface CategoryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (strong, nonatomic) SevenSwitch *categorySwitch;
@property (strong, nonatomic) NSString *categoryValue;
@property (weak) id<CategoryCellDelegate> delegate;

@end

@protocol CategoryCellDelegate <NSObject>

- (void)categorySwitchChanged:(BOOL)isOn value:(NSString *)value;

@end