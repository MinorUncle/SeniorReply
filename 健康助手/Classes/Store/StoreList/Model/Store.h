//
//  Medicine.h
//  健康助手
//
//  Created by 未成年大叔 on 15/7/23.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeBaseModel.h"
@interface Store : HomeBaseModel
{

}

@property(nonatomic,copy)NSString* address;             //部位



@property(nonatomic,copy) NSString* image;               //图片路径

@property(nonatomic,copy) NSString* tel;               //简介

@property(nonatomic,copy) NSString* zipcode;               //病状详情
@property(nonatomic,copy) NSString* type;               //发病原因
@property(nonatomic,copy) NSString* number;               //相关药品
@property(nonatomic,copy) NSString* charge;               //相关病状
@property(nonatomic,copy) NSString* legal;               //法定代表人
@property(nonatomic,assign) float localX;               //法定代表人详情

@property(nonatomic,assign) float localY;               //地图y坐标
@property(nonatomic,copy) NSString* food;               //食疗食物
@property(nonatomic,copy) NSString* foodText;               //食疗
@property(nonatomic,copy) NSString* leader;               //疾病说明
@property(nonatomic,copy) NSString* business;               //注意事项
@property(nonatomic,copy) NSString* createdate;               //科室










-(Store*)initWithDict:(NSDictionary*)store;
- (Store*)initWithSearchDict:(NSDictionary*)store;
@end
