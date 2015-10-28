//
//  DiseaseBaseController.h
//  健康助手
//
//  Created by 未成年大叔 on 15/8/12.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseList.h"
@interface DiseaseBaseController : BaseList
@property(nonatomic,strong)NSMutableArray* disease;

- (void)showNewStatusCount:(int)count;
- (void)addRefreshViews;
@end
