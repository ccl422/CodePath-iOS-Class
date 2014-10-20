//
//  MovieDetailViewController.m
//  rottenTomatoesDemo
//
//  Created by Chia-Chi Lin on 10/15/14.
//  Copyright (c) 2014 Chia-Chi Lin. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "UIImageView+AFNetworking.h"

@interface MovieDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation MovieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleLabel.text = self.movie[@"title"];
    self.synopsisLabel.text = self.movie[@"synopsis"];
    [self.synopsisLabel sizeToFit];
    NSString *posterUrl = [[self.movie valueForKeyPath:@"posters.thumbnail"] stringByReplacingOccurrencesOfString:@"_tmb.jpg" withString:@"_ori.jpg"];
    [self.posterView setImageWithURL:[NSURL URLWithString:posterUrl]];
    CGFloat scrollViewHeight = 0;
    for (UIView* view in self.scrollView.subviews) {
        scrollViewHeight += view.frame.size.height + 10;
    }
    self.scrollView.contentSize = CGSizeMake(320, scrollViewHeight);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
