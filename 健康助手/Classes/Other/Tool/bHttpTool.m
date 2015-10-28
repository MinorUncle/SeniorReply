//
//  bHttpTool.m
//  健康助手
//
//  Created by 未成年大叔 on 15/7/23.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "bHttpTool.h"
#import "HttpTool.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "Healthcfg.h"
#import "AccountTool.h"
#import <MapKit/MapKit.h>
#import "ConnentTool.h"

@implementation bHttpTool

+ (void)requestWithPath:(NSString *)path params:(NSDictionary *)params success:(bHttpSuccessBlock)success failure:(bHttpFailureBlock)failure method:(NSString *)method appkey:(NSString*)key
{
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:bBaseURL]];
    
    NSMutableDictionary *allParams = [NSMutableDictionary dictionary];
    // 拼接传进来的参数
    if (params) {
        [allParams setDictionary:params];
    }
    
    // 拼接token参数
    
//        [allParams setObject:bAppKey forKey:@"apikey"];
    
    [client setDefaultHeader:@"apix-key" value:key];
    NSURLRequest *post = [client requestWithMethod:method path:path parameters:allParams];
    
    
    
        // 2.创建AFJSONRequestOperation对象
        NSOperation *op = [AFJSONRequestOperation JSONRequestOperationWithRequest:post
                                                                          success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                              
                                                                              if (success == nil) return;
                                                                              success(JSON);
                                                                          }
                                                                         failure : ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                             if (failure == nil) return;
                                                                             
                                                                             failure(error);
                                                                         }];
        
        
        
        
        
        // 3.发送请求
        [op start];

}

+ (void)postWithPath:(NSString *)path params:(NSDictionary *)params appkey:(NSString*)key success:(bHttpSuccessBlock)success failure:(bHttpFailureBlock)failure
{
    [self requestWithPath:path params:params success:success failure:failure method:@"POST" appkey:key];
}

+ (void)getWithPath:(NSString *)path params:(NSDictionary *)params appkey:(NSString*)key success:(bHttpSuccessBlock)success failure:(bHttpFailureBlock)failure
{
    [self requestWithPath:path params:params success:success failure:failure method:@"GET" appkey:key];
}

+ (void)downloadImage:(NSString *)url place:(UIImage *)place imageView:(UIImageView *)imageView
{
    if([ConnentTool sharedConnentTool].mainScanType == kscanTypeNoImage)
    {
        imageView.image = place;
        return;
    }
    [imageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:place options:SDWebImageLowPriority];
    
}
@end
