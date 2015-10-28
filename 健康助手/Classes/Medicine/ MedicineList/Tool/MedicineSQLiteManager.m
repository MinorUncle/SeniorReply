//
//  MedicineSQLiteManager.m
//  健康助手
//
//  Created by 未成年大叔 on 15/8/7.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "MedicineSQLiteManager.h"
#import "Sqlite3Tool.h"

#define TABLE_NAME @"Medicine_t"
#define CLOUMN_NAME @""

@interface MedicineSQLiteManager()
{
    // SQLite数据库的连接，基于该连接可以进行数据库操作
    Sqlite3Tool *_sqlTool;
    NSString* _tableName;
    NSString* _cloumnName;
}
@end
@implementation MedicineSQLiteManager
single_implementation(MedicineSQLiteManager)

// 在初始化方法中完成数据库连接工作
- (id)init
{
    self = [super init];
    
    if (self) {
        // 1. sqlitetool对象
        _sqlTool = [[Sqlite3Tool alloc]init];
        _tableName = TABLE_NAME;
        _cloumnName = CLOUMN_NAME;
        [self createTable];
    }
    return self;
}

#pragma mark - 数据库操作方法
/**
 *  打开数据库
 */



/**
 *  创建数据表
 *   member为列属性,列名为key,属性为value
 */
//
//@property(nonatomic,copy)NSString* type;            //药品类型
//@property(nonatomic,copy)NSString* factory;             //工厂
//@property(nonatomic,copy)NSString* ANumber;   //编号
//@property(nonatomic,copy)NSString* categroyNmae;  //药品分类
//@property(nonatomic,assign)int category;  //分类id
//@property(nonatomic,copy)NSString* title;  //药品搜索名称
//



#pragma mark - 成员方法
// 新增个人记录
- (void)addMedicine:(Medicine *)medicine
{
    NSDictionary* valus = @{@"name":[NSString stringWithFormat:@"'%@'", medicine.name],@"id":@(medicine.ID),@"scanTimes":[NSString stringWithFormat:@"'%@'", @(medicine.scanTimes)],@"tag":[NSString stringWithFormat:@"'%@'",medicine.tag],@"detailMessage":[NSString stringWithFormat:@"'%@'",medicine.detailMessage],@"image":[NSString stringWithFormat:@"'%@'",medicine.image],@"type":[NSString stringWithFormat:@"'%@'",medicine.type],@"factory":[NSString stringWithFormat:@"'%@'",medicine.factory],@"ANumber":[NSString stringWithFormat:@"'%@'",medicine.ANumber],@"categroyNmae":[NSString stringWithFormat:@"'%@'",medicine.categroyNmae],@"category":[NSString stringWithFormat:@"'%ld'",(long)(medicine.category)],@"title":[NSString stringWithFormat:@"'%@'",medicine.title],@"content":[NSString stringWithFormat:@"'%@'",medicine.content]};
    
    
    [_sqlTool insertWithTableName:_tableName values:valus];
    //[self execSql:sql msg:@"添加个人记录"];
}

-(void)createTable
{
    
    NSDictionary* dic = @{@"id":@"integer PRIMARY KEY", @"name":@"text",@"scanTimes":@"integer",@"tag":@"text",@"detailMessage":@"text",@"image":@"text",@"type":@"text",@"factory":@"text",@"ANumber":@"text",@"categroyNmae":@"text",@"category":@"integer",@"title":@"text",@"content":@"text"};
    [_sqlTool createTableWithName:_tableName member:dic];
}

-(BOOL)isExistWithID:(NSInteger)personID
{
    return [_sqlTool isExistWithTableName:TABLE_NAME keyFilter:[NSString stringWithFormat:@" id = %@",@(personID)]];
}
-(BOOL)isExistWithID:(NSInteger)personID notNullColumnName:(NSString*)cloumnN
{
    return [_sqlTool isExistWithTableName:TABLE_NAME keyFilter:[NSString stringWithFormat:@" id = %@ and %@ IS NOT NULL",@(personID),cloumnN]];
}

