//
//  MedicineTool.h
//  健康助手
//
//  Created by 未成年大叔 on 15/7/23.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Food.h"
#import "HomeBaseTool.h"
typedef void (^FoodDetailSuccess)(Food* mesicines);
typedef void (^FoodSuccess)(NSArray* mesicines);
typedef void (^FoodTypeSuccess)(NSArray* mesicinesType);
typedef void (^FoodTypeFailure)(NSError* err);
typedef void (^FoodFailure)(NSError* err);
typedef void (^FoodDetailFailure)(NSError* err);



@interface FoodTool :HomeBaseTool
//+ (void)medicineWithPath:(NSString*) path Param:(NSDictionary*)param success:(MedicineSuccess)success failure:(MedicineFailure)failure;
//+ (void)FoodListWithParam:(NSDictionary*)param success:(Success)success failure:(Failure)failure;
//+ (void)FoodSerachWithParam:(NSDictionary*)param success:(Success)success failure:(Failure)failure;
//+ (void)FoodDetailWithParam:(NSDictionary*)param success:(DetailSuccess)success failure:(DetailFailure)failure;
//+ (void)FoodTypeWithParam:(NSDictionary*)param success:(TypeSuccess)success failure:(TypeFailure)failure;
+(void)initOffsetNumber;
+ (NSMutableArray*)getFoodArryWithCoding;
+ (void)saveFood:(Food *)food;
+(void)deleteFood:(Food *)food;
+(void)initPath;
+(BOOL)existCorrentFood:(NSInteger)ID;
@end
