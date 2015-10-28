//
//  FriendshipTool.h
//  健康助手
//
//  Created by apple on 13-11-6.
//  Copyright (c) 2013年 itcast. All rights reserved.
//
// statues装的都是Status对象
typedef void (^FollowersSuccessBlock)(NSArray *followers);
typedef void (^FollowersFailureBlock)(NSError *error);

typedef void (^FriendsSuccessBlock)(NSArray *friends);
typedef void (^FriendsFailureBlock)(NSError *error);

#import <Foundation/Foundation.h>

@interface FriendshipTool : NSObject
+ (void)followersWithId:(long long )ID success:(FollowersSuccessBlock)success failure:(FollowersFailureBlock)failure;

+ (void)friendsWithId:(long long )ID success:(FriendsSuccessBlock)success failure:(FriendsFailureBlock)failure;
@end
