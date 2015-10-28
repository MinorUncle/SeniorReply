//
//  bHttpTool.h
//  健康助手
//
//  Created by 未成年大叔 on 15/7/23.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UIImage,UIImageView;

typedef void (^bHttpSuccessBlock)(id JSON);
typedef void (^bHttpFailureBlock)(NSError *error);

@interface bHttpTool : NSObject

//-(void)request: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg;

+ (void)getWithPath:(NSString *)path params:(NSDictionary *)params appkey:(NSString*)key success:(bHttpSuccessBlock)success failure:(bHttpFailureBlock)failure;

+ (void)postWithPath:(NSString *)path params:(NSDictionary *)params appkey:(NSString*)key success:(bHttpSuccessBlock)success failure:(bHttpFailureBlock)failure;

+ (void)downloadImage:(NSString *)url place:(UIImage *)place imageView:(UIImageView *)imageView;
@end