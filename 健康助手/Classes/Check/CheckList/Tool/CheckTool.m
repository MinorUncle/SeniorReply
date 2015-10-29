//
//  getCheckClass
//  健康助手
//
//  Created by 未成年大叔 on 15/7/23.
//  Copyright (c) 2015年 itcast. All rights reserved.
//
// 文件路径


#import "CheckTool.h"
#import "bHttpTool.h"
#import "HomeBaseTool.h"
#import "Check.h"
#import "Healthcfg.h"
#import "ConnentTool.h"
#import "CheckSQLiteManager.h"
@implementation CheckTool
static NSInteger _offlineListNumber;//离线状态下列表的总数据;用于防止重复浏览
static NSInteger _offlineSerachNumber;//离线状态下查询的总数据;用于防止重复浏览

static NSMutableArray* _checkClass;
static NSMutableArray* _currectCheck;

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
    [self initWithList:checkList class:checkClass search:checkSerach detail:checkDetail dataFile:checkDataFile appkey:checkAppKey];
}

+ (NSMutableArray*)getCheckArryWithCoding
{
    if(_currectCheck == nil)
    {
        NSMutableArray* arry = [[NSMutableArray alloc]init];
        [arry addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithFile:kCheckCollectFile]];
        _currectCheck = arry;
    }
    return _currectCheck;
}


+ (void)saveCheck:(Check *)check
{
    NSMutableArray* arry=[self getCheckArryWithCoding];
    BOOL flg = NO;//是否有重复
    for (Check* i in arry) {
         if(i.ID == check.ID)flg = YES;
    }
 
    if(!flg)
    {
        [arry addObject:check];
        
        [NSKeyedArchiver archiveRootObject:arry toFile:kCheckCollectFile];
    }
}
+(BOOL)existCorrentCheck:(NSInteger)ID
{
    NSMutableArray* arry = [self getCheckArryWithCoding];
    for(Check* i in arry)
    {
        if(i.ID == ID)return YES;
    }
    return NO;
}
+(void)deleteCheck:(Check *)check
{
    NSMutableArray* arry = [self getCheckArryWithCoding];
    for (Check* i in arry) {
        if(i.ID == check.ID)
        {
            [arry removeObject:i];
            break;
        }
    }
    
    [NSKeyedArchiver archiveRootObject:arry toFile:kCheckCollectFile];
    
}
+(id)getSearchData:(id)dic
{
    Check* check = [[Check alloc]initWithSearchDict:dic];
    return check;
    
}
+(id)getData:(id)dic
{
    return [[Check alloc]initWithDict:dic];
}
+(id)getTypeData:(id)dic
{
    return [[Check alloc] initWithDict:dic];
}


+(NSMutableArray*)getCheckClass
{
    _checkClass = [[NSMutableArray alloc]init];
    [_checkClass addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithFile:kCheckClassFile]];
    return _checkClass;
}
+(void)saveCheckClass:(NSArray *)check
{
    
    [NSKeyedArchiver archiveRootObject:check toFile:kCheckClassFile];
    
}

