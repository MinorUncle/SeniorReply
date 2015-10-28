//
//  MedicineTool.m
//  健康助手
//
//  Created by 未成年大叔 on 15/7/23.
//  Copyright (c) 2015年 itcast. All rights reserved.
//
// 文件路径



#import "HomeBaseTool.h"
#import "bHttpTool.h"
#import "Healthcfg.h"

@implementation HomeBaseTool
static NSString* listPath;
static NSString* classPath;
static NSString* searchPath;
static NSString* detailPath;
static NSString* localPath;
static NSString* appkey;

static NSString* kFile;
+(void)initWithList:(NSString*)list class:(NSString*) _class search:(NSString*)serach detail:(NSString*)detail dataFile:(NSString*)fileName appkey:(NSString*)key
{
    appkey = key;
    listPath = list;
    classPath = _class;
    searchPath = serach;
    detailPath = detail;
    localPath = storeList;
    kFile =  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:fileName];
    
}
+ (void)WithPath:(NSString*) path Param:(NSDictionary*)param appkey:(NSString*)key success:(Success)success failure:(Failure)failure
{
    [bHttpTool getWithPath:path params:param appkey:key
                   success:^(id JSON) {
                            if (success == nil) return;
                            NSMutableArray *medicines = [NSMutableArray array];
                                                                        
                                                                        // 解析json对象
                            NSArray *array = JSON[@"yi18"];
                            for (NSDictionary *dict in array) {
                             id m = [self getData:dict];
                            [medicines addObject:m];
                            }
                                                                        // 回调block
                             success(medicines);
                             }
                   failure:^(NSError *error) {
                           if (failure == nil) return;
                            failure(error);
                            }];
}
+ (void)ListWithParam:(NSDictionary*)param success:(Success)success failure:(Failure)failure
{
    [self WithPath:listPath Param:param appkey:appkey success:^(NSArray *mesicines) {
        success(mesicines);
    } failure:^(NSError *err) {
        failure(err);
    }];
}
+ (void)SerachWithParam:(NSDictionary*)param  success:(Success)success failure:(Failure)failure
{
    
    [bHttpTool getWithPath:searchPath params:param appkey:appkey
                   success:^(id JSON) {
                       if (success == nil) return;
                       NSMutableArray *medicines = [NSMutableArray array];
                       
                       // 解析json对象
                       NSArray *array = JSON[@"yi18"];
                       for (NSDictionary *dict in array) {
                           id m = [self getSearchData:dict];
                           [medicines addObject:m];
                       }
                       // 回调block
                       success(medicines);
                   }
                   failure:^(NSError *error) {
                       if (failure == nil) return;
                       failure(error);
                   }];
}
+ (void)DetailWithParam:(NSDictionary*)param success:(DetailSuccess)success failure:(DetailFailure)failure
{
//    [self medicineWithPath:@"yi18/medicine/detail" Param:param success:^(NSArray *mesicines) {
//        success(mesicines);
//    } failure:^(NSError *err) {
//        failure(err);
//    }];
    
    [bHttpTool getWithPath:detailPath params:param appkey:appkey
                   success:^(id JSON) {
                       if (success == nil) return;
                       // 解析json对象
                       NSDictionary* dic= JSON[@"yi18"];
                        id m = [self getData:dic];
                       success(m);
                   }
                   failure:^(NSError *error) {
                       if (failure == nil) return;
                       failure(error);
                   }];

}
+ (void)LocalWithParam:(NSDictionary*)param success:(TypeSuccess)success failure:(TypeFailure)failure
{
    [bHttpTool getWithPath:localPath params:param appkey:appkey success:^(id JSON) {
        if(success == nil)return ;
        NSMutableArray* modelArry = [[NSMutableArray alloc]initWithCapacity:20];
        NSArray* arry = JSON[@"yi18"];
        for (NSDictionary* dict in arry) {
            id model = [self getData:dict];
            [modelArry addObject:model];
        }
        success(modelArry);
            
    } failure:^(NSError *error) {
        failure(error);
        
    }];
}
+ (void)TypeWithParam:(NSDictionary*)param success:(TypeSuccess)success failure:(TypeFailure)failure
{
    [bHttpTool getWithPath:classPath params:param appkey:appkey
                   success:^(id JSON) {
                       if (success == nil) return;
                       NSMutableArray *medicines = [NSMutableArray array];
                       
                       // 解析json对象
                       NSArray *array = JSON[@"yi18"];
                       for (NSDictionary *dict in array) {
                           id m = [self getTypeData:dict];
                           [medicines addObject:m];
                       }
                       // 回调block
                       success(medicines);
                   }
                   failure:^(NSError *error) {
                       if (failure == nil) return;
                       failure(error);
                   }];

}



//需要重载的函数
+ (NSMutableArray*)getHomeBaseArryWithCoding
{
    NSMutableArray* arry = [[NSMutableArray alloc]init];
    [arry addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithFile:kFile]];
    return arry;
}

+ (void)saveHomeBase:(id )medicine
{
   
}
+(void)deleteHomeBase:(id)medicine
{
}

+(void)serachPack
{}
+(void)listPack
{}
+(void)detailPack
{}
+(void)typePack
{}
+(void)setClass:(Class)className
{
   
//    [self getDataArry];
}
+(id)getSearchData:(id)dic
{
    return [self getData:dic ];
    
}
+(id)getData:(id)dic
{
    return dic;
}
+(id)getTypeData:(id)dic
{
    return dic;
}




@end
