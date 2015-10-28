//
//  StoreSQLiteManager.h
//  健康助手
//
//  Created by 未成年大叔 on 15/8/7.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Store.h"
#import "Singleton.h"

@interface StoreSQLiteManager : NSObject
single_interface(StoreSQLiteManager)

- (void)addStore:(Store *)store;
// 删除
- (int)removeStore:(NSInteger)storeID;
-(BOOL)isExistWithID:(NSInteger)personID;
-(NSArray*)queryStore;
-(NSArray*)queryStoreWithFilter:(NSString* )filter;
-(NSArray*)queryStoreWithFilter:(NSString* )filter limit:(NSInteger)limit offset:(NSInteger)offset;
-(Store *)queryStoreWithStoreID:(NSInteger)ID;
-(BOOL)isExistWithID:(NSInteger)personID notNullColumnName:(NSString*)cloumnN;

@end
