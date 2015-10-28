//
//  FoodSQLiteManager.m
//  健康助手
//
//  Created by 未成年大叔 on 15/8/7.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "FoodSQLiteManager.h"
#import "Sqlite3Tool.h"

#define TABLE_NAME @"Food_t"
#define CLOUMN_NAME @""

@interface FoodSQLiteManager()
{
    // SQLite数据库的连接，基于该连接可以进行数据库操作
    Sqlite3Tool *_sqlTool;
    NSString* _tableName;
    NSString* _cloumnName;
}
@end
@implementation FoodSQLiteManager
single_implementation(FoodSQLiteManager)

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
//@property(nonatomic,copy)NSString* food;             //材料
//@property(nonatomic,copy) NSString* image;               //图片路径
//@property(nonatomic,copy) NSString* bar;               //食品主要功能

//@property(nonatomic,copy)NSString* name;            //名称
//@property(nonatomic,copy) NSString* image;               //图片路径
//@property(nonatomic,copy)NSString* detailMessage;   //详细信息
//@property(nonatomic,copy)NSString* tag;   //备注
//
//@property(nonatomic,assign)int scanTimes;              //浏览次数
//
//@property(nonatomic,assign)int ID;                     //唯一编码
//content

#pragma mark - 成员方法
// 新增个人记录
- (void)addFood:(Food *)food
{
    NSDictionary* valus = @{@"name":[NSString stringWithFormat:@"'%@'", food.name],@"id":@(food.ID),@"scanTimes":[NSString stringWithFormat:@"'%@'", @(food.scanTimes)],@"tag":[NSString stringWithFormat:@"'%@'",food.tag],@"detailMessage":[NSString stringWithFormat:@"'%@'",food.detailMessage],@"image":[NSString stringWithFormat:@"'%@'",food.image],@"food":[NSString stringWithFormat:@"'%@'",food.food],@"bar":[NSString stringWithFormat:@"'%@'",food.bar],@"content":[NSString stringWithFormat:@"'%@'",food.content]};
    
    
    [_sqlTool insertWithTableName:_tableName values:valus];
    //[self execSql:sql msg:@"添加个人记录"];
}
-(void)createTable
{
    
    NSDictionary* dic = @{@"id":@"integer PRIMARY KEY", @"name":@"text",@"scanTimes":@"integer",@"tag":@"text",@"detailMessage":@"text",@"image":@"text",@"food":@"text",@"bar":@"text",@"content":@"text"};
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

-(NSArray*)queryFoodWithFilter:(NSString* )filter limit:(NSInteger)limit offset:(NSInteger)offset
{
    NSString* name = _tableName;
    NSArray* cloumnN = @[@"id",@"name",@"scanTimes",@"tag",@"detailMessage",@"image",@"food",@"bar",@"content"];
    
    NSArray* p = [_sqlTool queryObjectsWithTableName:name cloumnName:cloumnN filter:filter limit:limit offset:offset stmt:^(sqlite3_stmt *stmt, NSMutableArray *arry) {
        NSInteger ID = sqlite3_column_int(stmt, 0);
        const unsigned char *name = sqlite3_column_text(stmt, 1);
        NSInteger scanTimes = sqlite3_column_int(stmt, 2);
        const unsigned char *tag = sqlite3_column_text(stmt, 3);
        const unsigned char *detailMessage = sqlite3_column_text(stmt, 4);
        const unsigned char *image = sqlite3_column_text(stmt, 5);
        const unsigned char *food = sqlite3_column_text(stmt, 6);
        const unsigned char *bar = sqlite3_column_text(stmt, 7);
        const unsigned char *content = sqlite3_column_text(stmt, 8);

        
        
        
        
        
        NSString* nameUTF8 = [NSString stringWithUTF8String:(const char*)name];
        NSString* tagUTF8 = [NSString stringWithUTF8String:(const char*)tag];
        NSString* detailMessageUTF8 = [NSString stringWithUTF8String:(const char*)detailMessage];
        NSString* imageUTF8 = [NSString stringWithUTF8String:(const char*)image];
        NSString* foodUTF8 = [NSString stringWithUTF8String:(const char*)food];
        NSString* barUTF8 = [NSString stringWithUTF8String:(const char*)bar];
        NSString* contentUTF8 = [NSString stringWithUTF8String:(const char*)content];

        
        [arry addObject:@(ID)];
        [arry addObject:nameUTF8];
        [arry addObject:@(scanTimes)];
        [arry addObject:tagUTF8];
        [arry addObject:detailMessageUTF8];
        [arry addObject:imageUTF8];
        [arry addObject:foodUTF8];
        [arry addObject:barUTF8];
        [arry addObject:contentUTF8];
    }];
    
    
    //打包food;
    //顺序一定要与前面cloumnN一致
    NSMutableArray* foods = [[NSMutableArray  alloc]init];
    for (NSArray* i in p) {
        Food * food = [[Food alloc]init];
        food.ID = [i[0] intValue];
        food.name = i[1];
        food.scanTimes = [i[2] intValue];
        food.tag = i[3];
        food.detailMessage = i[4];
        food.image = i[5];
        food.food = i[6];
        food.bar = i[7];
        food.content = i[8];
        
        food.title = food.name;


        [foods addObject:food];
    }
    return foods;
}
-(NSArray *)queryFood
{
    return [self queryFoodWithFilter:nil];
}
-(Food *)queryFoodWithFoodID:(NSInteger)ID
{
    NSString* filter = [NSString stringWithFormat:@" id = %d",ID];
    NSArray* FoodArry = [self queryFoodWithFilter:filter];
    Food* food ;
    if(FoodArry.count > 0)food= FoodArry[0];
    return food;
}

-(NSArray*)queryFoodWithFilter:(NSString* )filter
{
    return [self queryFoodWithFilter:filter limit:0 offset:0];
}

// 修改个人记录(修改传入Person对象ID对应的数据库记录的内容)
//- (void)updatePerson:(Person *)person
//{
//    
//}

// 删除个人记录
- (int)removeFood:(NSInteger)foodID
{
    //    NSDictionary* dic = @{@"id":@(personID)};
    NSString* filter = [NSString stringWithFormat:@" id = %d",foodID];
    return [_sqlTool deleteWithTableName:TABLE_NAME filter:filter];
}

@end
