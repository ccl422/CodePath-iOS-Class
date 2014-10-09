//
//  SettingsViewController.m
//  tipcalculator
//
//  Created by Chia-Chi Lin on 10/9/14.
//  Copyright (c) 2014 Chia-Chi Lin. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *defaultTipControl;

- (IBAction)onTap:(id)sender;
- (void)loadDefaults;

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Settings";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaults];
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

- (IBAction)onTap:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:self.defaultTipControl.selectedSegmentIndex forKey:@"defaultTipSelectedIndex"];
    [defaults synchronize];
}

- (void)loadDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger defaultTipSelectedIndex = [defaults integerForKey:@"defaultTipSelectedIndex"];
    self.defaultTipControl.selectedSegmentIndex = defaultTipSelectedIndex;
}
@end
