//
//  Status.h
//  健康助手
//
//  Created by apple on 13-10-30.
//  Copyright (c) 2013年 itcast. All rights reserved.
//  数据

#import "BaseText.h"
@interface Status : BaseText
@property (nonatomic, strong) NSArray *picUrls; // 数据配图
@property (nonatomic, strong) Status *retweetedStatus; // 被转发的数据
@property (nonatomic, assign) int repostsCount; // 转发数
@property (nonatomic, assign) int commentsCount; // 评论数
@property (nonatomic, assign) int attitudesCount; // 表态数(被赞)
@property (nonatomic, copy) NSString *source; // 数据来源
@end