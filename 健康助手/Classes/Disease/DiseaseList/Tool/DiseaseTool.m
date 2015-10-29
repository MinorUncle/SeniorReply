//
//  DiseaseTool.m
//  健康助手
//
//  Created by 未成年大叔 on 15/7/23.
//  Copyright (c) 2015年 itcast. All rights reserved.
//
// 文件路径


#import "DiseaseTool.h"
#import "bHttpTool.h"
#import "HomeBaseTool.h"
#import "Disease.h"
#import "Healthcfg.h"
#import "DiseaseSQLiteManager.h"
#import "ConnentTool.h"
@implementation DiseaseTool
static NSInteger _offlineListNumber;//离线状态下列表的总数据;用于防止重复浏览
static NSInteger _offlineSerachNumber;//离线状态下查询的总数据;用于防止重复浏览

static NSMutableArray* _diseaseClass;
static NSMutableArray* _currectDisease;

/**
 *  初始化已经查询了的位置,每次创建listController时调用
 */
+(void)initOffsetNumber
{
    _offlineListNumber =0;
    _offlineSerachNumber =0;
}

+(void)initPath
{
    [self initWithList:diseaseList class:diseaseClass search:diseaseSerach detail:diseaseDetail dataFile:diseaseDataFile appkey:diseaseAppKey];
}


+ (NSMutableArray*)getDiseaseArryWithCoding
{
    if(_currectDisease == nil)
    {
        NSMutableArray* arry = [[NSMutableArray alloc]init];
        [arry addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithFile:kDiseaseCollectFile]];
        _currectDisease = arry;
    }
    return _currectDisease;
}



+ (void)saveDisease:(Disease *)disease
{
    NSMutableArray* arry=[self getDiseaseArryWithCoding];
    BOOL flg = NO;//是否有重复
    for (Disease* i in arry) {
        if(i.ID == disease.ID)flg = YES;
    }
    
    if(!flg)[arry addObject:disease];
    
    [NSKeyedArchiver archiveRootObject:arry toFile:kDiseaseCollectFile];
}
+(BOOL)existCorrentDisease:(NSInteger)ID
{
    NSMutableArray* arry = [self getDiseaseArryWithCoding];
    for(Disease* i in arry)
    {
        if(i.ID == ID)return YES;
    }
    return NO;
}
+(void)deleteDisease:(Disease *)disease
{
    NSMutableArray* arry = [self getDiseaseArryWithCoding];
    for (Disease* i in arry) {
        if(i.ID == disease.ID)
        {
            [arry removeObject:i];
            break;
        }
    }
    
    [NSKeyedArchiver archiveRootObject:arry toFile:kDiseaseCollectFile];
    
}







+(id)getSearchData:(id)dic
{
    [self initPath];
    Disease* disease = [[Disease alloc]initWithSearchDict:dic];
    return disease;
    
}

+(id)getData:(id)dic
{
    return [[Disease alloc]initWithDict:dic];
}
+(id)getTypeData:(id)dic
{
    return [[Disease alloc]initWithDict:dic];
}
+(NSMutableArray*)getDiseaseClass
{
    [self initPath];

    _diseaseClass = [[NSMutableArray alloc]init];
    [_diseaseClass addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithFile:kDiseaseClassFile]];
    return _diseaseClass;
}
+(void)saveDiseaseClass:(NSArray *)diseases
{
    
    [NSKeyedArchiver archiveRootObject:diseases toFile:kDiseaseClassFile];
    
}

//#program mark 数据库
+(void)TypeWithParam:(NSDictionary *)param success:(TypeSuccess)success failure:(TypeFailure)failure
{
    [self initPath];

    //先判断内存是否存在;
    if(_diseaseClass > 0)
    {
        MyLog(@"从内存获取疾病分类成功");
        success(_diseaseClass);
        return;
    }
    //否则从磁盘获取
    _diseaseClass = [self getDiseaseClass];
    if (_diseaseClass.count > 0) {
        success(_diseaseClass);
        MyLog(@"从磁盘获取疾病分类成功");

        
    }else{
        //否则从网络下载
        [super TypeWithParam:@{@"id":@(0)} success:^(NSArray *disease) {
            [_diseaseClass addObjectsFromArray:disease];
            MyLog(@"从网络获取疾病分类成功");

            //保存文件
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self saveDiseaseClass:_diseaseClass];
                MyLog(@"保存疾病分类到磁盘成功");

            });
            
            success(_diseaseClass);
        } failure:^(NSError *err) {
            MyLog(@"%@",err);
        }];
    }
}


