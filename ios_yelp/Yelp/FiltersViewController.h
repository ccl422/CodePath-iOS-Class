//
//  FiltersViewController.h
//  Yelp
//
//  Created by Chia-Chi Lin on 10/23/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FiltersViewDelegate;

@interface FiltersViewController : UIViewController

@property (nonatomic) double distanceInMeters;
@property (nonatomic) NSInteger sortMode;
@property (nonatomic) BOOL deal;
@property (strong, nonatomic) NSMutableArray *categories;
@property (weak) id <FiltersViewDelegate> delegate;

- (void)resetFilters;

@end

@protocol FiltersViewDelegate <NSObject>

- (void)applyFilters:(FiltersViewController *)filtersViewController;
- (void)cancelFilters:(FiltersViewController *)filtersViewController;

@end