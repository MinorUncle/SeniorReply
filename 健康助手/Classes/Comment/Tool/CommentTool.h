//
//  CommentTool.h
//  健康助手
//
//  Created by 未成年大叔 on 15/7/23.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "Status.h"
#import <Foundation/Foundation.h>

typedef void (^ CommetsFailureBlock)(Status* json);
typedef void (^ CommetsSuccessBlock)(Status* json);



@interface CommentTool : NSObject
+(void)sendCommentWith:(long long)ID comment:(NSString*)comment success:(CommetsSuccessBlock)success failure:(CommetsFailureBlock)failure;

@end
