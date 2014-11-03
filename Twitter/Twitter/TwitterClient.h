//
//  TwitterClient.h
//  Twitter
//
//  Created by Chia-Chi Lin on 10/28/14.
//  Copyright (c) 2014 Chia-Chi Lin. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "User.h"
#import "Tweet.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *) sharedInstance;

- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion;
- (void)openURL:(NSURL *)url;

- (void)homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion;

- (void)updateWithParams:(NSDictionary *)params completion:(void (^)(Tweet *tweet, NSError *error))completion;

- (void)createRetweetWithId:(NSString *)tweetId completion:(void (^)(Tweet *tweet, NSError *error))completion;
- (void)deleteRetweetWithId:(NSString *)tweetId completion:(void (^)(Tweet *tweet, NSError *error))completion;

- (void)createFavoriteWithParams:(NSDictionary *)params completion:(void (^)(Tweet *tweet, NSError *error))completion;
- (void)deleteFavoriteWithParams:(NSDictionary *)params completion:(void (^)(Tweet *tweet, NSError *error))completion;

@end
