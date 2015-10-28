//
//  CommentTool.m
//  健康助手
//
//  Created by 未成年大叔 on 15/7/23.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "CommentTool.h"
#import "HttpTool.h"

@implementation CommentTool
+(void)sendCommentWith:(long long)ID comment:(NSString*)comment success:(CommetsSuccessBlock)success failure:(CommetsFailureBlock)failure
{
    [HttpTool postWithPath:@"2/statuses/update.json" params:@{@"id":@(ID),
                                                              @"comment":comment} success:^(id JSON) {
                                                                  
                                                              } failure:^(NSError *error) {
                                                                  
                                                              }];
}

@end
