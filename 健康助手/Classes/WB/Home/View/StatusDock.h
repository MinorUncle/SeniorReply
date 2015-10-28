//
//  StatusDock.h
//  健康助手
//
//  Created by apple on 13-11-4.
//  Copyright (c) 2013年 itcast. All rights reserved.
//  一条数据底部的操作条

#import <UIKit/UIKit.h>
@class Status;

@interface StatusDock : UIImageView
@property (nonatomic, strong) Status *status;
@end
