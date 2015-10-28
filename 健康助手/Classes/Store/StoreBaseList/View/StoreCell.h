//
//  MedicineCell.h
//  健康助手
//
//  Created by 未成年大叔 on 15/7/23.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeBaseCell.h"
@class Store;

@interface StoreCell : HomeBaseCell
@property(nonatomic,strong)Store* storeModel;
@property(nonatomic,assign)BOOL isSerach;//是否是查找状态标题

@end
