//
//  Medicine.m
//  健康助手
//
//  Created by 未成年大叔 on 15/7/23.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "Medicine.h"

@implementation Medicine

- (Medicine*)initWithDict:(NSDictionary*)medicine
{
    if(self = [super initWithDict:medicine])
    {
        
        _type =medicine[@"PType"];            //药品类型
        _factory =medicine[@"factory"];             //工厂
        _ANumber =medicine[@"ANumber"];   //编号
        _categroyNmae =medicine[@"categoryName"];  //药品分类
        _category = [medicine[@"category"] intValue];  //分类id
        

       
    }
    return self;
}

- (Medicine*)initWithSearchDict:(NSDictionary*)medicine
{
   
    if(self = [super initWithSearchDict:medicine])
    {
    }
    return self;
}


-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:_type forKey:@"PType"];
    [aCoder encodeObject:_factory forKey:@"factory"];
    [aCoder encodeObject:_ANumber forKey:@"ANumber"];
    [aCoder encodeObject:_categroyNmae forKey:@"categoryName"];
    [aCoder encodeObject:@(_category) forKey:@"category"];

    
}
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super initWithCoder:decoder]) {
        _type = [decoder decodeObjectForKey:@"PType"];            //药品类型
        _factory =[decoder decodeObjectForKey:@"factory"];             //工厂
        _ANumber =[decoder decodeObjectForKey:@"ANumber"];   //编号
        _categroyNmae =[decoder decodeObjectForKey:@"categoryName"];  //药品分类
        _category = [[decoder decodeObjectForKey:@"category"] intValue];  //分类id
  }
    return self;
}



@end
