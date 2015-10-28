//
//  MType.m
//  新浪微博
//
//  Created by 未成年大叔 on 15/7/24.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "MType.h"

@implementation MType
-(id)initWithDict:(NSDictionary*)dic
{
    if(self = [super init])
    {
        _ID = [dic[@"id"] intValue];
        _name = dic[@"title"];
    }
    return self;
}

@end
