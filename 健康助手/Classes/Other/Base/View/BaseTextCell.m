//
//  BaseTextCell.m
//  健康助手
//
//  Created by apple on 13-11-6.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "BaseTextCell.h"
#import "IconView.h"
#import "BaseText.h"
#import "User.h"
#import "UIImage+MJ.h"
#import "BaseTextCellFrame.h"

@interface BaseTextCell()
@end

@implementation BaseTextCell

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    
    // 1.获得文件名
    int count = [_myTableView numberOfRowsInSection:indexPath.section];
    NSString *bgName = @"statusdetail_comment_background_middle.png";
    NSString *seletcedBgName = @"statusdetail_comment_background_middle_highlighted.png";
    if (count - 1 == indexPath.row) { // 末行
        bgName = @"statusdetail_comment_background_bottom.png";
        seletcedBgName = @"statusdetail_comment_background_bottom_highlighted.png";
    }
    
    // 2.设置背景图片
    _bg.image = [UIImage resizedImage:bgName];
    _selectedBg.image = [UIImage resizedImage:seletcedBgName];
}

- (void)setFrame:(CGRect)frame
{
    frame.origin.x = kTableBorderWidth;
    frame.size.width -= kTableBorderWidth * 2;
    
    [super setFrame:frame];
}

- (void)setCellFrame:(BaseTextCellFrame *)cellFrame
{
    _cellFrame = cellFrame;
    
    BaseText *baseText = cellFrame.baseText;
    
    // 1.头像
    _icon.frame = cellFrame.iconFrame;
    _icon.user = baseText.user;
    
    // 2.昵称
    _screenName.frame = cellFrame.screenNameFrame;
    _screenName.text = baseText.user.screenName;
    
    // 3.判断是不是会员
    if (baseText.user.mbtype == kMBTypeNone) {
        _screenName.textColor = kScreenNameColor;
        _mbIcon.hidden = YES;
    } else {
        _screenName.textColor = kMBScreenNameColor;
        _mbIcon.hidden = NO;
        _mbIcon.frame = cellFrame.mbIconFrame;
    }
    
    // 4.内容
    _text.frame = cellFrame.textFrame;
    _text.text = baseText.text;
    
    // 5.时间
    _time.frame = cellFrame.timeFrame;
    _time.text = baseText.createdAt;
}

@end
