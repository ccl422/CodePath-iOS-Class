//
//  Tweet.m
//  Twitter
//
//  Created by Chia-Chi Lin on 10/28/14.
//  Copyright (c) 2014 Chia-Chi Lin. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.user = [[User alloc] initWithDictionary:dictionary[@"user"]];
        self.text = dictionary[@"text"];
        
        NSString *createdAtString = dictionary[@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
        
        self.createdAt = [formatter dateFromString:createdAtString];
        
        self.retweetCount = [dictionary[@"retweet_count"] integerValue];
        self.retweeted = [dictionary[@"retweeted"] isEqual:@1];
        self.favouritesCount = [dictionary[@"favorite_count"] integerValue];
        self.favorited = [dictionary[@"favorited"] isEqual:@1];
        
        self.id = dictionary[@"id_str"];
    }
    
    return self;
}

- (id)initWithText:(NSString *)text createdAt:(NSDate *)createdAt user:(User *)user {
    self = [super init];
    if (self) {
        self.user = user;
        self.text = text;
        self.createdAt = createdAt;
        self.retweetCount = 0;
        self.retweeted = NO;
        self.favouritesCount = 0;
        self.favorited = NO;
        self.id = @"";
    }
    
    return self;
}

+ (NSArray *)tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [NSMutableArray array];
    
    for (NSDictionary *dictionary in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:dictionary]];
    }
    
    return tweets;
}

@end
