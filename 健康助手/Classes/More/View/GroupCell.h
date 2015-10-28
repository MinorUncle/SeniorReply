//
//  GroupCell.h
//  健康助手
//
//  Created by apple on 13-10-29.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "BaseCell.h"

typedef enum {
    kCellTypeNone, // 没有样式
    kCellTypeArrow, // 箭头
    kCellTypeLabel, // 文字
    kCellTypeSwitch, // 开关
    kCellTypeButton //按钮
} CellType;

@interface GroupCell : BaseCell
@property (nonatomic, readonly) UISwitch *rightSwitch; // 右边的switch控件
@property (nonatomic, readonly) UILabel *rightLabel; // 右边的文字标签
@property (nonatomic, readonly) UIButton *rightButton; // 右边的文字标签


@property (nonatomic, assign) CellType cellType;  // cell的类型
@property (nonatomic, weak) UITableView *myTableView; // 所在的表格
@property (nonatomic, strong) NSIndexPath *indexPath; // 所在的行号
@end
