//
//  Medicine.h
//  健康助手
//
//  Created by 未成年大叔 on 15/7/23.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeBaseModel.h"
@interface Medicine :HomeBaseModel <NSCoding>
{

}
@property(nonatomic,copy)NSString* type;            //药品类型

@property(nonatomic,copy)NSString* factory;             //工厂

@property(nonatomic,copy)NSString* ANumber;   //编号
@property(nonatomic,copy)NSString* categroyNmae;  //药品分类
@property(nonatomic,assign)NSInteger category;  //分类id




-(Medicine*)initWithDict:(NSDictionary*)medicine;
- (Medicine*)initWithSearchDict:(NSDictionary*)medicine;
@end
