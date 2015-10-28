//
//  FoodSQLiteManager.h
//  健康助手
//
//  Created by 未成年大叔 on 15/8/7.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Food.h"
#import "Singleton.h"

@interface FoodSQLiteManager : NSObject
single_interface(FoodSQLiteManager)

- (void)addFood:(Food *)food;
// 删除
- (int)removeFood:(NSInteger)foodID;
-(BOOL)isExistWithID:(NSInteger)personID;
-(NSArray*)queryFood;
-(NSArray*)queryFoodWithFilter:(NSString* )filter;
-(NSArray*)queryFoodWithFilter:(NSString* )filter limit:(NSInteger)limit offset:(NSInteger)offset;
-(Food *)queryFoodWithFoodID:(NSInteger)ID;
-(BOOL)isExistWithID:(NSInteger)personID notNullColumnName:(NSString*)cloumnN;

@end
