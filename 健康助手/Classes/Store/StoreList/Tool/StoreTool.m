//
//  StoreTool.m
//  健康助手
//
//  Created by 未成年大叔 on 15/7/23.
//  Copyright (c) 2015年 itcast. All rights reserved.
//
// 文件路径


#import "StoreTool.h"
#import "bHttpTool.h"
#import "HomeBaseTool.h"
#import "Store.h"
#import "Healthcfg.h"
#import "StoreSQLiteManager.h"
#import "ConnentTool.h"
@implementation StoreTool
static NSInteger _offlineListNumber;//离线状态下列表的总数据;用于防止重复浏览
static NSInteger _offlineSerachNumber;//离线状态下查询的总数据;用于防止重复浏览

static NSMutableArray* _storeClass;
static NSMutableArray* _currectStore;

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
    [self initWithList:storeList class:nil search:storeSerach detail:storeDetail dataFile:storeDataFile appkey:storeAppKey];
}


+ (NSMutableArray*)getStoreArryWithCoding
{
    if(_currectStore == nil)
    {
        NSMutableArray* arry = [[NSMutableArray alloc]init];
        [arry addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithFile:kStoreCollectFile]];
        _currectStore = arry;
    }
    return _currectStore;
}



+ (void)saveStore:(Store *)store
{
    NSMutableArray* arry=[self getStoreArryWithCoding];
    BOOL flg = NO;//是否有重复
    for (Store* i in arry) {
        if(i.ID == store.ID)flg = YES;
    }
    
    if(!flg)[arry addObject:store];
    
    [NSKeyedArchiver archiveRootObject:arry toFile:kStoreCollectFile];
}
+(BOOL)existCorrentStore:(NSInteger)ID
{
    NSMutableArray* arry = [self getStoreArryWithCoding];
    for(Store* i in arry)
    {
        if(i.ID == ID)return YES;
    }
    return NO;
}
+(void)deleteStore:(Store *)store
{
    NSMutableArray* arry = [self getStoreArryWithCoding];
    for (Store* i in arry) {
        if(i.ID == store.ID)
        {
            [arry removeObject:i];
            break;
        }
    }
    
    [NSKeyedArchiver archiveRootObject:arry toFile:kStoreCollectFile];
    
}







+(id)getSearchData:(id)dic
{
    [self initPath];
    Store* store = [[Store alloc]initWithSearchDict:dic];
    return store;
    
}

+(id)getData:(id)dic
{
    return [[Store alloc]initWithDict:dic];
}
+(id)getTypeData:(id)dic
{
    return [[Store alloc]initWithDict:dic];
}
+(NSMutableArray*)getStoreClass
{
    [self initPath];

    _storeClass = [[NSMutableArray alloc]init];
    [_storeClass addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithFile:kStoreClassFile]];
    return _storeClass;
}
+(void)saveStoreClass:(NSArray *)stores
{
    
    [NSKeyedArchiver archiveRootObject:stores toFile:kStoreClassFile];
    
}

