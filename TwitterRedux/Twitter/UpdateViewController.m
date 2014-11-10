//
//  UpdateViewController.m
//  Twitter
//
//  Created by Chia-Chi Lin on 11/1/14.
//  Copyright (c) 2014 Chia-Chi Lin. All rights reserved.
//

#import "UpdateViewController.h"
#import <UIImageView+AFNetworking.h>
#import "TwitterClient.h"

@interface UpdateViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *updateTextView;
@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation UpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    self.titleLabel.textAlignment = NSTextAlignmentRight;
    if (self.inReplyId) {
        self.updateTextView.text = [NSString stringWithFormat:@"@%@ ", self.inReplyScreenName];
        self.titleLabel.text = [NSString stringWithFormat:@"%ld", 140 - self.updateTextView.text.length];
    } else {
        self.titleLabel.text = @"140";
    }
    self.navigationItem.titleView = self.titleLabel;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(onTweet)];
    
    [self.profileImageView setImageWithURL:[NSURL URLWithString:self.currentUser.profileImageUrl]];
    self.nameLabel.text = self.currentUser.name;
    self.screenNameLabel.text = self.currentUser.screenname;
    
    self.updateTextView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onCancel {
    [self.delegate cancelUpdate:self];
}

- (void)onTweet {
    if (self.inReplyId) {
        [self.delegate sendUpdate:self withStatus:[[Tweet alloc] initWithText:self.updateTextView.text createdAt:[NSDate date] user:self.currentUser] inReplyId:self.inReplyId];
    } else {
        [self.delegate sendUpdate:self withStatus:[[Tweet alloc] initWithText:self.updateTextView.text createdAt:[NSDate date] user:self.currentUser]];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return textView.text.length - range.length + text.length <= 140;
}

- (void)textViewDidChange:(UITextView *)textView {
    self.titleLabel.text = [NSString stringWithFormat:@"%ld", 140 - self.updateTextView.text.length];
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
