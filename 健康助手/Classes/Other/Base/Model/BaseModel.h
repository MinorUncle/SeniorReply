//
//  BaseModel.h
//  健康助手
//
//  Created by apple on 13-11-6.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject
@property (nonatomic, assign) long long ID;
@property (nonatomic, copy) NSString *createdAt;


- (id)initWithDict:(NSDictionary *)dict;
@end