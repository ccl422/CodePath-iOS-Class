//
//  YelpClient.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "YelpClient.h"

@implementation YelpClient

- (id)initWithConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret accessToken:(NSString *)accessToken accessSecret:(NSString *)accessSecret {
    NSURL *baseURL = [NSURL URLWithString:@"http://api.yelp.com/v2/"];
    self = [super initWithBaseURL:baseURL consumerKey:consumerKey consumerSecret:consumerSecret];
    if (self) {
        BDBOAuthToken *token = [BDBOAuthToken tokenWithToken:accessToken secret:accessSecret expiration:nil];
        [self.requestSerializer saveAccessToken:token];
    }
    return self;
}

- (AFHTTPRequestOperation *)searchWithTerm:(NSString *)term sort:(NSInteger)sort categories:(NSArray *)categories distanceInMeters:(double)distanceInMeters deal:(BOOL)deal success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:@{@"term": term, @"ll": @"37.7577,-122.4376"}];
    
    [parameters setValue:[NSString stringWithFormat:@"%ld", sort] forKey:@"sort"];
    
    if (distanceInMeters > 0.0) {
        [parameters setValue:[NSString stringWithFormat:@"%0.2f", distanceInMeters] forKey:@"radius_filter"];
    }
    
    if (deal) {
        [parameters setValue:@"1" forKey:@"deals_filter"];
    }
    
    if (categories.count != 0) {
        [parameters setValue:[categories componentsJoinedByString:@","] forKey:@"category_filter"];
    }
    
    return [self GET:@"search" parameters:parameters success:success failure:failure];
}

@end
