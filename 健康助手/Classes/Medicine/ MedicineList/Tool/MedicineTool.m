//
//  MedicineTool.m
//  健康助手
//
//  Created by 未成年大叔 on 15/7/23.
//  Copyright (c) 2015年 itcast. All rights reserved.
//
// 文件路径


#import "MedicineTool.h"
#import "bHttpTool.h"
#import "Medicine.h"
#import "Healthcfg.h"
#import "MedicineSQLiteManager.h"
#import "ConnentTool.h"
@implementation MedicineTool

static NSInteger _offlineListNumber;//离线状态下列表的总数据;用于防止重复浏览
static NSInteger _offlineSerachNumber;//离线状态下查询的总数据;用于防止重复浏览

static NSMutableArray* _medicineClass;
static NSMutableArray* _currectMedicine;


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
    [self initWithList:medicineList class:medicineClass search:medicineSerach detail:medicineDetail dataFile:medicineDataFile appkey:medicineAppKey];
}



+ (NSMutableArray*)getMedicineArryWithCoding
{
    if(_currectMedicine == nil)
    {
        NSMutableArray* arry = [[NSMutableArray alloc]init];
        [arry addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithFile:kMedicineCollectFile]];
        _currectMedicine = arry;
    }
    return _currectMedicine;
}



+ (void)saveMedicine:(Medicine *)medicine
{
    NSMutableArray* arry=[self getMedicineArryWithCoding];
    BOOL flg = NO;//是否有重复
    for (Medicine* i in arry) {
        if(i.ID == medicine.ID)flg = YES;
    }
    
    if(!flg)[arry addObject:medicine];
    
    [NSKeyedArchiver archiveRootObject:arry toFile:kMedicineCollectFile];
}
+(BOOL)existCorrentMedicine:(NSInteger)ID
{
    NSMutableArray* arry = [self getMedicineArryWithCoding];
    for(Medicine* i in arry)
    {
        if(i.ID == ID)return YES;
    }
    return NO;
}
+(void)deleteMedicine:(Medicine *)medicine
{
    NSMutableArray* arry = [self getMedicineArryWithCoding];
    for (Medicine* i in arry) {
        if(i.ID == medicine.ID)
        {
            [arry removeObject:i];
            break;
        }
    }
    
    [NSKeyedArchiver archiveRootObject:arry toFile:kMedicineCollectFile];
    
}

+(id)getSearchData:(id)dic
{
    Medicine* medic = [[Medicine alloc]initWithSearchDict:dic];
    return medic;
    
}
+(id)getData:(id)dic
{
    return [[Medicine alloc]initWithDict:dic];
}
+(id)getTypeData:(id)dic
{
    return  [[Medicine alloc]initWithSearchDict:dic];
}


+(NSMutableArray*)getMedicineClass
{
    _medicineClass = [[NSMutableArray alloc]init];
    [_medicineClass addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithFile:kMedicineClassFile]];
    return _medicineClass;
}
+(void)saveMedicineClass:(NSArray *)Medicines
{
    
    [NSKeyedArchiver archiveRootObject:Medicines toFile:kMedicineClassFile];
    
}

