//
//  MedicineTool.m
//  健康助手
//
//  Created by 未成年大叔 on 15/7/23.
//  Copyright (c) 2015年 itcast. All rights reserved.
//
// 文件路径

#import "FoodTool.h"
#import "bHttpTool.h"
#import "HomeBaseTool.h"
#import "Food.h"
#import "Healthcfg.h"
#import "FoodSQLiteManager.h"
#import "ConnentTool.h"
@interface FoodTool()

@end
@implementation FoodTool
static NSInteger _offlineListNumber;//离线状态下列表的总数据;用于防止重复浏览
static NSInteger _offlineSerachNumber;//离线状态下查询的总数据;用于防止重复浏览

static NSMutableDictionary* _foodClass;
static NSMutableArray * _currectFood;

+(void)initOffsetNumber
{
    
    _offlineListNumber =0;
    _offlineSerachNumber =0;
}
+(void)initPath
{
    [self initWithList:foodList class:foodClass search:foodSerach detail:foodDetail dataFile:foodDataFile appkey:foodAppKey];
}

+ (NSMutableArray*)getFoodArryWithCoding
{
    if(_currectFood == nil)
    {
        NSMutableArray* arry = [[NSMutableArray alloc]init];
        [arry addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithFile:kFoodCollectFile]];
        _currectFood = arry;
    }
    return _currectFood;
}


+ (void)saveFood:(Food *)food
{
    NSMutableArray* arry=[self getFoodArryWithCoding];
    BOOL flg = NO;//是否有重复
    for (Food* i in arry) {
        if(i.ID == food.ID)flg = YES;
    }

    if(!flg)
    {
        [arry addObject:food];

        [NSKeyedArchiver archiveRootObject:arry toFile:kFoodCollectFile];
    }
}
+(BOOL)existCorrentFood:(NSInteger)ID
{
    NSMutableArray* arry = [self getFoodArryWithCoding];
    for(Food* i in arry)
    {
        if(i.ID == ID)return YES;
    }
    return NO;
}
+(void)deleteFood:(Food *)food
{
    NSMutableArray* arry = [self getFoodArryWithCoding];
    for (Food* i in arry) {
        if(i.ID == food.ID)
        {
            [arry removeObject:i];
            break;
        }
    }

    [NSKeyedArchiver archiveRootObject:arry toFile:kFoodCollectFile];

}




+(id)getSearchData:(id)dic
{
    Food* food = [[Food alloc]initWithSearchDict:dic];
    return food;
    
}

+(id)getData:(id)dic
{
    return [[Food alloc]initWithDict:dic];
}
+(id)getTypeData:(id)dic
{
    return [[Food alloc] initWithDict:dic];
}


+(NSMutableDictionary*)getfoodClass
{
//    _foodClass = [[NSMutableDictionary alloc]init];
    _foodClass = [NSMutableDictionary dictionaryWithContentsOfFile:kFoodClassFile];
   // [_foodClass addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithFile:kClassFile]];
    return _foodClass;
}
+(BOOL)saveFoodClass:(NSMutableDictionary *)food
{
    
    return [_foodClass writeToFile:kFoodClassFile atomically:NO];
   // [NSKeyedArchiver archiveRootObject:food toFile:kClassFile];
    
}

