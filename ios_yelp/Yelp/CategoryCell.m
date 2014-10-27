//
//  CategoryCell.m
//  Yelp
//
//  Created by Chia-Chi Lin on 10/25/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "CategoryCell.h"

@implementation CategoryCell

- (void)awakeFromNib {
    // Initialization code
    self.categorySwitch = [[SevenSwitch alloc] init];
    self.categorySwitch.thumbImage = [UIImage imageNamed:@"facebook-icon.png"];
    self.categorySwitch.onLabel.text = @"On";
    self.categorySwitch.offLabel.text = @"Off";
    [self.categorySwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self.contentView addSubview:self.categorySwitch];
    self.categorySwitch.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *viewsDictionary = @{@"categoryLabel": self.categoryLabel, @"categorySwitch":self.categorySwitch};
    NSDictionary *metrics = @{@"width": @64, @"height": @32};
    NSArray *constraint_POS_V_TOP = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-14-[categorySwitch]" options:0 metrics:nil views:viewsDictionary];
    NSArray *constraint_POS_V_BOT = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[categorySwitch]-14-|" options:0 metrics:nil views:viewsDictionary];
    NSArray *constraint_POS_H_LEFT = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[categoryLabel]-8-[categorySwitch]" options:0 metrics:nil views:viewsDictionary];
    NSArray *constraint_POS_H_RIGHT = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[categorySwitch]-8-|" options:0 metrics:nil views:viewsDictionary];
    NSArray *constraint_HEIGHT = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[categorySwitch(height)]" options:0 metrics:metrics views:viewsDictionary];
    NSArray *constraint_WIDTH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[categorySwitch(width)]" options:0 metrics:metrics views:viewsDictionary];
    [self.contentView addConstraints:constraint_POS_V_TOP];
    [self.contentView addConstraints:constraint_POS_V_BOT];
    [self.contentView addConstraints:constraint_POS_H_LEFT];
    [self.contentView addConstraints:constraint_POS_H_RIGHT];
    [self.contentView addConstraints:constraint_HEIGHT];
    [self.contentView addConstraints:constraint_WIDTH];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)switchChanged:(id)sender {
    [self.delegate categorySwitchChanged:[self.categorySwitch isOn] value:self.categoryValue];
}

@end