//#program mark 数据库
+(void)TypeWithParam:(NSDictionary *)param success:(TypeSuccess)success failure:(TypeFailure)failure
{
    [self initPath];

    //先判断内存是否存在;
    if(_medicineClass > 0)
    {
        MyLog(@"从内存获取药物分类成功");
        success(_medicineClass);
        return;
    }
    //否则从磁盘获取
    _medicineClass = [self getMedicineClass];
    if (_medicineClass.count > 0) {
        success(_medicineClass);
        MyLog(@"从磁盘获取药物分类成功");
        
        
    }else{
        //否则从网络下载
        [super TypeWithParam:@{@"id":@(0)} success:^(NSArray *Medicine) {
            [_medicineClass addObjectsFromArray:Medicine];
            MyLog(@"从网络获取药物分类成功");
            
            //保存文件
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self saveMedicineClass:_medicineClass];
                MyLog(@"保存药物分类到磁盘成功");
                
            });
            
            success(_medicineClass);
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
        
        arry = [[MedicineSQLiteManager sharedMedicineSQLiteManager] queryMedicineWithFilter:nil limit:20 offset:_offlineListNumber];
        _offlineListNumber +=arry.count;
        success(arry);
        return;
    }
    
    
    //缓存状态
    if ([[ConnentTool sharedConnentTool] mainScanType] == kscanTypeCache) {
        //获取信息列表
        [super ListWithParam:param success:^(NSArray* obj){
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                dispatch_queue_t p = dispatch_queue_create("p", DISPATCH_QUEUE_SERIAL);
                for (Medicine* i in obj)
                {
                    NSDictionary* dic=@{@"id":@(i.ID)};
                    //正常状态,先判断数据库是否有详细数据,没有则下载否则不作为;
                    NSString* filter = [NSString stringWithFormat:@" id = %ld and detailMessage != '(null)' ",(long)i.ID];
                    //判断是否存在详细内容在数据库;
                    NSArray* Medicines = [[MedicineSQLiteManager sharedMedicineSQLiteManager]queryMedicineWithFilter:filter];
                    if (Medicines.count != 0)return;         //数据库存在,不需要保存;
                    
                    [NSThread currentThread];
                    
                    //否则网络下载
                    [super DetailWithParam:dic success:^( Medicine* obj){
                        
                        //将列表简介与详细内容组合
                        obj = [self combineMedicineWithSoc:obj desc:i];
                     //   dispatch_async(dispatch_get_main_queue(), ^{
                            //删除已经存在的简介信息
                            [[MedicineSQLiteManager sharedMedicineSQLiteManager]removeMedicine:obj.ID];
                            
                            //保存详细内容
                            [[MedicineSQLiteManager sharedMedicineSQLiteManager]addMedicine:obj];
                    //    });
                        
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
            for (Medicine* i in obj) {
                [[MedicineSQLiteManager sharedMedicineSQLiteManager]addMedicine:i];
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
        NSString* filter = [NSString stringWithFormat:@" name LIKE  '%%%@%%' or content LIKE '%%%@%%' or title LIKE '%%%@%%' ",keyWord,keyWord,keyWord];
        arry = [[MedicineSQLiteManager sharedMedicineSQLiteManager] queryMedicineWithFilter:filter limit:20 offset:_offlineSerachNumber];
        _offlineSerachNumber += arry.count;
        success(arry);
        return;
    }
    
   
    
    //缓存状态
    if ([[ConnentTool sharedConnentTool] mainScanType] == kscanTypeCache) {
        //获取信息列表
        [super SerachWithParam:param success:^(NSArray* obj){
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                for (Medicine* i in obj)
                {
                    NSDictionary* dic=@{@"id":@(i.ID)};
                    //正常状态,先判断数据库是否有详细数据,没有则下载否则不作为;
                    NSString* filter = [NSString stringWithFormat:@" id = %ld and detailMessage != '(null)' ",(long)i.ID];
                    //判断是否存在详细内容在数据库;
                    NSArray* Medicines = [[MedicineSQLiteManager sharedMedicineSQLiteManager]queryMedicineWithFilter:filter];
                    if (Medicines.count != 0)return;         //数据库存在,不需要保存;
                    
                    
                    //否则网络下载
                    [super DetailWithParam:dic success:^( Medicine* obj){
                        
                        //将列表简介与详细内容组合
                        obj = [self combineMedicineWithSoc:obj desc:i];
                        //删除已经存在的简介信息
                        [[MedicineSQLiteManager sharedMedicineSQLiteManager]removeMedicine:obj.ID];
                        
                        //保存详细内容
                        [[MedicineSQLiteManager sharedMedicineSQLiteManager]addMedicine:obj];
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
            for (Medicine* i in obj) {
                [[MedicineSQLiteManager sharedMedicineSQLiteManager]addMedicine:i];
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
        Medicine* arry;
        arry = [[MedicineSQLiteManager sharedMedicineSQLiteManager] queryMedicineWithMedicineID:ID];
        success(arry);
        return;
    }
    //正常状态,先判断数据库是否有详细数据,没有则下载,保存,否则直接使用数据库数据;
    NSString* filter = [NSString stringWithFormat:@" id = %ld and detailMessage != '(null)' ",(long)ID];
    //判断是否存在详细内容在数据库;
    NSArray* Medicines = [[MedicineSQLiteManager sharedMedicineSQLiteManager]queryMedicineWithFilter:filter];
    if (Medicines.count != 0) {
        
        Medicine* temMedicine = Medicines[0];
        success(temMedicine);
        return;
    }
    
    //网络下载
    [super DetailWithParam:param success:^( Medicine* obj){
        __block Medicine* blockObj = obj;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            Medicine* Medicine = [[MedicineSQLiteManager sharedMedicineSQLiteManager]queryMedicineWithMedicineID:blockObj.ID];
            
            if (Medicine != nil) {
                //如果只存在不完整的搜索信息,则组合,删除,重写
                blockObj = [self combineMedicineWithSoc:obj desc:Medicine];
                [[MedicineSQLiteManager sharedMedicineSQLiteManager]removeMedicine:obj.ID];
            }
            //保存
            [[MedicineSQLiteManager sharedMedicineSQLiteManager]addMedicine:blockObj];
            
        });
        
        success(obj);
    }failure:failure];
    
}


+(Medicine* )combineMedicineWithSoc:(Medicine*)soc desc:(Medicine*)desc
{
    if (soc.tag == nil)soc.tag = desc.tag;
    if (soc.detailMessage == nil)soc.detailMessage = desc.detailMessage;
    if (soc.image == nil)soc.image = desc.image;
    if (soc.type == nil)soc.type = desc.type;
    if (soc.factory == nil)soc.factory = desc.factory;
    if (soc.ANumber == nil)soc.ANumber = desc.ANumber;
    if (soc.categroyNmae == nil)soc.categroyNmae = desc.categroyNmae;
    if (soc.category == 0)soc.category = desc.category;
    if (soc.title == nil)soc.title = desc.title;
    if (soc.content == nil)soc.content = desc.content;

    return soc;
}

@end
