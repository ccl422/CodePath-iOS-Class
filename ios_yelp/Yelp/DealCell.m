//
//  DealCell.m
//  Yelp
//
//  Created by Chia-Chi Lin on 10/25/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "DealCell.h"

@implementation DealCell

- (void)awakeFromNib {
    // Initialization code
    self.dealSwitch = [[SevenSwitch alloc] init];
    self.dealSwitch.thumbImage = [UIImage imageNamed:@"facebook-icon.png"];
    self.dealSwitch.onLabel.text = @"On";
    self.dealSwitch.offLabel.text = @"Off";
    [self.dealSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self.contentView addSubview:self.dealSwitch];
    self.dealSwitch.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *viewsDictionary = @{@"dealSwitch":self.dealSwitch};
    NSDictionary *metrics = @{@"width": @64, @"height": @32};
    NSArray *constraint_POS_V_TOP = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[dealSwitch]" options:0 metrics:nil views:viewsDictionary];
    NSArray *constraint_POS_V_BOT = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[dealSwitch]-8-|" options:0 metrics:nil views:viewsDictionary];
    NSArray *constraint_POS_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[dealSwitch]-8-|" options:0 metrics:nil views:viewsDictionary];
    NSArray *constraint_HEIGHT = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[dealSwitch(height)]" options:0 metrics:metrics views:viewsDictionary];
    NSArray *constraint_WIDTH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[dealSwitch(width)]" options:0 metrics:metrics views:viewsDictionary];
    [self.contentView addConstraints:constraint_POS_V_TOP];
    [self.contentView addConstraints:constraint_POS_V_BOT];
    [self.contentView addConstraints:constraint_POS_H];
    [self.contentView addConstraints:constraint_HEIGHT];
    [self.contentView addConstraints:constraint_WIDTH];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)switchChanged:(id)sender {
    [self.delegate dealSwitchChanged:[self.dealSwitch isOn]];
}

@end
