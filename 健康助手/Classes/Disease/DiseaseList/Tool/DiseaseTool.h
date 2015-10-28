//
//  MedicineTool.h
//  健康助手
//
//  Created by 未成年大叔 on 15/7/23.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Disease.h"
#import "HomeBaseTool.h"
typedef void (^DiseaseDetailSuccess)(Disease* disease);
typedef void (^DiseaseSuccess)(NSArray* disease);
typedef void (^DiseaseTypeSuccess)(NSArray* diseaseType);
typedef void (^DiseaseTypeFailure)(NSError* err);
typedef void (^DiseaseFailure)(NSError* err);
typedef void (^DiseaseDetailFailure)(NSError* err);



@interface DiseaseTool :HomeBaseTool
//+ (void)medicineWithPath:(NSString*) path Param:(NSDictionary*)param success:(MedicineSuccess)success failure:(MedicineFailure)failure;
//+ (void)FoodListWithParam:(NSDictionary*)param success:(Success)success failure:(Failure)failure;
//+ (void)FoodSerachWithParam:(NSDictionary*)param success:(Success)success failure:(Failure)failure;
//+ (void)FoodDetailWithParam:(NSDictionary*)param success:(DetailSuccess)success failure:(DetailFailure)failure;
//+ (void)FoodTypeWithParam:(NSDictionary*)param success:(TypeSuccess)success failure:(TypeFailure)failure;

+ (NSMutableArray*)getDiseaseArryWithCoding;
+ (void)saveDisease:(Disease *)food;
+(void)deleteDisease:(Disease *)food;
+(void)initPath;
+(BOOL)existCorrentDisease:(NSInteger)ID;
+(void)initOffsetNumber;

@end
