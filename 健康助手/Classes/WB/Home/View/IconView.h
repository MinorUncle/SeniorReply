//
//  IconView.h
//  健康助手
//
//  Created by apple on 13-11-2.
//  Copyright (c) 2013年 itcast. All rights reserved.
//  头像

#import <UIKit/UIKit.h>
typedef enum {
    kIconTypeSmall,
    kIconTypeDefault,
    kIconTypeBig
} IconType;

@class User;
@interface IconView : UIView
@property (nonatomic, strong) User *user;
@property (nonatomic, assign) IconType type;

- (void)setUser:(User *)user type:(IconType)type;

+ (CGSize)iconSizeWithType:(IconType)type;


@end