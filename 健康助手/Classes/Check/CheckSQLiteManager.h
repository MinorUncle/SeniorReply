//
//  CheckSQLiteManager.h
//  健康助手
//
//  Created by 未成年大叔 on 15/8/7.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Check.h"
#import "Singleton.h"

@interface CheckSQLiteManager : NSObject
single_interface(CheckSQLiteManager)

- (void)addCheck:(Check *)check;
// 删除
- (int)removeCheck:(NSInteger)checkID;
-(BOOL)isExistWithID:(NSInteger)personID;
-(NSArray*)queryCheck;
-(NSArray*)queryCheckWithFilter:(NSString* )filter;
-(NSArray*)queryCheckWithFilter:(NSString* )filter limit:(NSInteger)limit offset:(NSInteger)offset;
-(Check *)queryCheckWithCheckID:(NSInteger)ID;
-(BOOL)isExistWithID:(NSInteger)personID notNullColumnName:(NSString*)cloumnN;

@end
