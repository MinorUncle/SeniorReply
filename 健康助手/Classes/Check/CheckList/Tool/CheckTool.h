//
//  MedicineTool.h
//  健康助手
//
//  Created by 未成年大叔 on 15/7/23.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Check.h"
#import "HomeBaseTool.h"
//typedef void (^CheckDetailSuccess)(Check* mesicines);
//typedef void (^CheckSuccess)(NSArray* mesicines);
//typedef void (^CheckTypeSuccess)(NSArray* mesicinesType);
//typedef void (^CheckTypeFailure)(NSError* err);
//typedef void (^CheckFailure)(NSError* err);
//typedef void (^CheckDetailFailure)(NSError* err);
//


@interface CheckTool :HomeBaseTool
//+ (void)medicineWithPath:(NSString*) path Param:(NSDictionary*)param success:(MedicineSuccess)success failure:(MedicineFailure)failure;
//+ (void)CheckListWithParam:(NSDictionary*)param success:(Success)success failure:(Failure)failure;
//+ (void)CheckSerachWithParam:(NSDictionary*)param success:(Success)success failure:(Failure)failure;
//+ (void)CheckDetailWithParam:(NSDictionary*)param success:(DetailSuccess)success failure:(DetailFailure)failure;
//+ (void)CheckTypeWithParam:(NSDictionary*)param success:(TypeSuccess)success failure:(TypeFailure)failure;
+(void)initOffsetNumber;
+ (NSMutableArray*)getCheckArryWithCoding;
+ (void)saveCheck:(Check *)check;
+(void)deleteCheck:(Check *)check;
+(void)initPath;
+(BOOL)existCorrentCheck:(NSInteger)ID;
@end
