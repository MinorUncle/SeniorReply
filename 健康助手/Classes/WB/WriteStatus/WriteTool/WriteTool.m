//
//  WriteTool.m
//  健康助手
//
//  Created by 未成年大叔 on 15/7/23.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "WriteTool.h"
#import "HttpTool.h"
#import "Status.h"
@implementation WriteTool

+(void)sendStatusWithArticle:(NSString*)status permission:(int)permission success:(WriteSuccessBlock)success failure:(WriteFailureBlock)failure
{
    [HttpTool postWithPath:@"2/statuses/update.json" params:@{
                                                              @"status":status,
                                                              @"visible":@(permission)}
     success:^(id JSON) {
         if (success == nil) {
             return ;
         }
         Status* sta =[[Status alloc]initWithDict:JSON];
         success(sta);
                                                                  
                                                              }
     failure:^(NSError *error) {
         failure(error);
                                                              }];
}


@end
