//
//  Tweet.h
//  Twitter
//
//  Created by Chia-Chi Lin on 10/28/14.
//  Copyright (c) 2014 Chia-Chi Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) User *user;
@property (nonatomic) NSInteger retweetCount;
@property (nonatomic) BOOL retweeted;
@property (nonatomic) NSInteger favouritesCount;
@property (nonatomic) BOOL favorited;
@property (nonatomic, strong) NSString *id;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (id)initWithText:(NSString *)text createdAt:(NSDate *)createdAt user:(User *)user;

+ (NSArray *)tweetsWithArray:(NSArray *)array;

@end
