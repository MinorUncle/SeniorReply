//
//  BaseWordCell.h
//  健康助手
//
//  Created by apple on 13-11-6.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "BaseCell.h"
@class IconView;
@interface BaseWordCell : BaseCell
{
    IconView *_icon; // 头像
    UILabel *_screenName; // 昵称
    UIImageView *_mbIcon; // 会员图标
    UILabel *_text; // 内容
    UILabel *_time; // 时间
}
@end