-(NSArray*)queryMedicineWithFilter:(NSString* )filter limit:(NSInteger)limit offset:(NSInteger)offset
{
    NSString* name = _tableName;
    NSArray* cloumnN = @[@"id",@"name",@"scanTimes",@"tag",@"detailMessage",@"image",@"type",@"factory",@"ANumber",@"categroyNmae",@"category",@"title",@"content"];
    
    NSArray* p = [_sqlTool queryObjectsWithTableName:name cloumnName:cloumnN filter:filter limit:limit offset:offset stmt:^(sqlite3_stmt *stmt, NSMutableArray *arry) {
        NSInteger ID = sqlite3_column_int(stmt, 0);
        const unsigned char *name = sqlite3_column_text(stmt, 1);
        NSInteger scanTimes = sqlite3_column_int(stmt, 2);
        const unsigned char *tag = sqlite3_column_text(stmt, 3);
        const unsigned char *detailMessage = sqlite3_column_text(stmt, 4);
        const unsigned char *image = sqlite3_column_text(stmt, 5);
        const unsigned char *type = sqlite3_column_text(stmt, 6);
        const unsigned char *factory = sqlite3_column_text(stmt, 7);
        const unsigned char *ANumber = sqlite3_column_text(stmt, 8);
        const unsigned char *categroyNmae = sqlite3_column_text(stmt, 9);
        NSInteger category = sqlite3_column_int(stmt, 10);
        const unsigned char *title = sqlite3_column_text(stmt, 11);
        const unsigned char *content = sqlite3_column_text(stmt, 12);


        
        
        
        
        
        NSString* nameUTF8 = [NSString stringWithUTF8String:(const char*)name];
        NSString* tagUTF8 = [NSString stringWithUTF8String:(const char*)tag];
        NSString* detailMessageUTF8 = [NSString stringWithUTF8String:(const char*)detailMessage];
        NSString* imageUTF8 = [NSString stringWithUTF8String:(const char*)image];
        NSString* typeUTF8 = [NSString stringWithUTF8String:(const char*)type];
        NSString* factoryUTF8 = [NSString stringWithUTF8String:(const char*)factory];
        NSString* ANumberUTF8 = [NSString stringWithUTF8String:(const char*)ANumber];
        NSString* categroyNmaeUTF8 = [NSString stringWithUTF8String:(const char*)categroyNmae];
        NSString* titleUTF8 = [NSString stringWithUTF8String:(const char*)title];
        NSString* contentUTF8 = [NSString stringWithUTF8String:(const char*)content];


        [arry addObject:@(ID)];
        [arry addObject:nameUTF8];
        [arry addObject:@(scanTimes)];
        [arry addObject:tagUTF8];
        [arry addObject:detailMessageUTF8];
        [arry addObject:imageUTF8];
        [arry addObject:typeUTF8];
        [arry addObject:factoryUTF8];
        [arry addObject:ANumberUTF8];
        [arry addObject:categroyNmaeUTF8];
        [arry addObject:@(category)];
        [arry addObject:titleUTF8];
        [arry addObject:contentUTF8];
    }];
    
    
    //打包medicine;
    //顺序一定要与前面cloumnN一致
    NSMutableArray* medicines = [[NSMutableArray  alloc]init];
    for (NSArray* i in p) {
        Medicine * medicine = [[Medicine alloc]init];
        medicine.ID = [i[0] intValue];
        medicine.name = i[1];
        medicine.scanTimes = [i[2] intValue];
        medicine.tag = i[3];
        medicine.detailMessage = i[4];
        medicine.image = i[5];
        medicine.type = i[6];
        medicine.factory = i[7];
        medicine.ANumber = i[8];
        medicine.categroyNmae = i[9];
        medicine.category = [i[10] integerValue];
        medicine.title = i[11];
        medicine.content = i[12];
      
        
        if([medicine.title isEqualToString:@"(null)"])medicine.title = medicine.name;
        else  medicine.name = medicine.title;

        
        [medicines addObject:medicine];
    }
    return medicines;
}
-(NSArray *)queryMedicine
{
    return [self queryMedicineWithFilter:nil];
}
-(Medicine *)queryMedicineWithMedicineID:(NSInteger)ID
{
    NSString* filter = [NSString stringWithFormat:@" id = %d",(int)ID];
    NSArray* MedicineArry = [self queryMedicineWithFilter:filter];
    Medicine* medicine ;
    if(MedicineArry.count > 0)medicine= MedicineArry[0];
    return medicine;
}

-(NSArray*)queryMedicineWithFilter:(NSString* )filter
{
    return [self queryMedicineWithFilter:filter limit:0 offset:0];
}

// 修改个人记录(修改传入Person对象ID对应的数据库记录的内容)
//- (void)updatePerson:(Person *)person
//{
//    
//}

// 删除个人记录
- (int)removeMedicine:(NSInteger)medicineID
{
    //    NSDictionary* dic = @{@"id":@(personID)};
    NSString* filter = [NSString stringWithFormat:@" id = %d",(int)medicineID];
    return [_sqlTool deleteWithTableName:TABLE_NAME filter:filter];
}

@end
