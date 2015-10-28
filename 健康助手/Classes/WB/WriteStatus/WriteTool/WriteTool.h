//
//  WriteTool.h
//  健康助手
//
//  Created by 未成年大叔 on 15/7/23.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Status.h"

@interface WriteTool : NSObject

typedef void (^ WriteFailureBlock)(NSError* er);
typedef void (^ WriteSuccessBlock)(Status* sta);

+(void)sendStatusWithArticle:(NSString*)status permission:(int)permission success:(WriteSuccessBlock)success failure:(WriteFailureBlock)failure;
@end
