//
//  MedicineTool.h
//  健康助手
//
//  Created by 未成年大叔 on 15/7/23.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Store.h"
#import "HomeBaseTool.h"
typedef void (^StoreDetailSuccess)(Store* store);
typedef void (^StoreSuccess)(NSArray* store);
typedef void (^StoreTypeSuccess)(NSArray* storeType);
typedef void (^StoreTypeFailure)(NSError* err);
typedef void (^StoreFailure)(NSError* err);
typedef void (^StoreDetailFailure)(NSError* err);



@interface StoreTool :HomeBaseTool
//+ (void)medicineWithPath:(NSString*) path Param:(NSDictionary*)param success:(MedicineSuccess)success failure:(MedicineFailure)failure;
//+ (void)FoodListWithParam:(NSDictionary*)param success:(Success)success failure:(Failure)failure;
//+ (void)FoodSerachWithParam:(NSDictionary*)param success:(Success)success failure:(Failure)failure;
//+ (void)FoodDetailWithParam:(NSDictionary*)param success:(DetailSuccess)success failure:(DetailFailure)failure;
//+ (void)FoodTypeWithParam:(NSDictionary*)param success:(TypeSuccess)success failure:(TypeFailure)failure;

+ (NSMutableArray*)getStoreArryWithCoding;
+ (void)saveStore:(Store *)food;
+(void)deleteStore:(Store *)food;
+(void)initPath;
+(BOOL)existCorrentStore:(NSInteger)ID;
+(void)initOffsetNumber;

@end
