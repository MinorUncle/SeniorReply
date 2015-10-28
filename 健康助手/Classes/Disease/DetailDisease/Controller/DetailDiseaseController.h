//
//  DetailMedicineController.h
//  健康助手
//
//  Created by 未成年大叔 on 15/7/23.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Disease.h"

@interface DetailDiseaseController : UIViewController
@property (nonatomic,strong)Disease* disease;
-(DetailDiseaseController*)initWithID:(int) ID;
@end
