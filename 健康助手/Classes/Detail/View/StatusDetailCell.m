//
//  StatusDetailCell.m
//  健康助手
//
//  Created by apple on 13-11-5.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "StatusDetailCell.h"
#import "RetweetedDock.h"
#import "BaseStatusCellFrame.h"
#import "Status.h"
#import "StatusDetailController.h"
#import "MainController.h"

@interface StatusDetailCell()
{
    RetweetedDock *_dock;
}
@end

@implementation StatusDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        // 1.操作条
        RetweetedDock *dock = [[RetweetedDock alloc] init];
        dock.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        CGFloat x = _retweeted.frame.size.width - dock.frame.size.width;
        CGFloat y = _retweeted.frame.size.height - dock.frame.size.height;
        dock.frame = CGRectMake(x, y, 0, 0);
        [_retweeted addSubview:dock];
        _dock = dock;
        
        // 2.监听被转发数据的点击
        [_retweeted addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showRetweeted)]];
    }
    return self;
}

- (void)showRetweeted
{
    // 展示被转发的数据
    StatusDetailController *detail = [[StatusDetailController alloc] init];
    detail.status = _dock.status;
    
    MainController *main = (MainController *)self.window.rootViewController;
    UINavigationController *nav =  (UINavigationController *)main.selectedController;
    
    [nav pushViewController:detail animated:YES];
}

- (void)setCellFrame:(BaseStatusCellFrame *)cellFrame
{
    [super setCellFrame:cellFrame];
    
    // 设置子控件的数据
    _dock.status = cellFrame.status.retweetedStatus;
}

@end