+ (void)ListWithParam:(NSDictionary*)param success:(Success)success failure:(Failure)failure
{
    [self initPath];

    NSArray* arry;
    //离线状态
    if ([[ConnentTool sharedConnentTool] mainScanType] == kscanTypeWithoutNet) {
        
        NSInteger idDex = [param[@"id"] integerValue];
        NSString* filter = nil;
        if (idDex != 0) {
            filter = [NSString stringWithFormat:@" id = %ld ",(long)idDex];
        }
        
        idDex = [param[@"pid"] integerValue];

        if (idDex != 0) {
            filter = [NSString stringWithFormat:@" id = %ld ",(long)idDex];
        }
        
        arry = [[DiseaseSQLiteManager sharedDiseaseSQLiteManager] queryDiseaseWithFilter:filter limit:20 offset:_offlineListNumber];
        _offlineListNumber += arry.count;
        success(arry);
        return;
    }
    
    
    //缓存状态
    if ([[ConnentTool sharedConnentTool] mainScanType] == kscanTypeCache) {
        //获取信息列表
        [super ListWithParam:param success:^(NSArray* obj){
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                for (Disease* i in obj)
                {
                    NSDictionary* dic=@{@"id":@(i.ID)};
                    //正常状态,先判断数据库是否有详细数据,没有则下载否则不作为;
                    NSString* filter = [NSString stringWithFormat:@" id = %d and summary != '(null)' ",(int)(i.ID)];
                    //判断是否存在详细内容在数据库;
                    NSArray* Diseases = [[DiseaseSQLiteManager sharedDiseaseSQLiteManager]queryDiseaseWithFilter:filter];
                    if (Diseases.count != 0)return;         //数据库存在,不需要保存;
                    
                    
                    //否则网络下载
                    [super DetailWithParam:dic success:^( Disease* obj){
                        
                        //将列表简介与详细内容组合
                        obj = [self combineDiseaseWithSoc:obj desc:i];
                        //删除已经存在的简介信息
                        [[DiseaseSQLiteManager sharedDiseaseSQLiteManager]removeDisease:obj.ID];
                        
                        //保存详细内容
                        [[DiseaseSQLiteManager sharedDiseaseSQLiteManager]addDisease:obj];
                    }failure:failure];
                }
            });
            
            success(obj);
            
        }failure:failure];
        return;
    }

    
    
    //正常状态,获得数据后存储
    
    
    [super ListWithParam:param success:^(NSArray* obj){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            for (Disease* i in obj) {
                [[DiseaseSQLiteManager sharedDiseaseSQLiteManager]addDisease:i];
            }
        });
        
        success(obj);
    }  failure:failure];
    //    [super ListWithParam:param success:success failure:failure]
    
}
+ (void)SerachWithParam:(NSDictionary*)param  success:(Success)success failure:(Failure)failure
{
    [self initPath];

    
    //离线状态
    if ([[ConnentTool sharedConnentTool] mainScanType] == kscanTypeWithoutNet) {
        NSArray* arry;
        
        //查询关键字
        NSString* keyWord = [param objectForKey:@"keyword"];
        NSString* filter = [NSString stringWithFormat:@" name LIKE  '%%%@%%' or title LIKE '%%%@%%' or content LIKE '%%%@%%' ",keyWord,keyWord,keyWord];
        arry = [[DiseaseSQLiteManager sharedDiseaseSQLiteManager] queryDiseaseWithFilter:filter limit:20 offset:_offlineSerachNumber];
        _offlineSerachNumber += arry.count;
        success(arry);
        return;
    }
    
    
    
    //缓存状态
    if ([[ConnentTool sharedConnentTool] mainScanType] == kscanTypeCache) {
        //获取信息列表
        [super SerachWithParam:param success:^(NSArray* obj){
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                for (Disease* i in obj)
                {
                    NSDictionary* dic=@{@"id":@(i.ID)};
                    //正常状态,先判断数据库是否有详细数据,没有则下载否则不作为;
                    NSString* filter = [NSString stringWithFormat:@" id = %d and detailMessage != '(null)' ",(int)(i.ID)];
                    //判断是否存在详细内容在数据库;
                    NSArray* Diseases = [[DiseaseSQLiteManager sharedDiseaseSQLiteManager]queryDiseaseWithFilter:filter];
                    if (Diseases.count != 0)return;         //数据库存在,不需要保存;
                    
                    
                    //否则网络下载
                    [super DetailWithParam:dic success:^( Disease* obj){
                        
                        //将列表简介与详细内容组合
                        obj = [self combineDiseaseWithSoc:obj desc:i];
                        //删除已经存在的简介信息
                        [[DiseaseSQLiteManager sharedDiseaseSQLiteManager]removeDisease:obj.ID];
                        
                        //保存详细内容
                        [[DiseaseSQLiteManager sharedDiseaseSQLiteManager]addDisease:obj];
                    }failure:failure];
                }
            });
            success(obj);
        }failure:failure];
        return;
    }
   
    
    
    
    //正常状态,获得数据后存储
    [super SerachWithParam:param success:^(NSArray* obj){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            for (Disease* i in obj) {
                [[DiseaseSQLiteManager sharedDiseaseSQLiteManager]addDisease:i];
            }
        });
        
        success(obj);
    }failure:failure];
}
+ (void)DetailWithParam:(NSDictionary*)param  success:(DetailSuccess)success failure:(DetailFailure)failure
{
    [self initPath];

    NSInteger ID = [[param objectForKey:@"id"] integerValue];

    //离线状态
    if ([[ConnentTool sharedConnentTool] mainScanType] == kscanTypeWithoutNet) {
        Disease* arry;
        arry = [[DiseaseSQLiteManager sharedDiseaseSQLiteManager] queryDiseaseWithDiseaseID:ID];
        success(arry);
        return;
    }
    
    //正常状态,先判断数据库是否有详细数据,没有则下载,保存,否则直接使用数据库数据;
    NSString* filter = [NSString stringWithFormat:@" id = %ld and summary != '(null)' ",(long)ID];
    //判断是否存在详细内容在数据库;
    NSArray* Diseases = [[DiseaseSQLiteManager sharedDiseaseSQLiteManager]queryDiseaseWithFilter:filter];
    if (Diseases.count != 0) {
        
        Disease* temDisease = Diseases[0];
        success(temDisease);
        return;
    }
    
    //网络下载
    [super DetailWithParam:param success:^( Disease* obj){
        __block Disease* blockObj = obj;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            Disease* Disease = [[DiseaseSQLiteManager sharedDiseaseSQLiteManager]queryDiseaseWithDiseaseID:blockObj.ID];

            if (Disease != nil) {
                //如果只存在不完整的搜索信息,则组合,删除,重写
                blockObj = [self combineDiseaseWithSoc:obj desc:Disease];
                [[DiseaseSQLiteManager sharedDiseaseSQLiteManager]removeDisease:obj.ID];
                }
            //保存
            [[DiseaseSQLiteManager sharedDiseaseSQLiteManager]addDisease:blockObj];

        });
        
        success(obj);
    }failure:failure];
}
//@"place",@"summary",@"symptomText",@"causeText",@"drug",@"drugText",@"symptom",@"Disease",@"DiseaseText",@"food",@"foodText",@"disease",@"diseaseText",@"careText",@"department",@"title",@"content"


