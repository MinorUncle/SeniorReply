//
//  StatusTool.m
//  健康助手
//
//  Created by apple on 13-10-30.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "StatusTool.h"
#import "HttpTool.h"
#import "AccountTool.h"
#import "Status.h"
#import "Comment.h"

@implementation StatusTool
+ (void)statusesWithSinceId:(long long)sinceId maxId:(long long)maxId success:(StatusSuccessBlock)success failure:(StatusFailureBlock)failure
{
    [HttpTool getWithPath:@"2/statuses/home_timeline.json" params:@{
        @"count" : @50,
        @"since_id" : @(sinceId),
        @"max_id" : @(maxId)
     } success:^(id JSON) {
        if (success == nil) return;
        
         NSMutableArray *statuses = [NSMutableArray array];
        
        // 解析json对象
         NSArray *array = JSON[@"statuses"];
         for (NSDictionary *dict in array) {
             Status *s = [[Status alloc] initWithDict:dict];
             [statuses addObject:s];
         }
         
         // 回调block
         success(statuses);
     } failure:^(NSError *error) {
         if (failure == nil) return;
         
         failure(error);
     }];
}

+ (void)commentsWithSinceId:(long long)sinceId maxId:(long long)maxId statusId:(long long)statusId success:(CommentsSuccessBlock)success failure:(CommentsFailureBlock)failure
{
    [HttpTool getWithPath:@"2/comments/show.json" params:@{
     @"id" : @(statusId),
     @"since_id" : @(sinceId),
     @"max_id" : @(maxId),
     @"count" : @20
     } success:^(id JSON) {
         if (success == nil) return;
         
         // JSON数组（装着所有的评论）
         NSArray *array = JSON[@"comments"];
         
         NSMutableArray *comments = [NSMutableArray array];
         
         for (NSDictionary *dict in array) {
             Comment *c = [[Comment alloc] initWithDict:dict];
             [comments addObject:c];
         }
         
         success(comments, [JSON[@"total_number"] intValue], [JSON[@"next_cursor"] longLongValue]);
         
     } failure:^(NSError *error) {
         if (failure == nil) return;
         
         failure(error);
     }];
}

+ (void)repostsWithSinceId:(long long)sinceId maxId:(long long)maxId statusId:(long long)statusId success:(RepostsSuccessBlock)success failure:(RepostsFailureBlock)failure
{
    [HttpTool getWithPath:@"2/statuses/repost_timeline.json" params:@{
     @"id" : @(statusId),
     @"since_id" : @(sinceId),
     @"max_id" : @(maxId),
     @"count" : @20
     } success:^(id JSON) {
         if (success == nil) return;
         
         NSArray *array = JSON[@"reposts"];
         
         NSMutableArray *reposts = [NSMutableArray array];
         
         for (NSDictionary *dict in array) {
             Status *r = [[Status alloc] initWithDict:dict];
             [reposts addObject:r];
         }
         
         success(reposts, [JSON[@"total_number"] intValue], [JSON[@"next_cursor"] longLongValue]);
     } failure:^(NSError *error) {
         if (failure == nil) return;
         
         failure(error);
     }];
}

+ (void)statusWithId:(long long)ID success:(SingleStatusSuccessBlock)success failure:(SingleStatusFailureBlock)failure
{
    [HttpTool getWithPath:@"2/statuses/show.json" params:@{
     @"id" : @(ID),
     } success:^(id JSON) {
         if (success == nil) return;
         
         Status *s = [[Status alloc] initWithDict:JSON];
         
         success(s);
         
     } failure:^(NSError *error) {
         if (failure == nil) return;
         
         failure(error);
     }];
}
@end