//#program mark 数据库
+(void)TypeWithParam:(NSDictionary *)param success:(TypeSuccess)success failure:(TypeFailure)failure
{
    [self initPath];

    //先判断内存是否存在;
    if(_storeClass > 0)
    {
        MyLog(@"从内存获取疾病分类成功");
        success(_storeClass);
        return;
    }
    //否则从磁盘获取
    _storeClass = [self getStoreClass];
    if (_storeClass.count > 0) {
        success(_storeClass);
        MyLog(@"从磁盘获取疾病分类成功");

        
    }else{
        //否则从网络下载
        [super TypeWithParam:@{@"id":@(0)} success:^(NSArray *store) {
            [_storeClass addObjectsFromArray:store];
            MyLog(@"从网络获取疾病分类成功");

            //保存文件
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self saveStoreClass:_storeClass];
                MyLog(@"保存疾病分类到磁盘成功");

            });
            
            success(_storeClass);
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
        
        arry = [[StoreSQLiteManager sharedStoreSQLiteManager] queryStoreWithFilter:nil limit:20 offset:_offlineListNumber];
        _offlineListNumber +=arry.count;
        success(arry);
        return;
    }
    
    
    //缓存状态
    if ([[ConnentTool sharedConnentTool] mainScanType] == kscanTypeCache) {
        //获取信息列表
        [super ListWithParam:param success:^(NSArray* obj){
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                for (Store* i in obj)
                {
                    NSDictionary* dic=@{@"id":@(i.ID)};
                    //正常状态,先判断数据库是否有详细数据,没有则下载否则不作为;
                    NSString* filter = [NSString stringWithFormat:@" id = %d and tel != '(null)' ",(int)(i.ID)];
                    //判断是否存在详细内容在数据库;
                    NSArray* Stores = [[StoreSQLiteManager sharedStoreSQLiteManager]queryStoreWithFilter:filter];
                    if (Stores.count != 0)return;         //数据库存在,不需要保存;
                    
                    
                    //否则网络下载
                    [super DetailWithParam:dic success:^( Store* obj){
                        
                        //将列表简介与详细内容组合
                        obj = [self combineStoreWithSoc:obj desc:i];
                        //删除已经存在的简介信息
                        [[StoreSQLiteManager sharedStoreSQLiteManager]removeStore:obj.ID];
                        
                        //保存详细内容
                        [[StoreSQLiteManager sharedStoreSQLiteManager]addStore:obj];
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
            for (Store* i in obj) {
                [[StoreSQLiteManager sharedStoreSQLiteManager]addStore:i];
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
        arry = [[StoreSQLiteManager sharedStoreSQLiteManager] queryStoreWithFilter:filter limit:20 offset:_offlineSerachNumber];
        _offlineSerachNumber += arry.count;
        success(arry);
        return;
    }
    
    
    
    //缓存状态
    if ([[ConnentTool sharedConnentTool] mainScanType] == kscanTypeCache) {
        //获取信息列表
        [super SerachWithParam:param success:^(NSArray* obj){
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                for (Store* i in obj)
                {
                    NSDictionary* dic=@{@"id":@(i.ID)};
                    //正常状态,先判断数据库是否有详细数据,没有则下载否则不作为;
                    NSString* filter = [NSString stringWithFormat:@" id = %d and detailMessage != '(null)' ",(int)(i.ID)];
                    //判断是否存在详细内容在数据库;
                    NSArray* Stores = [[StoreSQLiteManager sharedStoreSQLiteManager]queryStoreWithFilter:filter];
                    if (Stores.count != 0)return;         //数据库存在,不需要保存;
                    
                    
                    //否则网络下载
                    [super DetailWithParam:dic success:^( Store* obj){
                        
                        //将列表简介与详细内容组合
                        obj = [self combineStoreWithSoc:obj desc:i];
                        //删除已经存在的简介信息
                        [[StoreSQLiteManager sharedStoreSQLiteManager]removeStore:obj.ID];
                        
                        //保存详细内容
                        [[StoreSQLiteManager sharedStoreSQLiteManager]addStore:obj];
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
            for (Store* i in obj) {
                [[StoreSQLiteManager sharedStoreSQLiteManager]addStore:i];
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
        Store* arry;
        arry = [[StoreSQLiteManager sharedStoreSQLiteManager] queryStoreWithStoreID:ID];
        success(arry);
        return;
    }
    
    //正常状态,先判断数据库是否有详细数据,没有则下载,保存,否则直接使用数据库数据;
    NSString* filter = [NSString stringWithFormat:@" id = %ld and id != '(null)' ",(long)ID];
    //判断是否存在详细内容在数据库;
    NSArray* Stores = [[StoreSQLiteManager sharedStoreSQLiteManager]queryStoreWithFilter:filter];
    if (Stores.count != 0) {
        
        Store* temStore = Stores[0];
        success(temStore);
        return;
    }
    
    //网络下载
    [super DetailWithParam:param success:^( Store* obj){
        __block Store* blockObj = obj;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            Store* Store = [[StoreSQLiteManager sharedStoreSQLiteManager]queryStoreWithStoreID:blockObj.ID];

            if (Store != nil) {
                //如果只存在不完整的搜索信息,则组合,删除,重写
                blockObj = [self combineStoreWithSoc:obj desc:Store];
                [[StoreSQLiteManager sharedStoreSQLiteManager]removeStore:obj.ID];
                }
            //保存
            [[StoreSQLiteManager sharedStoreSQLiteManager]addStore:blockObj];

        });
        
        success(obj);
    }failure:failure];
}
//@"address",@"tel",@"zipcode",@"type",@"number",@"localY",@"charge",@"Store",@"StoreText",@"food",@"foodText",@"store",@"leader",@"business",@"createdate",@"title",@"content"

+ (void)LocalListWithParam:(NSDictionary*)param  success:(DetailSuccess)success failure:(DetailFailure)failure
{
    
}
+(Store* )combineStoreWithSoc:(Store*)soc desc:(Store*)desc
{
    if (soc.tag == nil)soc.tag = desc.tag;
    if (soc.detailMessage == nil)soc.detailMessage = desc.detailMessage;
    if (soc.image == nil)soc.image = desc.image;
    if (soc.address == nil)soc.address = desc.address;
    if (soc.tel == nil)soc.tel = desc.tel;
    if (soc.zipcode == nil)soc.zipcode = desc.zipcode;
    if (soc.type == nil)soc.type = desc.type;
    if (soc.number == nil)soc.number = desc.number;
    soc.localY = desc.localY;
    soc.localX = desc.localX;
    if (soc.charge == nil)soc.charge = desc.charge;
    if (soc.leader == nil)soc.leader = desc.leader;
    if (soc.food == nil)soc.food = desc.food;
    if (soc.foodText == nil)soc.foodText = desc.foodText;
    if (soc.leader == nil)soc.leader = desc.leader;
    if (soc.business == nil)soc.business = desc.business;
    if (soc.createdate == nil)soc.createdate = desc.createdate;
    if (soc.title == nil)soc.title = desc.title;
    if (soc.content == nil)soc.content = desc.content;

    return soc;
}

@end
