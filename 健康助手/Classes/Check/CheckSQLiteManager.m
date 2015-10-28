//
//  CheckSQLiteManager.m
//  健康助手
//
//  Created by 未成年大叔 on 15/8/7.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "CheckSQLiteManager.h"
#import "Sqlite3Tool.h"

#define TABLE_NAME @"Check_t"
#define CLOUMN_NAME @""

@interface CheckSQLiteManager()
{
    // SQLite数据库的连接，基于该连接可以进行数据库操作
    Sqlite3Tool *_sqlTool;
    NSString* _tableName;
    NSString* _cloumnName;
}
@end
@implementation CheckSQLiteManager
single_implementation(CheckSQLiteManager)

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
//@property(nonatomic,copy)NSString* menu;             //分类
//@property(nonatomic,copy) NSString* image;               //图片路径
//@property(nonatomic,copy) NSString* summary;               //简介

#pragma mark - 成员方法
// 新增个人记录
- (void)addCheck:(Check *)check
{
    NSDictionary* valus = @{@"name":[NSString stringWithFormat:@"'%@'", check.name],@"id":@(check.ID),@"scanTimes":[NSString stringWithFormat:@"'%@'", @(check.scanTimes)],@"tag":[NSString stringWithFormat:@"'%@'",check.tag],@"detailMessage":[NSString stringWithFormat:@"'%@'",check.detailMessage],@"image":[NSString stringWithFormat:@"'%@'",check.image],@"menu":[NSString stringWithFormat:@"'%@'",check.menu],@"summary":[NSString stringWithFormat:@"'%@'",check.summary],@"title":[NSString stringWithFormat:@"'%@'",check.title],@"content":[NSString stringWithFormat:@"'%@'",check.content]};
    
    
    [_sqlTool insertWithTableName:_tableName values:valus];
    //[self execSql:sql msg:@"添加个人记录"];
}


-(void)createTable
{
    
    NSDictionary* dic = @{@"id":@"integer PRIMARY KEY", @"name":@"text",@"scanTimes":@"integer",@"tag":@"text",@"detailMessage":@"text",@"image":@"text",@"menu":@"text",@"summary":@"text",@"title":@"text",@"content":@"text"};
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

-(NSArray*)queryCheckWithFilter:(NSString* )filter limit:(NSInteger)limit offset:(NSInteger)offset
{
    NSString* name = _tableName;
    NSArray* cloumnN = @[@"id",@"name",@"scanTimes",@"tag",@"detailMessage",@"image",@"menu",@"summary",@"title",@"content"];
    
    NSArray* p = [_sqlTool queryObjectsWithTableName:name cloumnName:cloumnN filter:filter limit:limit offset:offset stmt:^(sqlite3_stmt *stmt, NSMutableArray *arry) {
        NSInteger ID = sqlite3_column_int(stmt, 0);
        const unsigned char *name = sqlite3_column_text(stmt, 1);
        NSInteger scanTimes = sqlite3_column_int(stmt, 2);
        const unsigned char *tag = sqlite3_column_text(stmt, 3);
        const unsigned char *detailMessage = sqlite3_column_text(stmt, 4);
        const unsigned char *image = sqlite3_column_text(stmt, 5);
        const unsigned char *menu = sqlite3_column_text(stmt, 6);
        const unsigned char *summary = sqlite3_column_text(stmt, 7);
        const unsigned char *title = sqlite3_column_text(stmt, 8);
        const unsigned char *content = sqlite3_column_text(stmt,9);
        
        
        
        
        
        NSString* nameUTF8 = [NSString stringWithUTF8String:(const char*)name];
        NSString* tagUTF8 = [NSString stringWithUTF8String:(const char*)tag];
        NSString* detailMessageUTF8 = [NSString stringWithUTF8String:(const char*)detailMessage];
        NSString* imageUTF8 = [NSString stringWithUTF8String:(const char*)image];
        NSString* menuUTF8 = [NSString stringWithUTF8String:(const char*)menu];
        NSString* summaryUTF8 = [NSString stringWithUTF8String:(const char*)summary];
        NSString* titleUTF8 = [NSString stringWithUTF8String:(const char*)title];
        NSString* contentUTF8 = [NSString stringWithUTF8String:(const char*)content];
        [arry addObject:@(ID)];
        [arry addObject:nameUTF8];
        [arry addObject:@(scanTimes)];
        [arry addObject:tagUTF8];
        [arry addObject:detailMessageUTF8];
        [arry addObject:imageUTF8];
        [arry addObject:menuUTF8];
        [arry addObject:summaryUTF8];
        [arry addObject:titleUTF8];
        [arry addObject:contentUTF8];
    }];
    
    
    //打包check;
    //顺序一定要与前面cloumnN一致
    NSMutableArray* checks = [[NSMutableArray  alloc]init];
    for (NSArray* i in p) {
        Check * check = [[Check alloc]init];
        check.ID = [i[0] intValue];
        check.name = i[1];
        check.scanTimes = [i[2] intValue];
        check.tag = i[3];
        check.detailMessage = i[4];
        check.image = i[5];
        check.menu = i[6];
        check.summary = i[7];
        check.title = i[8];
        check.content = i[9];
        
        if([check.title isEqualToString:@"(null)"])check.title = check.name;
        else  check.name = check.title;

        [checks addObject:check];
    }
    return checks;
}
-(NSArray *)queryCheck
{
    return [self queryCheckWithFilter:nil];
}
-(Check *)queryCheckWithCheckID:(NSInteger)ID
{
    NSString* filter = [NSString stringWithFormat:@" id = %d",ID];
    NSArray* CheckArry = [self queryCheckWithFilter:filter];
    Check* check ;
    if(CheckArry.count > 0)check = CheckArry[0];
    return check;
}

-(NSArray*)queryCheckWithFilter:(NSString* )filter
{
    return [self queryCheckWithFilter:filter limit:0 offset:0];
}

// 修改个人记录(修改传入Person对象ID对应的数据库记录的内容)
//- (void)updatePerson:(Person *)person
//{
//    
//}

// 删除个人记录
- (int)removeCheck:(NSInteger)checkID
{
    //    NSDictionary* dic = @{@"id":@(personID)};
    NSString* filter = [NSString stringWithFormat:@" id = %d",checkID];
    return [_sqlTool deleteWithTableName:TABLE_NAME filter:filter];
}

@end
