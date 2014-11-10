//
//  User.m
//  Twitter
//
//  Created by Chia-Chi Lin on 10/28/14.
//  Copyright (c) 2014 Chia-Chi Lin. All rights reserved.
//

#import "User.h"
#import "TwitterClient.h"

NSString * const UserDidLoginNotification = @"UserDidLoginNotification";
NSString * const UserDidLogoutNotification = @"UserDidLogoutNotification";

@interface User()

@end

@implementation User

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.dictionary = dictionary;
        self.name = dictionary[@"name"];
        self.screenname = dictionary[@"screen_name"];
        self.profileImageUrl = dictionary[@"profile_image_url"];
        self.tagline = dictionary[@"description"];
        self.profileBackgroudImageUrl = dictionary[@"profile_background_image_url"];
        self.statusesCount = [dictionary[@"statuses_count"] integerValue];
        self.friendsCount = [dictionary[@"friends_count"] integerValue];
        self.followersCount = [dictionary[@"followers_count"] integerValue];
    }
    
    return self;
}

static User *_currentUser = nil;

NSString * const kCurrentUserKey = @"kCurrentUserKey";

+ (User *)currentUser {
    if (_currentUser == nil) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentUserKey];
        if (data != nil) {
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            _currentUser = [[User alloc] initWithDictionary:dictionary];
        }
    }
    
    return _currentUser;
}

+ (void)setCurrentUser:(User *)currentUser {
    _currentUser = currentUser;
    
    if (_currentUser != nil) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:currentUser.dictionary options:0 error:NULL];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:kCurrentUserKey];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kCurrentUserKey];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

static NSMutableDictionary *_availableUsers = nil;

NSString * const kAvailableUsersKey = @"kAvailableUsersKey";

+ (NSMutableDictionary *)availableUsers {
    if (_availableUsers == nil) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kAvailableUsersKey];
        if (data != nil) {
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            _availableUsers = [[NSMutableDictionary alloc] initWithDictionary:dictionary];
        } else {
            _availableUsers = [[NSMutableDictionary alloc] init];
        }
    }
    
    return _availableUsers;
}

+ (void)insertUser:(User *)user {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithDictionary:user.dictionary];
    [dictionary setValue:[TwitterClient sharedInstance].requestSerializer.accessToken.token forKey:@"access_token"];
    [dictionary setValue:[TwitterClient sharedInstance].requestSerializer.accessToken.secret forKey:@"access_secret"];
    NSMutableDictionary *availableUsers = [self availableUsers];
    [availableUsers setObject:dictionary forKey:user.screenname];
    NSData *data = [NSJSONSerialization dataWithJSONObject:availableUsers options:0 error:NULL];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kAvailableUsersKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)deleteUser:(User *)user {
    NSMutableDictionary *availableUsers = [self availableUsers];
    [availableUsers removeObjectForKey:user.screenname];
    NSData *data = [NSJSONSerialization dataWithJSONObject:availableUsers options:0 error:NULL];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kAvailableUsersKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)logout {
    [User setCurrentUser:nil];
    [[TwitterClient sharedInstance].requestSerializer removeAccessToken];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLoginNotification object:nil];
}

@end
