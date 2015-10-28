//
//  IconView.m
//  健康助手
//
//  Created by apple on 13-11-2.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "IconView.h"
#import "User.h"
#import "HttpTool.h"

@interface IconView()
{
    UIImageView *_icon; // 头像图片
    UIImageView *_vertify; // 认证图标
    
    NSString *_placehoder; // 占位图片
}
@end

@implementation IconView

// 任何UIView的init方法内部都会调用initWithFrame:方法
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1.用户头像图片
        UIImageView *icon = [[UIImageView alloc] init];
        [self addSubview:icon];
        _icon = icon;
        
        // 2.右下角的认证图标
        UIImageView *vertify = [[UIImageView alloc] init];
        [self addSubview:vertify];
        _vertify = vertify;
    }
    return self;
}

#pragma mark 同时设置头像的用户和类型
- (void)setUser:(User *)user type:(IconType)type
{
    self.type = type;
    self.user = user;
}

#pragma mark 设置模型数据
- (void)setUser:(User *)user
{
    _user = user;
    
    // 1.设置用户头像图片
    [HttpTool downloadImage:user.profileImageUrl place:[UIImage imageNamed:_placehoder] imageView:_icon];
//    [_icon setImageWithURL:[NSURL URLWithString:user.profileImageUrl] placeholderImage:[UIImage imageNamed:_placehoder] options:SDWebImageLowPriority | SDWebImageRetryFailed];
    
    // 2.设置认证图标
    NSString *verifiedIcon = nil;
    switch (user.verifiedType) {
        case kVerifiedTypeNone: // 没有认证认证
            _vertify.hidden = YES;
            break;
        case kVerifiedTypeDaren: // 数据达人
            verifiedIcon = @"avatar_grassroot.png";
            break;
        case kVerifiedTypePersonal: // 个人
            verifiedIcon = @"avatar_vip.png";
            break;
        default: // 企业认证
            verifiedIcon = @"avatar_enterprise_vip.png";
            break;
    }
    
    // 3.如果有认证，显示图标
    if (verifiedIcon) {
        _vertify.hidden = NO;
        _vertify.image = [UIImage imageNamed:verifiedIcon];
    }
}

#pragma mark 设置图标的类型
- (void)setType:(IconType)type
{
    _type = type;
    
    // 1.判断类型
    CGSize iconSize;
    switch (type) {
        case kIconTypeSmall: // 小图标
            iconSize = CGSizeMake(kIconSmallW, kIconSmallH);
            _placehoder = @"avatar_default_small.png";
            break;
            
        case kIconTypeDefault: // 中图标
            iconSize = CGSizeMake(kIconDefaultW, kIconDefaultH);
            _placehoder = @"avatar_default.png";
            break;
            
        case kIconTypeBig: // 大图标
            iconSize = CGSizeMake(kIconBigW, kIconBigH);
            _placehoder = @"avatar_default_big.png";
            break;
    }
    
    // 2.设置frame
    _icon.frame = (CGRect){CGPointZero, iconSize};
    _vertify.bounds = CGRectMake(0, 0, kVertifyW, kVertifyH);
    _vertify.center = CGPointMake(iconSize.width, iconSize.height);
    
    // 3.自己的宽高
    CGFloat width = iconSize.width + kVertifyW * 0.5;
    CGFloat height = iconSize.height + kVertifyH * 0.5;
    self.bounds = CGRectMake(0, 0, width, height);
}

+ (CGSize)iconSizeWithType:(IconType)type
{
    CGSize iconSize;
    switch (type) {
        case kIconTypeSmall: // 小图标
            iconSize = CGSizeMake(kIconSmallW, kIconSmallH);
            break;
            
        case kIconTypeDefault: // 中图标
            iconSize = CGSizeMake(kIconDefaultW, kIconDefaultH);
            break;
            
        case kIconTypeBig: // 大图标
            iconSize = CGSizeMake(kIconBigW, kIconBigH);
            break;
    }
    CGFloat width = iconSize.width + kVertifyW * 0.5;
    CGFloat height = iconSize.height + kVertifyH * 0.5;
    return CGSizeMake(width, height);
}

//- (void)setFrame:(CGRect)frame
//{
////    MyLog(@"%@", NSStringFromCGRect(self.bounds));
//    frame.size = self.bounds.size;
//    
//    [super setFrame:frame];
//}

@end