+(Disease* )combineDiseaseWithSoc:(Disease*)soc desc:(Disease*)desc
{
    if (soc.tag == nil)soc.tag = desc.tag;
    if (soc.detailMessage == nil)soc.detailMessage = desc.detailMessage;
    if (soc.image == nil)soc.image = desc.image;
    if (soc.place == nil)soc.place = desc.place;
    if (soc.summary == nil)soc.summary = desc.summary;
    if (soc.symptomText == nil)soc.symptomText = desc.symptomText;
    if (soc.causeText == nil)soc.causeText = desc.causeText;
    if (soc.drug == nil)soc.drug = desc.drug;
    if (soc.drugText == nil)soc.drugText = desc.drugText;
    if (soc.symptom == nil)soc.symptom = desc.symptom;
    if (soc.disease == nil)soc.disease = desc.disease;
    if (soc.diseaseText == nil)soc.diseaseText = desc.diseaseText;
    if (soc.food == nil)soc.food = desc.food;
    if (soc.foodText == nil)soc.foodText = desc.foodText;
    if (soc.disease == nil)soc.disease = desc.disease;
    if (soc.diseaseText == nil)soc.diseaseText = desc.diseaseText;
    if (soc.careText == nil)soc.careText = desc.careText;
    if (soc.department == nil)soc.department = desc.department;
    if (soc.title == nil)soc.title = desc.title;
    if (soc.content == nil)soc.content = desc.content;

    return soc;
}

@end