//#program mark 数据库
+(void)TypeWithParam:(NSDictionary *)param success:(TypeSuccess)success failure:(TypeFailure)failure
{
    [self initPath];
    //先判断内存是否存在;
    if(_foodClass.count > 0)
    {
        MyLog(@"从内存获取饮食分类成功");
        NSArray* arry = [self getFoodClassFromDic:_foodClass withID:[[param objectForKey:@"id"] integerValue]];
        success(arry);
        return;
    }
    //否则从磁盘获取
    _foodClass = [self getfoodClass];
    if (_foodClass.count > 0) {
        NSArray* arry = [self getFoodClassFromDic:_foodClass withID:[[param objectForKey:@"id"] integerValue]];
        success(arry);
        MyLog(@"从磁盘获取饮食分类成功");
        
        
    }else{
        if (_foodClass == nil) {
            _foodClass = [[NSMutableDictionary alloc]init];
        }
        //否则从网络下载
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setObject:@(0) forKey:@"id"];
        
        [super TypeWithParam:dic success:^(NSArray *food) {                 //获取第一级目录
           __block int flg = 0;//所有线程是否完成标志
//        dispatch_semaphore_t sig = dispatch_semaphore_create(1);   //防止请求过快造成请求失败

            for (Food * i in food) {
                NSMutableDictionary* fristDic = [[NSMutableDictionary alloc]init];
                [fristDic setObject:i.name forKey:@"name"];
                [fristDic setObject:@(i.ID) forKey:@"id"];


                [dic setValue:@(i.ID) forKey:@"id"];
                NSLog(@"-----------%d",i.ID);
//                dispatch_semaphore_wait(sig, DISPATCH_TIME_FOREVER);
                [super TypeWithParam:dic success:^(NSArray *secondFood){            //获取第二层目录;
                    
                    NSMutableArray* secondArry = [[NSMutableArray alloc]init];
                    for (Food* foodi in secondFood)
                    {
                        NSMutableDictionary* secondDic = [[NSMutableDictionary alloc]init];
                        [secondDic setObject:foodi.name forKey:@"name"];
                        [secondDic setObject:@(foodi.ID) forKey:@"id"];
                        
                        [secondArry addObject:secondDic];
                    }
                    
                    
                    [fristDic setObject:secondArry forKey:@"arry"];
                     [_foodClass setObject:fristDic forKey:[NSString stringWithFormat:@"%ld",(long)i.ID]];            //使用精简信息,节省空间
                    
                    if (++flg == food.count) {  //所有线程下载结束
                        // [_foodClass addObjectsFromArray:food];
                        MyLog(@"从网络获取饮食分类成功");
                        
                        //保存文件  ///此处不要子线程保存
                        if([self saveFoodClass:_foodClass])MyLog(@"保存饮食分类到磁盘成功");
                        else MyLog(@"保存饮食分类到磁盘失败");
                        success([self getFoodClassFromDic:_foodClass withID:[[param objectForKey:@"id"] integerValue]]);
                    }
                
                } failure:^(NSError *err){
                    failure(err);
                }];

        }

        } failure:^(NSError *err) {
            MyLog(@"%@",err);
            failure(err);

        }];
    }
}
+(NSMutableArray* )getFoodClassFromDic:(NSDictionary* )dic withID:(NSInteger)ID
{
    [self initPath];

    NSMutableArray* arry = [[NSMutableArray alloc]init];
    
    if (ID == 0) {
        for (NSString* i in dic.allKeys) {
            NSDictionary* obj = [dic valueForKey:i];
            Food * food = [[Food alloc]init];
            food.name = [obj objectForKey:@"name"];
            food.ID = [[obj objectForKey:@"id"] integerValue];
            [arry addObject:food];
        }
    }else{
        NSDictionary* secondFood = [dic valueForKey:[NSString stringWithFormat:@"%ld",(long)ID]];
        NSArray* senondArry = [secondFood valueForKey:@"arry"];
        for (NSDictionary* i in senondArry) {
            Food * food = [[Food alloc]init];
            food.name = [i objectForKey:@"name"];
            food.ID = [[i objectForKey:@"id"] integerValue];
            [arry addObject:food];
        }
       
    }
    return arry;
    
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
        
        arry = [[FoodSQLiteManager sharedFoodSQLiteManager] queryFoodWithFilter:filter limit:20 offset:_offlineListNumber];
        _offlineListNumber +=arry.count;
        success(arry);
        return;
    }
    
    
    
    //缓存状态
    if ([[ConnentTool sharedConnentTool] mainScanType] == kscanTypeCache) {
        //获取信息列表
        [super ListWithParam:param success:^(NSArray* obj){
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                for (Food* i in obj)
                {
                    NSDictionary* dic=@{@"id":@(i.ID)};
                    //正常状态,先判断数据库是否有详细数据,没有则下载否则不作为;
                    NSString* filter = [NSString stringWithFormat:@" id = %ld and detailMessage != '(null)' ",(long)i.ID];
                    //判断是否存在详细内容在数据库;
                    NSArray* Foods = [[FoodSQLiteManager sharedFoodSQLiteManager]queryFoodWithFilter:filter];
                    if (Foods.count != 0)return;         //数据库存在,不需要保存;
                    
                    
                    //否则网络下载
                    [super DetailWithParam:dic success:^( Food* obj){
                        
                        //将列表简介与详细内容组合
                        obj = [self combineFoodWithSoc:obj desc:i];
                        //删除已经存在的简介信息
                        [[FoodSQLiteManager sharedFoodSQLiteManager]removeFood:obj.ID];
                        
                        //保存详细内容
                        [[FoodSQLiteManager sharedFoodSQLiteManager]addFood:obj];
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
            for (Food* i in obj) {
                [[FoodSQLiteManager sharedFoodSQLiteManager]addFood:i];
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
        NSString* filter = [NSString stringWithFormat:@" name LIKE  '%%%@%%' or content LIKE '%%%@%%' ",keyWord,keyWord];
        arry = [[FoodSQLiteManager sharedFoodSQLiteManager] queryFoodWithFilter:filter limit:20 offset:_offlineSerachNumber];
        _offlineSerachNumber += arry.count;
        success(arry);
        return;
    }
    
    //缓存状态
    if ([[ConnentTool sharedConnentTool] mainScanType] == kscanTypeCache) {
        //获取信息列表
        [super SerachWithParam:param success:^(NSArray* obj){
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                for (Food* i in obj)
                {
                    NSDictionary* dic=@{@"id":@(i.ID)};
                    //正常状态,先判断数据库是否有详细数据,没有则下载否则不作为;
                    NSString* filter = [NSString stringWithFormat:@" id = %ld and detailMessage != '(null)' ",(long)i.ID];
                    //判断是否存在详细内容在数据库;
                    NSArray* Foods = [[FoodSQLiteManager sharedFoodSQLiteManager]queryFoodWithFilter:filter];
                    if (Foods.count != 0)return;         //数据库存在,不需要保存;
                    
                    
                    //否则网络下载
                    [super DetailWithParam:dic success:^( Food* obj){
                        
                        //将列表简介与详细内容组合
                        obj = [self combineFoodWithSoc:obj desc:i];
                        //删除已经存在的简介信息
                        [[FoodSQLiteManager sharedFoodSQLiteManager]removeFood:obj.ID];
                        
                        //保存详细内容
                        [[FoodSQLiteManager sharedFoodSQLiteManager]addFood:obj];
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
            for (Food* i in obj) {
                [[FoodSQLiteManager sharedFoodSQLiteManager]addFood:i];
            }
        });
       
        success(obj);
    }failure:failure];
}
+ (void)DetailWithParam:(NSDictionary*)param  success:(DetailSuccess)success failure:(DetailFailure)failure
{NSLog(@"param %@",param);
    
    [self initPath];
    NSInteger ID = [[param objectForKey:@"id"] integerValue];

    //离线状态
    if ([[ConnentTool sharedConnentTool] mainScanType] == kscanTypeWithoutNet) {
        Food* arry;
        arry = [[FoodSQLiteManager sharedFoodSQLiteManager] queryFoodWithFoodID:ID];
        success(arry);
        return;
    }
    
    
    //正常状态,先判断数据库是否有详细数据,没有则下载,保存,否则直接使用数据库数据;
    NSString* filter = [NSString stringWithFormat:@" id = %ld and detailMessage != '(null)' ",(long)ID];
    //判断是否存在详细内容在数据库;
    NSArray* Foods = [[FoodSQLiteManager sharedFoodSQLiteManager]queryFoodWithFilter:filter];
    if (Foods.count > 0) {
        
        Food* temFood = Foods[0];
        success(temFood);
        return;
    }
    
    //网络下载
    [super DetailWithParam:param success:^( Food* obj){
        __block Food* blockObj = obj;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            Food* Food = [[FoodSQLiteManager sharedFoodSQLiteManager]queryFoodWithFoodID:blockObj.ID];
            
            if (Food != nil) {
                //如果只存在不完整的搜索信息,则组合,删除,重写
                blockObj = [self combineFoodWithSoc:obj desc:Food];
                [[FoodSQLiteManager sharedFoodSQLiteManager]removeFood:obj.ID];
            }
            //保存
            [[FoodSQLiteManager sharedFoodSQLiteManager]addFood:blockObj];
            
        });
        
        success(obj);
    }failure:failure];
    
    
}
//+ (void)TypeWithParam:(NSDictionary*)param  success:(TypeSuccess)success failure:(TypeFailure)failure
//{
//    //离线状态
//    if ([[ConnentTool sharedConnentTool] mainScanType] == kscanTypeWithoutNet) {
//                NSArray* arry;
//        
//        //查询关键字
//        NSString* keyWord = [param objectForKey:@"keyword"];
//        NSString* filter = [NSString stringWithFormat:@" name LIKE  '%%%@' or bar LIKE '%%%@' or tag LIKE '%%%@' ",keyWord,keyWord,keyWord];
//        arry = [[FoodSQLiteManager sharedFoodSQLiteManager] queryFoodWithFilter:filter limit:20 offset:_offlineClassNumber];
//        _offlineClassNumber += arry.count;
//        success(arry);
//        return;
//    }
//    
//    //正常状态,获得数据后存储
//    [super TypeWithParam:param success:^(NSArray* obj){
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            for (Food* i in obj) {
//                [[FoodSQLiteManager sharedFoodSQLiteManager]addFood:i];
//            }
//        });
//        success(obj);
//    }failure:failure];
//
//}
+(Food* )combineFoodWithSoc:(Food*)soc desc:(Food*)desc
{
    //[@"id",@"name",@"scanTimes",@"tag",@"detailMessage",@"image",@"food",@"bar"];
    if (soc.tag == nil)soc.tag = desc.tag;
    if (soc.detailMessage == nil)soc.detailMessage = desc.detailMessage;
    if (soc.image == nil)soc.image = desc.image;
    if (soc.food == nil)soc.food = desc.food;
    if (soc.bar == nil)soc.bar = desc.bar;
    if (soc.content == nil)soc.bar = desc.content;

    return soc;
}

@end
