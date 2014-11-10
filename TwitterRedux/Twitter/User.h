//
//  User.h
//  Twitter
//
//  Created by Chia-Chi Lin on 10/28/14.
//  Copyright (c) 2014 Chia-Chi Lin. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const UserDidLoginNotification;
extern NSString * const UserDidLogoutNotification;

@interface User : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenname;
@property (nonatomic, strong) NSString *profileImageUrl;
@property (nonatomic, strong) NSString *tagline;
@property (nonatomic, strong) NSString *profileBackgroudImageUrl;
@property (nonatomic) NSInteger statusesCount;
@property (nonatomic) NSInteger friendsCount;
@property (nonatomic) NSInteger followersCount;
@property (nonatomic, strong) NSDictionary *dictionary;

- (id)initWithDictionary:(NSDictionary *)dictionary;

+ (User *)currentUser;
+ (void)setCurrentUser:(User *)currentUser;

+ (NSMutableDictionary *)availableUsers;
+ (void)insertUser:(User *)user;
+ (void)deleteUser:(User *)user;

+ (void)logout;

@end
