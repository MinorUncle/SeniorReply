//
//  FriendshipTool.m
//  健康助手
//
//  Created by apple on 13-11-6.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "FriendshipTool.h"
#import "HttpTool.h"
#import "User.h"

@implementation FriendshipTool
+ (void)followersWithId:(long long)ID success:(FollowersSuccessBlock)success failure:(FollowersFailureBlock)failure
{
    [HttpTool getWithPath:@"2/friendships/followers.json" params:@{
     @"uid" : @(ID)
     } success:^(id JSON) {
         if (success == nil) return;
         
         NSArray *array = JSON[@"users"];
         
         NSMutableArray *followers = [NSMutableArray array];
         
         for (NSDictionary *dict in array) {
             User *u = [[User alloc] initWithDict:dict];
             [followers addObject:u];
         }
         
         success(followers);
     } failure:^(NSError *error) {
         if (failure == nil) return;
         
         failure(error);
     }];
}

+ (void)friendsWithId:(long long)ID success:(FriendsSuccessBlock)success failure:(FriendsFailureBlock)failure
{
    [HttpTool getWithPath:@"friendships/friends.json" params:@{
     @"uid" : @(ID)
     } success:^(id JSON) {
         if (success == nil) return;
         
         NSArray *array = JSON[@"users"];
         
         NSMutableArray *followers = [NSMutableArray array];
         
         for (NSDictionary *dict in array) {
             User *u = [[User alloc] initWithDict:dict];
             [followers addObject:u];
         }
         
         success(followers);
     } failure:^(NSError *error) {
         if (failure == nil) return;
         
         failure(error);
     }];
}
@end
