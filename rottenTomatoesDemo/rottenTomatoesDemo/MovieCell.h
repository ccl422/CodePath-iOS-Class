//
//  MovieCell.h
//  rottenTomatoesDemo
//
//  Created by Chia-Chi Lin on 10/15/14.
//  Copyright (c) 2014 Chia-Chi Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;

@end
