//
//  FiltersViewController.m
//  Yelp
//
//  Created by Chia-Chi Lin on 10/23/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "FiltersViewController.h"
#import "DistanceCell.h"
#import "SortCell.h"
#import "DealCell.h"
#import "CategoryCell.h"

@interface FiltersViewController () <UITableViewDelegate, UITableViewDataSource, DealCellDelegate, CategoryCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIColor *backgroundColor;
@property (nonatomic) NSInteger distanceIndex;

@property (strong, nonatomic) NSArray *distanceLabels;
@property (strong, nonatomic) NSArray *distanceValues;
@property (nonatomic) BOOL distanceExpand;
@property (nonatomic) NSInteger distanceIndexBackup;
@property (nonatomic) double distanceInMetersBackup;

@property (strong, nonatomic) NSArray *sortLabels;
@property (nonatomic) BOOL sortExpand;
@property (nonatomic) NSInteger sortModeBackup;

@property (nonatomic) BOOL dealBackup;

@property (strong, nonatomic) NSArray *categoriesLabels;
@property (strong, nonatomic) NSArray *categoriesValues;
@property (nonatomic) BOOL categoriesExpand;
@property (strong, nonatomic) NSMutableArray *categoriesBackup;

@end

@implementation FiltersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    // Reset filters
    [self resetFilters];
    
    // Set up constants
    self.backgroundColor = [UIColor colorWithRed:224.0 / 255.0 green:224.0 / 255.0 blue:224.0 / 255.0 alpha:0.25];
    self.distanceLabels = [[NSArray alloc] initWithObjects:@"Best Match", @"2 blocks", @"6 blocks", @"1 mile", @"5 miles", nil];
    self.distanceValues = [[NSArray alloc] initWithObjects:@0.0, @160.93, @482.80, @1609.34, @8046.72, nil];
    self.sortLabels = [[NSArray alloc] initWithObjects:@"Best Match", @"Distance", @"Rating", nil];
    self.categoriesLabels = [[NSArray alloc] initWithObjects:@"Active Life", @"Arts & Entertainment", @"Automotive", @"Beauty & Spas", @"Bicycles", @"Education", @"Event Planning & Services", @"Financial Services", @"Food", @"Health & Medical", @"Home Services", @"Hotels & Travel", @"Local Flavor", @"Local Services", @"Mass Media", @"Nightlife", @"Pets", @"Professional Services", @"Public Services & Government", @"Real Estate", @"Religious Organizations", @"Restaurants", @"Shopping", nil];
    self.categoriesValues = [[NSArray alloc] initWithObjects:@"active", @"arts", @"auto", @"beautysvc", @"bicycles", @"education", @"eventservices", @"financialservices", @"food", @"health", @"homeservices", @"hotelstravel", @"localflavor", @"localservices", @"massmedia", @"nightlife", @"pets", @"professional", @"publicservicesgovt", @"realestate", @"religiousorgs", @"restaurants", @"shopping", nil];
    
    // Set up the title
    self.title = @"Filters";
    
    // Set up navigation bar background color
    UIColor *navigationBarBackgroundColor = [UIColor colorWithRed:65.0 / 255.0 green:105.0 / 255.0 blue:225.0 / 255.0 alpha:1.0];
    
    // Set up the Cancel button
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(100, 430, 60, 30);
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    cancelButton.titleLabel.textColor = [UIColor whiteColor];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
    cancelButton.layer.masksToBounds = NO;
    cancelButton.layer.cornerRadius = 10;
    cancelButton.layer.borderWidth = 0.5;
    cancelButton.layer.borderColor = [UIColor blackColor].CGColor;
    cancelButton.backgroundColor = navigationBarBackgroundColor;
    cancelButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [cancelButton addTarget:self action:@selector(cancelFilters:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    [self.navigationItem setLeftBarButtonItem:cancelItem];
    
    // Set up the Search button
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(100, 430, 60, 30);
    [searchButton setTitle:@"Search" forState:UIControlStateNormal];
    searchButton.titleLabel.textColor = [UIColor whiteColor];
    searchButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
    searchButton.layer.masksToBounds = NO;
    searchButton.layer.cornerRadius = 10;
    searchButton.layer.borderWidth = 0.5;
    searchButton.layer.borderColor = [UIColor blackColor].CGColor;
    searchButton.backgroundColor = navigationBarBackgroundColor;
    searchButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [searchButton addTarget:self action:@selector(applyFilters:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    [self.navigationItem setRightBarButtonItem:searchItem];
    
    // Set up the navigation bar
    self.navigationController.navigationBar.barTintColor = navigationBarBackgroundColor;
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    // Set up the filters table
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"DistanceCell" bundle:nil] forCellReuseIdentifier:@"DistanceCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SortCell" bundle:nil] forCellReuseIdentifier:@"SortCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DealCell" bundle:nil] forCellReuseIdentifier:@"DealCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CategoryCell" bundle:nil] forCellReuseIdentifier:@"CategoryCell"];
    self.tableView.sectionHeaderHeight = 16;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.distanceExpand = NO;
    self.distanceIndexBackup = self.distanceIndex;
    self.distanceInMetersBackup = self.distanceInMeters;
    
    self.sortExpand = NO;
    self.sortModeBackup = self.sortMode;
    
    self.dealBackup = self.deal;
    
    self.categoriesExpand = NO;
    self.categoriesBackup = [[NSMutableArray alloc] initWithArray:self.categories];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section >= 4) {
        return nil;
    }
    
    UILabel *headerLabel = [[UILabel alloc] init];
    headerLabel.frame = CGRectMake(8, 0, 320, 16);
    headerLabel.font = [UIFont systemFontOfSize:13.0];
    headerLabel.textColor = [UIColor darkGrayColor];
    headerLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    NSArray *titles = @[@"Distance", @"Sort by", @"Exclusively Search for Business with Deals", @"General Features"];
    headerLabel.text = titles[section];
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = self.backgroundColor;
    [headerView addSubview:headerLabel];
    
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (self.distanceExpand) {
            return 5;
        } else {
            return 1;
        }
    }
    
    if (section == 1) {
        if (self.sortExpand) {
            return 3;
        } else {
            return 1;
        }
    }
    
    if (section == 2) {
        return 1;
    }
    
    if (section == 3) {
        if (self.categoriesExpand) {
            return self.categoriesLabels.count;
        } else {
            return 4;
        }
    }
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        DistanceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DistanceCell"];
        
        cell.distanceLabel.backgroundColor = [UIColor whiteColor];
        cell.expandButton.backgroundColor = [UIColor whiteColor];
        //cell.backgroundColor = self.backgroundColor;
        
        if (self.distanceExpand) {
            cell.distanceLabel.text = self.distanceLabels[indexPath.row];
            
            if (indexPath.row == 0) {
                [cell.expandButton setTitle:@"▲" forState:UIControlStateNormal];
                [cell.expandButton addTarget:self action:@selector(distanceExpandButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            } else {
                [cell.expandButton setTitle:@"" forState:UIControlStateNormal];
            }
        } else {
            cell.distanceLabel.text = self.distanceLabels[self.distanceIndex];
            [cell.expandButton setTitle:@"▼" forState:UIControlStateNormal];
            [cell.expandButton addTarget:self action:@selector(distanceExpandButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        return cell;
    }
    
    if (indexPath.section == 1) {
        SortCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SortCell"];
        
        cell.sortLabel.backgroundColor = [UIColor whiteColor];
        cell.expandButton.backgroundColor = [UIColor whiteColor];
        //cell.backgroundColor = self.backgroundColor;
        
        if (self.sortExpand) {
            cell.sortLabel.text = self.sortLabels[indexPath.row];
            
            if (indexPath.row == 0) {
                [cell.expandButton setTitle:@"▲" forState:UIControlStateNormal];
                [cell.expandButton addTarget:self action:@selector(sortExpandButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            } else {
                [cell.expandButton setTitle:@"" forState:UIControlStateNormal];
            }
        } else {
            cell.sortLabel.text = self.sortLabels[self.sortMode];
            [cell.expandButton setTitle:@"▼" forState:UIControlStateNormal];
            [cell.expandButton addTarget:self action:@selector(sortExpandButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        return cell;
    }
    
    if (indexPath.section == 2) {
        DealCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DealCell"];
        [cell.dealSwitch setOn:self.deal];
        cell.delegate = self;
        return cell;
    }
    
    if (indexPath.section == 3) {
        CategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CategoryCell"];
        
        if (!self.categoriesExpand) {
            if (indexPath.row >= 4) {
                return nil;
            }
            
            if (indexPath.row == 3) {
                UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                cell.textLabel.text = @"See All";
                cell.textLabel.font = [UIFont systemFontOfSize:13.0];
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                cell.textLabel.textColor = [UIColor grayColor];
                return cell;
            }
        }
        
        cell.categoryLabel.text = self.categoriesLabels[indexPath.row];
        cell.categoryValue = [NSString stringWithString:self.categoriesValues[indexPath.row]];
        BOOL isOn = NO;
        for (NSString *val in self.categories) {
            if ([val isEqualToString:self.categoriesValues[indexPath.row]]) {
                isOn = YES;
            }
        }
        [cell.categorySwitch setOn:isOn];
        cell.delegate = self;
        
        return cell;
    }
        
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.distanceExpand) {
            self.distanceIndex = indexPath.row;
            self.distanceInMeters = [self.distanceValues[self.distanceIndex] doubleValue];
            self.distanceExpand = NO;
            [self.tableView reloadData];
            return;
        } else {
            [self distanceExpandButtonClicked:self];
            return;
        }
    }
    
    if (indexPath.section == 1) {
        if (self.sortExpand) {
            self.sortMode = indexPath.row;
            self.sortExpand = NO;
            [self.tableView reloadData];
            return;
        } else {
            [self sortExpandButtonClicked:self];
            return;
        }
    }
    
    if (indexPath.section == 3) {
        if (!self.categoriesExpand && indexPath.row == 3) {
            self.categoriesExpand = YES;
            [self.tableView reloadData];
            return;
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (IBAction)applyFilters:(id)sender {
    [[self delegate] applyFilters:self];
}

- (IBAction)cancelFilters:(id)sender {
    self.distanceIndex = self.distanceIndexBackup;
    self.distanceInMeters = self.distanceInMetersBackup;
    
    self.sortMode = self.sortModeBackup;
    
    self.deal = self.dealBackup;
    
    self.categories = [[NSMutableArray alloc] init];
    
    [[self delegate] cancelFilters:self];
}

- (void)resetFilters {
    self.distanceIndex = 0;
    self.distanceInMeters = 0.0;
    
    self.sortMode = 0;
    
    self.deal = NO;
    
    self.categories = [[NSMutableArray alloc] init];
}

- (IBAction)distanceExpandButtonClicked:(id)sender {
    self.distanceExpand = !self.distanceExpand;
    [self.tableView reloadData];
}

- (IBAction)sortExpandButtonClicked:(id)sender {
    self.sortExpand = !self.sortExpand;
    [self.tableView reloadData];
}

- (void)dealSwitchChanged:(BOOL)isOn {
    self.deal = isOn;
}

- (void)categorySwitchChanged:(BOOL)isOn value:(NSString *)value {
    if (isOn) {
        [self.categories addObject:value];
    } else {
        [self.categories removeObject:value];
    }
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
