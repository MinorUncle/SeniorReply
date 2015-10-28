//
//  DetailMedicineController.h
//  健康助手
//
//  Created by 未成年大叔 on 15/7/23.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Food.h"

@interface DetailFoodController : UIViewController
@property (nonatomic,strong)Food* food;
-(DetailFoodController*)initWithID:(int) ID;
@end
