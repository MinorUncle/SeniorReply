//
//  StatusCell.m
//  健康助手
//
//  Created by apple on 13-11-1.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "StatusCell.h"
#import "StatusCellFrame.h"
#import "StatusDock.h"

@interface StatusCell()
{
    StatusDock *_dock; // 底部的操作条
}
@end

@implementation StatusCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 操作条
        CGFloat y = self.frame.size.height - kStatusDockHeight;
        _dock = [[StatusDock alloc] initWithFrame:CGRectMake(0, y, 0, 0)];
        [self.contentView addSubview:_dock];
    }
    return self;
}

- (void)setCellFrame:(BaseStatusCellFrame *)cellFrame
{
    [super setCellFrame:cellFrame];    
    _dock.status = cellFrame.status;
}
@end
