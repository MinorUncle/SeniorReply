//
//  DetailMedicineController.h
//  健康助手
//
//  Created by 未成年大叔 on 15/7/23.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Medicine.h"

@interface DetailMedicineController : UIViewController
@property (nonatomic,strong)Medicine* medicine;
-(DetailMedicineController*)initWithID:(NSInteger) ID;
@end
