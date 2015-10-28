//
//  MedicineTool.h
//  健康助手
//
//  Created by 未成年大叔 on 15/7/23.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^DetailSuccess)(id mesicines);
typedef void (^Success)(NSArray* mesicines);
typedef void (^TypeSuccess)(NSArray* mesicinesType);
typedef void (^TypeFailure)(NSError* err);
typedef void (^Failure)(NSError* err);
typedef void (^DetailFailure)(NSError* err);



@interface HomeBaseTool : NSObject
//@property(nonatomic,copy)NSString* path;

//+ (void)medicineWithPath:(NSString*) path Param:(NSDictionary*)param success:(MedicineSuccess)success failure:(MedicineFailure)failure;
//+ (void)ListWithParam:(NSDictionary*)param appkey:(NSString*)key success:(Success)success failure:(Failure)failure;
//+ (void)SerachWithParam:(NSDictionary*)param appkey:(NSString*)key success:(Success)success failure:(Failure)failure;
//+ (void)DetailWithParam:(NSDictionary*)param appkey:(NSString*)key success:(DetailSuccess)success failure:(DetailFailure)failure;
//+ (void)TypeWithParam:(NSDictionary*)param appkey:(NSString*)key success:(TypeSuccess)success failure:(TypeFailure)failure;

+ (void)LocalWithParam:(NSDictionary*)param success:(TypeSuccess)success failure:(TypeFailure)failure;
+ (void)ListWithParam:(NSDictionary*)param success:(Success)success failure:(Failure)failure;
+ (void)SerachWithParam:(NSDictionary*)param  success:(Success)success failure:(Failure)failure;
+ (void)DetailWithParam:(NSDictionary*)param  success:(DetailSuccess)success failure:(DetailFailure)failure;
+ (void)TypeWithParam:(NSDictionary*)param  success:(TypeSuccess)success failure:(TypeFailure)failure;


+ (NSMutableArray*)getHomeBaseArryWithCoding;
+ (void)saveHomeBase:(id )HomeBase;
+(void)deleteHomeBase:(id)HomeBase;
+(void)initWithList:(NSString*)list class:(NSString*) _class search:(NSString*)serach detail:(NSString*)detail dataFile:(NSString*)fileName appkey:(NSString*)key;

//+(void)serachPack;
//+(void)listPack;
//+(void)detailPack;
//+(void)typePack;
+(void)setClass:(Class)_class;
+(id)getData:(id)dic;
+(id)getTypeData:(id)dic;
//+(void)getData;
//+(void)getDataArry;

@end
