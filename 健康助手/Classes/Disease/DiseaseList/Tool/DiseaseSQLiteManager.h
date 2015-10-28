//
//  DiseaseSQLiteManager.h
//  健康助手
//
//  Created by 未成年大叔 on 15/8/7.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Disease.h"
#import "Singleton.h"

@interface DiseaseSQLiteManager : NSObject
single_interface(DiseaseSQLiteManager)

- (void)addDisease:(Disease *)disease;
// 删除
- (int)removeDisease:(NSInteger)diseaseID;
-(BOOL)isExistWithID:(NSInteger)personID;
-(NSArray*)queryDisease;
-(NSArray*)queryDiseaseWithFilter:(NSString* )filter;
-(NSArray*)queryDiseaseWithFilter:(NSString* )filter limit:(NSInteger)limit offset:(NSInteger)offset;
-(Disease *)queryDiseaseWithDiseaseID:(NSInteger)ID;
-(BOOL)isExistWithID:(NSInteger)personID notNullColumnName:(NSString*)cloumnN;

@end
