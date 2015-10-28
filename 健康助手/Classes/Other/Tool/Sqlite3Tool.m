//
//  Sqlite3Tool.m
//  02.SQLite基本使用
//
//  Created by 未成年大叔 on 15/8/6.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "Sqlite3Tool.h"
@interface Sqlite3Tool()
{
    // SQLite数据库的连接，基于该连接可以进行数据库操作
    sqlite3 *_db;
}

@end
@implementation Sqlite3Tool

// 在初始化方法中完成数据库连接工作
- (id)init
{
    self = [super init];
    if (self) {
        // 1. 创建(连接)数据库
        [self openDB];
        // 2. 创建数据表
        //        [self createTable];
    }
    
    return self;
}

#pragma mark - 数据库操作方法
/**
 *  打开数据库
 */

- (void)openDB
{
    // 生成存放在沙盒中的数据库完整路径
 
    NSString *dbName = SqliteData;
    sqlite3_config(SQLITE_CONFIG_SERIALIZED);
    // 如果数据库不存在，怎新建并打开一个数据库，否则直接打开
    if (SQLITE_OK == sqlite3_open(dbName.UTF8String, &_db)) {
        NSLog(@"创建/打开数据库成功。");
    } else {
        NSLog(@"创建/打开数据库失败。");
    }
}

/**
 *  指定单步sql指令
 *
 *  @param sql sql语句
 *  @param msg 提示信息
 */

- (void)execSql:(NSString *)sql msg:(NSString *)msg
{
    char *errmsg;
    // 所谓回调：sqlite3_exec执行完成sql之后调用的方法，叫做回调方法
    if (SQLITE_OK == sqlite3_exec(_db, sql.UTF8String, NULL, NULL, &errmsg)) {
        NSLog(@"%@成功", msg);
    } else {
        NSLog(@"%@失败 - %s", msg, errmsg);
    }
}
-(BOOL)isExistWithTableName:(NSString*)name keyFilter:(NSString*)keyFilter
{
    if(name == nil || keyFilter == nil)return NO;
    
    NSString* sql =[NSString stringWithFormat:@"SELECT * From %@ WHERE %@",name,keyFilter];
    //QL语法是否正确
    sqlite3_stmt *stmt = NULL;
    if (SQLITE_OK == sqlite3_prepare_v2(_db, sql.UTF8String, -1, &stmt, NULL)) {
        // 2. 如果能够正常查询，调用单步执行方法，依次取得查询结果
        // 如果得到一行记录
        
        while (SQLITE_ROW == sqlite3_step(stmt)) {
            sqlite3_finalize(stmt);
            return YES;
        }
        sqlite3_finalize(stmt);
        return NO;
        
    } else {
        NSLog(@"SQL语法错误");
    }
    
    // 4. 释放句柄
    sqlite3_finalize(stmt);
    
    return NO;
}




- (NSArray *)queryObjectsWithTableName:(NSString*)name cloumnName:(NSArray*)cloumnName filter:(NSString*)filter limit:(NSInteger)limit offset:(NSInteger)offset stmt:(stmt_deconde)block
{
    if(cloumnName == nil)return nil;
    
    NSString* sql = @"SELECT";
    for (NSString* i in cloumnName) {
        sql = [sql stringByAppendingString:[NSString stringWithFormat:@" %@,",i]];
    }
    sql = [sql substringToIndex:sql.length -1];
    sql = [sql stringByAppendingString:@" FROM "];
    sql = [sql stringByAppendingString:name];
    
    if(filter != nil)sql = [NSString stringWithFormat:@"%@ where %@",sql,filter];
    
    if(limit != 0)sql = [NSString stringWithFormat:@"%@ Limit %ld",sql,(long)limit];
    if(offset != 0)sql = [NSString stringWithFormat:@"%@ Offset %ld",sql,(long)offset];;
    
    // 1. 评估准备SQL语法是否正确
    sqlite3_stmt *stmt = NULL;
    //    NSMutableArray *persons = [NSMutableArray array];
    NSMutableArray *obj = nil;
    if (SQLITE_OK == sqlite3_prepare_v2(_db, sql.UTF8String, -1, &stmt, NULL)) {
        // 2. 如果能够正常查询，调用单步执行方法，依次取得查询结果
        // 如果得到一行记录
        obj = [NSMutableArray array];
        
        while (SQLITE_ROW == sqlite3_step(stmt)) {
            
            NSMutableArray* arry =[[NSMutableArray alloc]initWithCapacity:cloumnName.count];
            block(stmt,arry);
            [obj addObject:arry];
        }
        
    } else {
        NSLog(@"SQL语法错误");
    }
    
    // 4. 释放句柄
    sqlite3_finalize(stmt);
    
    return obj;
}

- (void)createTableWithName:(NSString*)name member:(NSDictionary*)member
{
    if (name == nil) {
        NSLog(@"表名为空,创建数据表失败");
        return;
    }
    NSString* t_name = name;
    //    NSString *sql = @"CREATE TABLE IF NOT EXISTS t_person (id integer PRIMARY KEY AUTOINCREMENT,name text,age integer,phoneNo text)";
    NSString* sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(",t_name];
    for (NSString* m_key in member.allKeys) {
        NSString* m_name = [member objectForKey:m_key];
        NSString* parm = [NSString stringWithFormat:@"%@ %@,",m_key,m_name];
        sql = [sql stringByAppendingString:parm];
    }
    sql = [sql substringToIndex:sql.length-1];
    sql = [sql stringByAppendingString:@")"];
    [self execSql:sql msg:@"创建数据表"];
    
}
-(int)insertWithTableName:(NSString*)Name values:(NSDictionary*)value
{
    NSString* sql = [NSString stringWithFormat:@"INSERT INTO %@",Name];
    NSString* column = @"(";
    for (NSString* i in value.allKeys) {
        NSString* columnN = [NSString stringWithFormat:@" %@,",i];
        column = [column stringByAppendingString:columnN];
    }
    column = [column substringToIndex:column.length - 1];
    column = [column stringByAppendingString:@")"];
    
    sql = [sql stringByAppendingString:column];
    sql = [sql stringByAppendingString:@" VALUES "];
    
    NSString* values = @"(";
    for (NSString* i in value.allKeys) {
        NSString* columnN = [NSString stringWithFormat:@" %@,",[value objectForKey:i]];
        values = [values stringByAppendingString:columnN];
    }
    values = [values substringToIndex:values.length - 1];
    values = [values stringByAppendingString:@")"];
    
    sql = [sql stringByAppendingString:values];
    
    [self execSql:sql msg:@"增加数据表"];
    return sqlite3_changes(_db);
    
}
/**
 *  <#Description#>
 *
 *  @param name   <#name description#>
 *  @param filter 制定删除匹配条件
 *
 *  @return 删除的数目
 */
-(int)deleteWithTableName:(NSString*)name filter:(NSString*)filter
{
//    NSString* sqlStr = @"delete from %s where id=%s";

    NSString* sqlStr = [NSString stringWithFormat:@"delete from %@",name];
    if (filter != nil) {
        sqlStr = [sqlStr stringByAppendingString:@" where "];
        sqlStr = [sqlStr stringByAppendingString:filter];
        
    }
    
//    NSLog(sqlStr);
    [self execSql:sqlStr msg:@"删除数据表"];

    return sqlite3_changes(_db);
    

}

@end
