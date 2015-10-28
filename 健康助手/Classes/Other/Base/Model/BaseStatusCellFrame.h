//
//  BaseStatueCellFrame.h
//  健康助手
//
//  Created by apple on 13-11-5.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class Status;
@interface BaseStatusCellFrame : NSObject
{
    CGFloat _cellHeight;
    CGRect _retweetedFrame;
}
@property (nonatomic, strong) Status *status;

@property (nonatomic, readonly) CGFloat cellHeight; // Cell的高度

@property (nonatomic, readonly) CGRect iconFrame; // 头像的frame

@property (nonatomic, readonly) CGRect screenNameFrame; // 昵称
@property (nonatomic, readonly) CGRect mbIconFrame; // 会员头像
@property (nonatomic, readonly) CGRect timeFrame; // 时间
@property (nonatomic, readonly) CGRect sourceFrame; // 来源
@property (nonatomic, readonly) CGRect textFrame; // 内容
@property (nonatomic, readonly) CGRect imageFrame; // 配图

@property (nonatomic, readonly) CGRect retweetedFrame; // 被转发数据的父控件
@property (nonatomic, readonly) CGRect retweetedScreenNameFrame; // 被转发数据作者的昵称
@property (nonatomic, readonly) CGRect retweetedTextFrame; // 被转发数据的内容
@property (nonatomic, readonly) CGRect retweetedImageFrame; // 被转发数据的配图
@end
