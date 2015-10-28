//
//  ImageListView.h
//  健康助手
//
//  Created by apple on 13-11-2.
//  Copyright (c) 2013年 itcast. All rights reserved.
//  配图列表（1~9）

#import <UIKit/UIKit.h>

@interface ImageListView : UIView

// 所有图片的url
@property (nonatomic, strong) NSArray *imageUrls;

+ (CGSize)imageListSizeWithCount:(int)count;
@end