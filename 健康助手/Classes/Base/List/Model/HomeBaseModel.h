//
//  Medicine.h
//  健康助手
//
//  Created by 未成年大叔 on 15/7/23.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeBaseModel : NSObject<NSCoding>
{

}
@property(nonatomic,copy)NSString* name;            //名称
@property(nonatomic,copy) NSString* image;               //图片路径
@property(nonatomic,copy)NSString* detailMessage;   //详细信息
@property(nonatomic,copy)NSString* tag;   //备注

@property(nonatomic,assign)NSInteger scanTimes;              //浏览次数

@property(nonatomic,assign)NSInteger ID;                     //唯一编码

//搜索部分
@property(nonatomic,copy) NSString* title;               //疾病
@property(nonatomic,copy) NSString* content;               //疾病


-(HomeBaseModel*)initWithDict:(NSDictionary*)base;
- (HomeBaseModel*)initWithSearchDict:(NSDictionary*)base;
@end
