//
//  BaseStatusCell.m
//  健康助手
//
//  Created by apple on 13-11-5.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "BaseStatusCell.h"
#import "IconView.h"
#import "UIImage+MJ.h"
#import "ImageListView.h"
#import "BaseStatusCellFrame.h"
#import "Status.h"
#import "User.h"

@interface BaseStatusCell()
{
    UILabel *_source; // 来源
    ImageListView *_image; // 配图
    
    UILabel *_retweetedScreenName; // 被转发数据作者的昵称
    UILabel *_retweetedText; // 被转发数据的内容
    ImageListView *_retweetedImage; // 被转发数据的配图
}
@end

@implementation BaseStatusCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 1.添加数据本身的子控件
        [self addAllSubviews];
        
        // 2.添加被转发数据的子控件
        [self addReweetedAllSubviews];
        
        // 3.设置背景
        [self setBg];
    }
    return self;
}

#pragma mark 设置背景
- (void)setBg
{
    // 1.默认背景
    _bg.image = [UIImage resizedImage:@"common_card_background.png"];
    
    // 2.长按背景
    _selectedBg.image = [UIImage resizedImage:@"common_card_background_highlighted.png"];
}

- (void)setFrame:(CGRect)frame
{
    frame.origin.x = kTableBorderWidth;
    frame.size.width -= kTableBorderWidth * 2;
    frame.origin.y += kTableBorderWidth;
    frame.size.height -= kCellMargin;
    
    [super setFrame:frame];
}

#pragma mark 添加数据本身的子控件
- (void)addAllSubviews
{
    // 1.来源
    _source = [[UILabel alloc] init];
    _source.font = kSourceFont;
    _source.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_source];
    
    // 2.配图
    _image = [[ImageListView alloc] init];
    [self.contentView addSubview:_image];
}

#pragma mark 被转发数据的子控件
- (void)addReweetedAllSubviews
{
    // 1.被转发数据的父控件
    _retweeted = [[UIImageView alloc] init];
    _retweeted.image = [UIImage resizedImage:@"timeline_retweet_background.png" xPos:0.9 yPos:0.5];
    _retweeted.userInteractionEnabled = YES;
    [self.contentView addSubview:_retweeted];
    
    // 2.被转发数据的昵称
    _retweetedScreenName = [[UILabel alloc] init];
    _retweetedScreenName.font = kRetweetedScreenNameFont;
    _retweetedScreenName.textColor = kRetweetedScreenNameColor;
    _retweetedScreenName.backgroundColor = [UIColor clearColor];
    [_retweeted addSubview:_retweetedScreenName];
    
    // 3.被转发数据的内容
    _retweetedText = [[UILabel alloc] init];
    _retweetedText.numberOfLines = 0;
    _retweetedText.font = kRetweetedTextFont;
    _retweetedText.backgroundColor = [UIColor clearColor];
    [_retweeted addSubview:_retweetedText];
    
    // 4.被转发数据的配图
    _retweetedImage = [[ImageListView alloc] init];
    [_retweeted addSubview:_retweetedImage];
}

- (void)setCellFrame:(BaseStatusCellFrame *)cellFrame
{
    _cellFrame = cellFrame;
    
    Status *s = cellFrame.status;
    
    // 1.头像
    _icon.frame = cellFrame.iconFrame;
    [_icon setUser:s.user type:kIconTypeSmall];
    
    // 2.昵称
    _screenName.frame = cellFrame.screenNameFrame;
    _screenName.text = s.user.screenName;
    // 判断是不是会员
    if (s.user.mbtype == kMBTypeNone) {
        _screenName.textColor = kScreenNameColor;
        _mbIcon.hidden = YES;
    } else {
        _screenName.textColor = kMBScreenNameColor;
        _mbIcon.hidden = NO;
        _mbIcon.frame = cellFrame.mbIconFrame;
    }
    
    // 3.时间
    _time.text = s.createdAt;
    CGFloat timeX = cellFrame.screenNameFrame.origin.x;
    CGFloat timeY = CGRectGetMaxY(cellFrame.screenNameFrame) + kCellBorderWidth;
    CGSize timeSize = [_time.text sizeWithFont:kTimeFont];
    _time.frame = (CGRect){{timeX, timeY}, timeSize};
    
    // 4.来源
    _source.text = s.source;
    CGFloat sourceX = CGRectGetMaxX(_time.frame) + kCellBorderWidth;
    CGFloat sourceY = timeY;
    CGSize sourceSize = [_source.text sizeWithFont:kSourceFont];
    _source.frame = (CGRect) {{sourceX, sourceY}, sourceSize};
    
    // 5.内容
    _text.frame = cellFrame.textFrame;
    _text.text = s.text;
    
    // 6.配图
    if (s.picUrls.count) {
        _image.hidden = NO;
        _image.frame = cellFrame.imageFrame;
        _image.imageUrls = s.picUrls;
    } else {
        _image.hidden = YES;
    }
    
    // 7.被转发数据
    if (s.retweetedStatus) {
        _retweeted.hidden = NO;
        
        _retweeted.frame = cellFrame.retweetedFrame;
        
        // 8.昵称
        _retweetedScreenName.frame = cellFrame.retweetedScreenNameFrame;
        _retweetedScreenName.text = [NSString stringWithFormat:@"@%@", s.retweetedStatus.user.screenName];
        
        // 9.内容
        _retweetedText.frame = cellFrame.retweetedTextFrame;
        _retweetedText.text = s.retweetedStatus.text;
        
        // 10.配图
        if (s.retweetedStatus.picUrls.count) {
            _retweetedImage.hidden = NO;
            
            _retweetedImage.frame = cellFrame.retweetedImageFrame;
            
            _retweetedImage.imageUrls = s.retweetedStatus.picUrls;
        } else {
            _retweetedImage.hidden = YES;
        }
    } else {
        _retweeted.hidden = YES;
    }
}
@end
