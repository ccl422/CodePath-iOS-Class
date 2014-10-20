//
//  MoviesViewController.m
//  rottenTomatoesDemo
//
//  Created by Chia-Chi Lin on 10/14/14.
//  Copyright (c) 2014 Chia-Chi Lin. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "MovieDetailViewController.h"
#import "SVProgressHUD.h"

@interface MoviesViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sourceControl;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSArray *movies;
@property (nonatomic, strong) NSMutableArray *filteredMovies;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.errorLabel.hidden = YES;
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    self.filteredMovies = [NSMutableArray arrayWithCapacity:20];
    UITableViewController *searchResultsController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    searchResultsController.tableView.delegate = self;
    searchResultsController.tableView.dataSource = self;
    self.definesPresentationContext = YES;
    [searchResultsController.tableView registerNib:[UINib nibWithNibName:@"MovieCell" bundle:nil] forCellReuseIdentifier:@"MovieCell"];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:searchResultsController];
    self.searchController.searchResultsUpdater = self;
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 100;
    self.title = @"Movies";
    [self.tableView registerNib:[UINib nibWithNibName:@"MovieCell" bundle:nil] forCellReuseIdentifier:@"MovieCell"];
    [self onRefresh];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == ((UITableViewController *)self.searchController.searchResultsController).tableView) {
        return self.filteredMovies.count;
    } else {
        return self.movies.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    NSDictionary *movie;
    if (tableView == ((UITableViewController *)self.searchController.searchResultsController).tableView) {
        //movie = self.filteredMovies[indexPath.row];
        MovieCell *cell = [[MovieCell alloc] init];
        cell.titleLabel.text = @"hello";
        return cell;
    } else {
        movie = self.movies[indexPath.row];
    }
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"synopsis"];
    NSString *posterUrl = [movie valueForKeyPath:@"posters.thumbnail"];
    [cell.posterView setImageWithURL:[NSURL URLWithString:posterUrl]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MovieDetailViewController *vc = [[MovieDetailViewController alloc] init];
    vc.movie = self.movies[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onValueChange:(id)sender {
    [self onRefresh];
}

- (void)onRefresh {
    NSArray *urlValues = @[@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=628w6h33cw7em48bm4hpdk2p&limit=20&country=us", @"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=628w6h33cw7em48bm4hpdk2p&limit=20&country=us"];
    NSURL *url = [NSURL URLWithString:urlValues[self.sourceControl.selectedSegmentIndex]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
    self.errorLabel.hidden = YES;
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data != nil) {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            self.movies = responseDictionary[@"movies"];
            [self.tableView reloadData];
        } else {
            self.errorLabel.hidden = NO;
        }
        [SVProgressHUD popActivity];
        [self.refreshControl endRefreshing];
    }];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = self.searchController.searchBar.text;
    [self updateFilteredMoviesForTitle:searchString];
    [((UITableViewController*)self.searchController.searchResultsController).tableView reloadData];
}

- (void)updateFilteredMoviesForTitle:(NSString *)title {
    if ((title == nil) || (title.length == 0)) {
        self.filteredMovies = self.movies.mutableCopy;
        return;
    }
    
    [self.filteredMovies removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.title contains[c] %@",title];
    self.filteredMovies = [NSMutableArray arrayWithArray:[self.movies filteredArrayUsingPredicate:predicate]];
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