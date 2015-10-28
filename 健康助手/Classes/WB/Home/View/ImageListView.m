//
//  ImageListView.m
//  健康助手
//
//  Created by apple on 13-11-2.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#define kCount 9

#define kOneW 120
#define kOneH 120

#define kMultiW 80
#define kMultiH 80

#define kMargin 10

#import "ImageListView.h"
#import "UIImageView+WebCache.h"
#import "ImageItemView.h"

@implementation ImageListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 先把有可能显示的控件都加进去
        for (int i = 0; i<kCount; i++) {
            ImageItemView *imageView = [[ImageItemView alloc] init];
            [self addSubview:imageView];
        }
    }
    return self;
}

- (void)setImageUrls:(NSArray *)imageUrls
{
    // 4
    _imageUrls = imageUrls;
    int count = imageUrls.count;
    
    for (int i = 0; i<kCount; i++) {
        // 1.取出对应位置的子控件
        ImageItemView *child = self.subviews[i];
        
        // 2.不要显示图片
        if (i >= count) {
            child.hidden = YES;
            continue;
        }
        
        // 需要显示图片
        child.hidden = NO;
        
        // 3.设置图片
        child.url = imageUrls[i][@"thumbnail_pic"];
        
        // 4.设置frame
        if (count == 1) { // 1张
            child.contentMode = UIViewContentModeScaleAspectFit;
            child.frame = CGRectMake(0, 0, kOneW, kOneH);
            continue;
        }
        
        // 超出边界的减掉
        child.clipsToBounds = YES;
        child.contentMode = UIViewContentModeScaleAspectFill;
        
        int temp = (count == 4) ? 2 : 3;
        CGFloat row = i/temp; // 行号
        CGFloat column = i%temp; // 列号
        CGFloat x = (kMultiW + kMargin) * column;
        CGFloat y = (kMultiH + kMargin) * row;
        child.frame = CGRectMake(x, y, kMultiW, kMultiH);
    }
}

+ (CGSize)imageListSizeWithCount:(int)count
{
    // 1.只有1张图片
    if (count == 1) {
        return CGSizeMake(kOneW, kOneH);
    }
    
    // 2.至少2张图片
    CGFloat countRow = (count == 4) ? 2 : 3;
    // 总行数
    int rows = (count + countRow - 1) / countRow;
    // 总列数
    int columns = (count >= 3) ? 3 : 2;
    
    CGFloat width = columns * kMultiW + (columns - 1) * kMargin;
    CGFloat height = rows * kMultiH + (rows - 1) * kMargin;
    return CGSizeMake(width, height);
}

@end
