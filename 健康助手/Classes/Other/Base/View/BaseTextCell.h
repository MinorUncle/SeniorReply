//
//  BaseTextCell.h
//  健康助手
//
//  Created by apple on 13-11-6.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "BaseWordCell.h"
@class BaseTextCellFrame;
@interface BaseTextCell : BaseWordCell
@property (nonatomic, strong)  BaseTextCellFrame *cellFrame;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) UITableView *myTableView;
@end
