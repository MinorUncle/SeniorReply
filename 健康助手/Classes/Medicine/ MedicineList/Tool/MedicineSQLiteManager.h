//
//  MedicineSQLiteManager.h
//  健康助手
//
//  Created by 未成年大叔 on 15/8/7.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Medicine.h"
#import "Singleton.h"

@interface MedicineSQLiteManager : NSObject
single_interface(MedicineSQLiteManager)

- (void)addMedicine:(Medicine *)medicine;
// 删除
- (int)removeMedicine:(NSInteger)medicineID;
-(BOOL)isExistWithID:(NSInteger)personID;
-(NSArray*)queryMedicine;
-(NSArray*)queryMedicineWithFilter:(NSString* )filter;
-(NSArray*)queryMedicineWithFilter:(NSString* )filter limit:(NSInteger)limit offset:(NSInteger)offset;
-(Medicine *)queryMedicineWithMedicineID:(NSInteger)ID;
-(BOOL)isExistWithID:(NSInteger)personID notNullColumnName:(NSString*)cloumnN;

@end
