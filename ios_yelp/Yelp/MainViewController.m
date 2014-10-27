//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "YelpClient.h"
#import "ResultCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "FiltersViewController.h"

NSString * const kYelpConsumerKey = @"TPydobXGP_JqlB7VNohE5Q";
NSString * const kYelpConsumerSecret = @"ais4Ypj3UFiTvI3MpP-ngZJCzgs";
NSString * const kYelpToken = @"tsOdhBvh3SaFj3BiHoVxPMnZOcCn4xuU";
NSString * const kYelpTokenSecret = @"38WrN8hYKP5WemxeQSojBOe907g";

@interface MainViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, FiltersViewDelegate>

@property (nonatomic, strong) YelpClient *client;
@property (nonatomic, strong) NSString *searchTerm;
@property (nonatomic, strong) NSDictionary *searchResults;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) FiltersViewController *filtersVC;
@property (nonatomic, strong) UINavigationController *filtersNVC;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
        self.searchTerm = @"";
        [self searchYelp];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Set up navigation bar background color
    UIColor *navigationBarBackgroundColor = [UIColor colorWithRed:65.0 / 255.0 green:105.0 / 255.0 blue:225.0 / 255.0 alpha:1.0];
    
    // Set up the Filters button
    UIButton *filtersButton = [UIButton buttonWithType:UIButtonTypeCustom];
    filtersButton.frame = CGRectMake(100, 430, 60, 30);
    [filtersButton setTitle:@"Filters" forState:UIControlStateNormal];
    filtersButton.titleLabel.textColor = [UIColor whiteColor];
    filtersButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
    filtersButton.layer.masksToBounds = NO;
    filtersButton.layer.cornerRadius = 10;
    filtersButton.layer.borderWidth = 0.5;
    filtersButton.layer.borderColor = [UIColor blackColor].CGColor;
    filtersButton.backgroundColor = navigationBarBackgroundColor;
    filtersButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [filtersButton addTarget:self action:@selector(showFilters:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *filtersItem = [[UIBarButtonItem alloc] initWithCustomView:filtersButton];
    [self.navigationItem setLeftBarButtonItem:filtersItem];
    
    // Set up the search bar
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    searchBar.barTintColor = navigationBarBackgroundColor;
    searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    UIView *searchBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    searchBarView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    searchBar.delegate = self;
    [searchBarView addSubview:searchBar];
    self.navigationItem.titleView = searchBarView;
    self.navigationController.navigationBar.autoresizesSubviews = YES;
    
    // Set up the navigation bar
    self.navigationController.navigationBar.barTintColor = navigationBarBackgroundColor;
    self.navigationController.navigationBar.translucent = NO;
    
    // Set up the results table
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"ResultCell" bundle:nil] forCellReuseIdentifier:@"ResultCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    // Set up the FiltersViewController
    self.filtersVC = [[FiltersViewController alloc] init];
    self.filtersNVC = [[UINavigationController alloc] initWithRootViewController:self.filtersVC];
    self.filtersVC.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)showFilters:(id)sender {
    [self presentViewController:self.filtersNVC animated:YES completion:nil];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.searchTerm = searchBar.text;
    [self.filtersVC resetFilters];
    [self searchYelp];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray *)self.searchResults[@"businesses"]).count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *result = self.searchResults[@"businesses"][indexPath.row];
    ResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ResultCell"];
    [cell.photoView setImageWithURL:[NSURL URLWithString:result[@"image_url"]]];
    cell.nameLabel.text = [NSString stringWithFormat:@"%ld. %@", indexPath.row + 1, result[@"name"]];
    cell.nameLabel.preferredMaxLayoutWidth = cell.nameLabel.bounds.size.width;
    cell.distanceLabel.text = [NSString stringWithFormat:@"%0.2f mi", [result[@"distance"] doubleValue] * 0.000621371];
    [cell.ratingView setImageWithURL:[NSURL URLWithString:result[@"rating_img_url"]]];
    cell.reviewLabel.text = [[result[@"review_count"] stringValue] stringByAppendingString:@" Reviews"];
    NSMutableArray *addressArray = [[NSMutableArray alloc] initWithArray:[result valueForKeyPath:@"location.display_address"]];
    [addressArray removeLastObject];
    cell.addressLabel.text = [addressArray componentsJoinedByString:@", "];
    cell.addressLabel.preferredMaxLayoutWidth = cell.addressLabel.bounds.size.width;
    NSMutableArray *categoriesPairsArray = [[NSMutableArray alloc] initWithArray:result[@"categories"]];
    NSMutableArray *categoriesArray = [[NSMutableArray alloc] init];
    for (id pair in categoriesPairsArray) {
        NSMutableArray *pairArray = [[NSMutableArray alloc] initWithArray:pair];
        [categoriesArray addObject:pairArray[0]];
    }
    cell.categoriesLabel.text = [categoriesArray componentsJoinedByString:@", "];
    cell.categoriesLabel.preferredMaxLayoutWidth = cell.categoriesLabel.bounds.size.width;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)searchYelp {
    [self.client searchWithTerm:self.searchTerm sort:self.filtersVC.sortMode categories:self.filtersVC.categories distanceInMeters:self.filtersVC.distanceInMeters deal:self.filtersVC.deal success:^(AFHTTPRequestOperation *operation, id response) {
        self.searchResults = response;
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
}

- (void)applyFilters:(FiltersViewController *)filtersViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.tableView reloadData];
    [self searchYelp];
}

- (void)cancelFilters:(FiltersViewController *)filtersViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.tableView reloadData];
}

@end
