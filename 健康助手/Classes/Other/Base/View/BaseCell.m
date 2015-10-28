//
//  BaseCell.m
//  健康助手
//
//  Created by apple on 13-11-6.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "BaseCell.h"

@interface BaseCell()

@end

@implementation BaseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 1.设置背景
        [self settingBg];
    }
    return self;
}

- (void)settingBg
{
    UIImageView *bg = [[UIImageView alloc] init];
    self.backgroundView = bg;
    _bg = bg;
    
    UIImageView *seletcedBg = [[UIImageView alloc] init];
    self.selectedBackgroundView = seletcedBg;
    _selectedBg = seletcedBg;
}
@end
