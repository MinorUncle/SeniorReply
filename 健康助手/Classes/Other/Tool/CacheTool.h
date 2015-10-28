//
//  CacheTool.h
//  健康助手
//
//  Created by 未成年大叔 on 15/8/5.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheTool : NSObject
+(float)fileSizeAtPath:(NSString *)path;
+(BOOL)strInArry:(NSArray*)arry str:(NSString*)str;
+(void)clearCacheWithPath:(NSString *)path fliter:(NSArray*)fiter;
+(void)clearFileWithName:(NSString*)fileName;
+(float)folderSizeAtPath:(NSString *)path;
+(float)imageCache;
+(void)clearImageCache;
@end
