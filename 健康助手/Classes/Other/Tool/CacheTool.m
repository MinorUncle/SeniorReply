//
//  CacheTool.m
//  健康助手
//
//  Created by 未成年大叔 on 15/8/5.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "CacheTool.h"
#import "SDImageCache.h"

@implementation CacheTool

+(float)fileSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size/1024.0/1024.0;
    }
    return 0;
}
+(void)clearImageCache
{
    [[SDImageCache sharedImageCache] clearDisk];
}

+(float)imageCache
{
    return [[SDImageCache sharedImageCache]getSize]/1024.0/1024.0;
}
+(float)folderSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    float folderSize =0.0;
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            folderSize +=[self fileSizeAtPath:absolutePath];
        }
//        //SDWebImage框架自身计算缓存的实现
//        folderSize+=[[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
        return folderSize;
    }
    return 0;
}
+(void)clearFileWithName:(NSString*)fileName
{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSError* err;
    if(![fileManager removeItemAtPath:fileName error:&err])NSLog(@"%@文件删除失败 %@",fileName,err);
}
+(BOOL)strInArry:(NSArray*)arry str:(NSString*)str
{
    for (NSString* i in arry) {
        if ([str isEqualToString:i]) {
            return YES;
        }
    }
    return NO;
}

+(void)clearCacheWithPath:(NSString *)path fliter:(NSArray*)fiter{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
          //  //如有需要，加入条件，过滤掉不想删除的文件
            if([self strInArry:fiter str:fileName])continue;
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            NSError* err;
            if(![fileManager removeItemAtPath:absolutePath error:&err])NSLog(@"%@文件删除失败 %@",absolutePath,err);
        }
    }
    //[[SDImageCache sharedImageCache] cleanDisk];
}
@end
