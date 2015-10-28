//
//  BaseStatusCell.h
//  健康助手
//
//  Created by apple on 13-11-5.
//  Copyright (c) 2013年 itcast. All rights reserved.
//  

#import "BaseWordCell.h"

@class BaseStatusCellFrame;
@interface BaseStatusCell : BaseWordCell
{
    UIImageView *_retweeted; // 被转发数据的父控件
}
@property (nonatomic, strong) BaseStatusCellFrame *cellFrame;
@end