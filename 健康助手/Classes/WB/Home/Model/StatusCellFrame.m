//
//  StatusCellFrame.m
//  健康助手
//
//  Created by apple on 13-11-1.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "StatusCellFrame.h"
#import "Status.h"
#import "User.h"
#import "IconView.h"
#import "ImageListView.h"

@implementation StatusCellFrame
- (void)setStatus:(Status *)status
{
    [super setStatus:status];
    
    _cellHeight += kStatusDockHeight;
}
@end
