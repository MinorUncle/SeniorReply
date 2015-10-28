//
//  Medicine.h
//  健康助手
//
//  Created by 未成年大叔 on 15/7/23.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeBaseModel.h"
@interface Disease : HomeBaseModel
{

}

@property(nonatomic,copy)NSString* place;             //部位



@property(nonatomic,copy) NSString* image;               //图片路径

@property(nonatomic,copy) NSString* summary;               //简介

@property(nonatomic,copy) NSString* symptomText;               //病状详情
@property(nonatomic,copy) NSString* causeText;               //发病原因
@property(nonatomic,copy) NSString* drug;               //相关药品
@property(nonatomic,copy) NSString* symptom;               //相关病状
@property(nonatomic,copy) NSString* check;               //相关检查
@property(nonatomic,copy) NSString* checkText;               //相关检查详情

@property(nonatomic,copy) NSString* drugText;               //相关药物治疗详情
@property(nonatomic,copy) NSString* food;               //食疗食物
@property(nonatomic,copy) NSString* foodText;               //食疗
@property(nonatomic,copy) NSString* disease;               //相关疾病信息
@property(nonatomic,copy) NSString* diseaseText;               //疾病说明
@property(nonatomic,copy) NSString* careText;               //注意事项
@property(nonatomic,copy) NSString* department;               //科室










-(Disease*)initWithDict:(NSDictionary*)disease;
- (Disease*)initWithSearchDict:(NSDictionary*)disease;
@end