//#program mark 数据库
+(void)TypeWithParam:(NSDictionary *)param success:(TypeSuccess)success failure:(TypeFailure)failure
{
    [self initPath];

    //先判断内存是否存在;
    if(_checkClass > 0)
    {
        MyLog(@"从内存获取检查分类成功");
        success(_checkClass);
        return;
    }
    //否则从磁盘获取
    _checkClass = [self getCheckClass];
    if (_checkClass.count > 0) {
        success(_checkClass);
        MyLog(@"从磁盘获取检查分类成功");
        
        
    }else{
        //否则从网络下载
        [super TypeWithParam:@{@"id":@(0)} success:^(NSArray *check) {
            [_checkClass addObjectsFromArray:check];
            MyLog(@"从网络获取检查分类成功");
            
            //保存文件
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self saveCheckClass:_checkClass];
                MyLog(@"保存检查分类到磁盘成功");
                
            });
            
            success(_checkClass);
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
        
        arry = [[CheckSQLiteManager sharedCheckSQLiteManager] queryCheckWithFilter:filter limit:20 offset:_offlineListNumber];
        _offlineListNumber +=arry.count;
        success(arry);
        return;
    }
    //缓存状态
    if ([[ConnentTool sharedConnentTool] mainScanType] == kscanTypeCache) {
        //获取信息列表
        [super ListWithParam:param success:^(NSArray* obj){
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                for (Check* i in obj)
                {
                    NSDictionary* dic=@{@"id":@(i.ID)};
                    //正常状态,先判断数据库是否有详细数据,没有则下载否则不作为;
                    NSString* filter = [NSString stringWithFormat:@" id = %d and detailMessage != '(null)' ",i.ID];
                    //判断是否存在详细内容在数据库;
                    NSArray* Checks = [[CheckSQLiteManager sharedCheckSQLiteManager]queryCheckWithFilter:filter];
                    if (Checks.count != 0)return;         //数据库存在,不需要保存;
                    
                    
                    //否则网络下载
                    [super DetailWithParam:dic success:^( Check* obj){
                        
                        //将列表简介与详细内容组合
                            obj = [self combineCheckWithSoc:obj desc:i];
                        //删除已经存在的简介信息
                            [[CheckSQLiteManager sharedCheckSQLiteManager]removeCheck:obj.ID];
                        
                            //保存详细内容
                            [[CheckSQLiteManager sharedCheckSQLiteManager]addCheck:obj];
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
            for (Check* i in obj) {
                [[CheckSQLiteManager sharedCheckSQLiteManager]addCheck:i];
            }
        });
        
        success(obj);
    }  failure:failure];
    //    [super ListWithParam:param success:success failure:failure]
    
}
+ (void)SerachWithParam:(NSDictionary*)param  success:(Success)success failure:(Failure)failure
{
    
    [self initPath];

//        NSDictionary* dic = @{@"id":@"integer PRIMARY KEY", @"name":@"text",@"scanTimes":@"integer",@"tag":@"text",@"detailMessage":@"text",@"image":@"text",@"menu":@"text",@"summary":@"text"};
    //离线状态
    if ([[ConnentTool sharedConnentTool] mainScanType] == kscanTypeWithoutNet) {
        NSArray* arry;
        
        //查询关键字
        NSString* keyWord = [param objectForKey:@"keyword"];
        NSString* filter = [NSString stringWithFormat:@" name LIKE  '%%%@%%' or title LIKE '%%%@%%' or content LIKE '%%%@%%' ",keyWord,keyWord,keyWord];
        arry = [[CheckSQLiteManager sharedCheckSQLiteManager] queryCheckWithFilter:filter limit:20 offset:_offlineSerachNumber];
        _offlineSerachNumber += arry.count;
        success(arry);
        return;
    }
    
    
    //缓存状态
    if ([[ConnentTool sharedConnentTool] mainScanType] == kscanTypeCache) {
        //获取信息列表
        [super SerachWithParam:param success:^(NSArray* obj){
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                for (Check* i in obj)
                {
                    NSDictionary* dic=@{@"id":@(i.ID)};
                    //正常状态,先判断数据库是否有详细数据,没有则下载否则不作为;
                    NSString* filter = [NSString stringWithFormat:@" id = %d and detailMessage != '(null)' ",i.ID];
                    //判断是否存在详细内容在数据库;
                    NSArray* Checks = [[CheckSQLiteManager sharedCheckSQLiteManager]queryCheckWithFilter:filter];
                    if (Checks.count != 0)return;         //数据库存在,不需要保存;
                    //否则网络下载
                    [super DetailWithParam:dic success:^( Check* obj){
                        
                        //将列表简介与详细内容组合
                        obj = [self combineCheckWithSoc:obj desc:i];
                        //删除已经存在的简介信息
                        [[CheckSQLiteManager sharedCheckSQLiteManager]removeCheck:obj.ID];
                        
                        //保存详细内容
                        [[CheckSQLiteManager sharedCheckSQLiteManager]addCheck:obj];
                    }failure:failure];
                }
            });
            success(obj);
        }failure:failure];
        return;
    }
    

  
    
    //正常状态,获得数据后存储信息列表
    [super SerachWithParam:param success:^(NSArray* obj){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            for (Check* i in obj) {
                [[CheckSQLiteManager sharedCheckSQLiteManager]addCheck:i];
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
        Check* arry;
        arry = [[CheckSQLiteManager sharedCheckSQLiteManager] queryCheckWithCheckID:ID];
        success(arry);
        return;
    }
    
    //正常状态,先判断数据库是否有详细数据,没有则下载,保存,否则直接使用数据库数据;
    NSString* filter = [NSString stringWithFormat:@" id = %d and detailMessage != '(null)' ",ID];
    //判断是否存在详细内容在数据库;
    NSArray* Checks = [[CheckSQLiteManager sharedCheckSQLiteManager]queryCheckWithFilter:filter];
    if (Checks.count != 0) {
        
        Check* temCheck = Checks[0];
        success(temCheck);
        return;
    }
    
    //网络下载
    [super DetailWithParam:param success:^( Check* obj){
        __block Check* blockObj = obj;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            Check* Check = [[CheckSQLiteManager sharedCheckSQLiteManager]queryCheckWithCheckID:blockObj.ID];
            
            if (Check != nil) {
                //如果只存在不完整的搜索信息,则组合,删除,重写
                blockObj = [self combineCheckWithSoc:obj desc:Check];
                [[CheckSQLiteManager sharedCheckSQLiteManager]removeCheck:obj.ID];
            }
            //保存
            [[CheckSQLiteManager sharedCheckSQLiteManager]addCheck:blockObj];
            
        });
        
        success(obj);
    }failure:failure];
    
    
    
}

+(Check* )combineCheckWithSoc:(Check*)soc desc:(Check*)desc
{
    //[@"id",@"name",@"scanTimes",@"tag",@"detailMessage",@"image",@"Check",@"bar"];
    if (soc.tag == nil)soc.tag = desc.tag;
    if (soc.detailMessage == nil)soc.detailMessage = desc.detailMessage;
    if (soc.image == nil)soc.image = desc.image;
    if (soc.menu == nil)soc.menu = desc.menu;
    if (soc.summary == nil)soc.summary = desc.summary;
    if (soc.title == nil)soc.title = desc.title;
    if (soc.content == nil)soc.content = desc.content;
    return soc;
}


@end
