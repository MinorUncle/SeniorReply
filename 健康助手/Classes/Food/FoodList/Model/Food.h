//
//  Medicine.h
//  健康助手
//
//  Created by 未成年大叔 on 15/7/23.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeBaseModel.h"
@interface Food : HomeBaseModel
{

}

@property(nonatomic,copy)NSString* food;             //材料
@property(nonatomic,copy) NSString* image;               //图片路径
@property(nonatomic,copy) NSString* bar;               //食品主要功能




-(Food*)initWithDict:(NSDictionary*)food;
- (Food*)initWithSearchDict:(NSDictionary*)food;
@end
