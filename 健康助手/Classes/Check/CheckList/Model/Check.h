//
//  Medicine.h
//  健康助手
//
//  Created by 未成年大叔 on 15/7/23.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeBaseModel.h"
@interface Check : HomeBaseModel
{

}

@property(nonatomic,copy)NSString* menu;             //分类
@property(nonatomic,copy) NSString* image;               //图片路径
@property(nonatomic,copy) NSString* summary;               //简介




-(Check*)initWithDict:(NSDictionary*)Check;
- (Check*)initWithSearchDict:(NSDictionary*)Check;
@end
