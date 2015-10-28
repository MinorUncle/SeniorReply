//
//  MedicineBaseController
//  健康助手
//
//  Created by 未成年大叔 on 15/8/12.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseList.h"

@interface FoodBaseController : BaseList
@property(nonatomic,strong)NSMutableArray* food;


- (void)showNewStatusCount:(int)count;
- (void)addRefreshViews;

@end
