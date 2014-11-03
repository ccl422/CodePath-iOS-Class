//
//  TwitterClient.m
//  Twitter
//
//  Created by Chia-Chi Lin on 10/28/14.
//  Copyright (c) 2014 Chia-Chi Lin. All rights reserved.
//

#import "TwitterClient.h"
#import "Tweet.h"

NSString * const kTwitterConsumerKey = @"iOYzNAWT1I593ZUvIEVdl6wjD";
NSString * const kTwitterConsumerSecret = @"HemMrLbvLjZBsp21CESQfIICjuAOz8U5uPGo2OMREPtObUlsgS";
NSString * const kTwitterBaseUrl = @"https://api.twitter.com";

@interface TwitterClient()

@property (nonatomic, strong) void (^loginCompletion)(User *user, NSError *error);

@end

@implementation TwitterClient

+ (TwitterClient *) sharedInstance {
    static TwitterClient *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:kTwitterBaseUrl] consumerKey:kTwitterConsumerKey consumerSecret:kTwitterConsumerSecret];
        }
    });
    
    return instance;
}

- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion {
    self.loginCompletion = completion;
    
    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"GET" callbackURL:[NSURL URLWithString:@"cptwitterdemo://oauth"] scope:nil success:^(BDBOAuthToken *requestToken) {
        NSLog(@"got the request token!");
        NSURL *authURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token]];
        [[UIApplication sharedApplication] openURL:authURL];
    } failure:^(NSError *error) {
        NSLog(@"Failed to get the request token!");
        self.loginCompletion(nil, error);
    }];

}

- (void)openURL:(NSURL *)url {
    [self fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[BDBOAuthToken tokenWithQueryString:url.query] success:^(BDBOAuthToken *accessToken) {
        NSLog(@"got the access token!");
        [self.requestSerializer saveAccessToken:accessToken];
        
        [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            User *user = [[User alloc] initWithDictionary:responseObject];
            [User setCurrentUser:user];
            NSLog(@"current user: %@", user.name);
            self.loginCompletion(user, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failed getting current user!");
            self.loginCompletion(nil, error);
        }];
    } failure:^(NSError *error) {
        NSLog(@"failed to get the access token!");
    }];
}

- (void)homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion {
    [self GET:@"1.1/statuses/home_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *tweets = [Tweet tweetsWithArray:responseObject];
        completion(tweets, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

- (void)updateWithParams:(NSDictionary *)params completion:(void (^)(Tweet *tweet, NSError *error))completion {
    [self POST:@"1.1/statuses/update.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:responseObject];
        if (completion) {
            completion(tweet, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(nil, error);
        }
    }];
}

- (void)createRetweetWithId:(NSString *)tweetId completion:(void (^)(Tweet *tweet, NSError *error))completion {
    [self POST:[NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", tweetId] parameters:@{@"id":tweetId} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:responseObject];
        if (completion) {
            completion(tweet, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(nil, error);
        }
    }];
}

- (void)deleteRetweetWithId:(NSString *)tweetId completion:(void (^)(Tweet *tweet, NSError *error))completion {
    [self GET:@"1.1/statuses/show.json" parameters:@{@"id":tweetId, @"include_my_retweet":@1} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *retweetId = responseObject[@"current_user_retweet"][@"id_str"];
        [self POST:[NSString stringWithFormat:@"1.1/statuses/destroy/%@.json", retweetId] parameters:@{@"id":retweetId} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            Tweet *tweet = [[Tweet alloc] initWithDictionary:responseObject];
            if (completion) {
                completion(tweet, nil);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (completion) {
                completion(nil, error);
            }
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(nil, error);
        }
    }];
}

- (void)createFavoriteWithParams:(NSDictionary *)params completion:(void (^)(Tweet *tweet, NSError *error))completion {
    [self POST:@"1.1/favorites/create.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:responseObject];
        if (completion) {
            completion(tweet, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(nil, error);
        }
    }];
}

- (void)deleteFavoriteWithParams:(NSDictionary *)params completion:(void (^)(Tweet *tweet, NSError *error))completion {
    [self POST:@"1.1/favorites/destroy.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:responseObject];
        if (completion) {
            completion(tweet, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(nil, error);
        }
    }];
}

@end
