//
//  StatusDetailFrame.m
//  健康助手
//
//  Created by apple on 13-11-5.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "StatusDetailCellFrame.h"
#import "Status.h"

@implementation StatusDetailCellFrame
- (void)setStatus:(Status *)status
{
    [super setStatus:status];
    
    if (status.retweetedStatus) {
        _retweetedFrame.size.height += kRetweetedDockHeight;
        _cellHeight += kRetweetedDockHeight;
    }
}
@end
