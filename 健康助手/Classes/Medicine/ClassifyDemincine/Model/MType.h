//
//  MType.h
//  新浪微博
//
//  Created by 未成年大叔 on 15/7/24.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MType : NSObject
@property(nonatomic,assign)int ID;
@property(nonatomic,copy)NSString* name;
-(id)initWithDict:(NSDictionary*)dic;

@end
