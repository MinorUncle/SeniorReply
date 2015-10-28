//
//  Sqlite3Tool.h
//  02.SQLite基本使用
//
//  Created by 未成年大叔 on 15/8/6.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
typedef void (^stmt_deconde)(sqlite3_stmt* stmt, NSMutableArray* arry);

@interface Sqlite3Tool : NSObject
- (void)createTableWithName:(NSString*)name member:(NSDictionary*)member;
- (NSArray *)queryObjectsWithTableName:(NSString*)name cloumnName:(NSArray*)cloumnName filter:(NSString*)filter limit:(NSInteger)limit offset:(NSInteger)offset stmt:(stmt_deconde)block;
-(int)insertWithTableName:(NSString*)Name values:(NSDictionary*)value;
-(int)deleteWithTableName:(NSString*)name filter:(NSString*)filter;
-(BOOL)isExistWithTableName:(NSString*)name keyFilter:(NSString*)keyFilter;
@end
