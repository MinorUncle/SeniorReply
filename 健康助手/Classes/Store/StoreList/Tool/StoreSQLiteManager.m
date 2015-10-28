//
//  StoreSQLiteManager.m
//  健康助手
//
//  Created by 未成年大叔 on 15/8/7.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "StoreSQLiteManager.h"
#import "Sqlite3Tool.h"

#define TABLE_NAME @"Store_t"
#define CLOUMN_NAME @""

@interface StoreSQLiteManager()
{
    // SQLite数据库的连接，基于该连接可以进行数据库操作
    Sqlite3Tool *_sqlTool;
    NSString* _tableName;
    NSString* _cloumnName;
}
@end
@implementation StoreSQLiteManager
single_implementation(StoreSQLiteManager)

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


#pragma mark - 成员方法
// 新增个人记录
- (void)addStore:(Store *)store
{
    NSDictionary* valus = @{@"name":[NSString stringWithFormat:@"'%@'", store.name],
                            @"id":@(store.ID),
                            @"scanTimes":[NSString stringWithFormat:@"'%@'", @(store.scanTimes)],
                            @"tag":[NSString stringWithFormat:@"'%@'",store.tag],
                            @"detailMessage":[NSString stringWithFormat:@"'%@'",store.detailMessage],
                            @"image":[NSString stringWithFormat:@"'%@'",store.image],
                            
                            @"address":[NSString stringWithFormat:@"'%@'",store.address],
                            @"tel":[NSString stringWithFormat:@"'%@'",store.tel],
                            @"zipcode":[NSString stringWithFormat:@"'%@'",store.zipcode],
                            @"type":[NSString stringWithFormat:@"'%@'",store.type],
                            @"number":[NSString stringWithFormat:@"'%@'",store.number],
                            @"localY":[NSString stringWithFormat:@"'%f'",store.localY],
                            @"charge":[NSString stringWithFormat:@"'%@'",store.charge],
                            @"legal":[NSString stringWithFormat:@"'%@'",store.legal],
                            @"localX":[NSString stringWithFormat:@"'%f'",store.localX],
                            @"food":[NSString stringWithFormat:@"'%@'",store.food],
                            @"foodText":[NSString stringWithFormat:@"'%@'",store.foodText],
                            @"leader":[NSString stringWithFormat:@"'%@'",store.leader],
                            @"business":[NSString stringWithFormat:@"'%@'",store.business],
                            @"createdate":[NSString stringWithFormat:@"'%@'",store.createdate],
                            @"title":[NSString stringWithFormat:@"'%@'",store.title],
                            @"content":[NSString stringWithFormat:@"'%@'",store.content]};
    
    
    [_sqlTool insertWithTableName:_tableName values:valus];
    //[self execSql:sql msg:@"添加个人记录"];
}
-(void)createTable
{
    //@"address",@"tel",@"zipcode",@"type",@"number",@"localY",@"charge",@"legal",@"localX",@"food",@"foodText",@"store",@"leader",@"business",@"createdate",@"title",@"content"
    NSDictionary* dic = @{@"id":@"integer PRIMARY KEY",
                          @"name":@"text",
                          @"scanTimes":@"integer",
                          @"tag":@"text",
                          @"detailMessage":@"text",
                          @"image":@"text",
                          
                          @"address":@"text",
                          @"tel":@"text",
                          @"zipcode":@"text",
                          @"type":@"text",
                          @"number":@"text",
                          @"localY":@"text",
                          @"charge":@"text",
                          @"legal":@"text",
                          @"localX":@"float",
                          @"food":@"text",
                          @"foodText":@"text",
                          @"leader":@"text",
                          @"business":@"text",
                          @"createdate":@"text",
                          @"title":@"text",
                          @"content":@"text"};
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
//@property(nonatomic,copy)NSString* address;             //部位
//@property(nonatomic,copy) NSString* tel;               //简介
//@property(nonatomic,copy) NSString* zipcode;               //病状详情
//@property(nonatomic,copy) NSString* type;               //发病原因
//@property(nonatomic,copy) NSString* number;               //相关药品
//@property(nonatomic,copy) NSString* localY;               //地图y坐标
//@property(nonatomic,copy) NSString* charge;               //相关病状
//@property(nonatomic,copy) NSString* legal;               //法定代表人
//@property(nonatomic,copy) NSString* localX;               //法定代表人详情
//@property(nonatomic,copy) NSString* food;               //食疗食物
//@property(nonatomic,copy) NSString* foodText;               //食疗
//@property(nonatomic,copy) NSString* store;               //相关疾病信息
//@property(nonatomic,copy) NSString* leader;               //疾病说明
//@property(nonatomic,copy) NSString* business;               //注意事项
//@property(nonatomic,copy) NSString* createdate;               //科室
//@property(nonatomic,copy) NSString* title;               //搜索标题
//@property(nonatomic,copy) NSString* content;               //内容



-(NSArray*)queryStoreWithFilter:(NSString* )filter limit:(NSInteger)limit offset:(NSInteger)offset
{
    NSString* name = _tableName;
    NSArray* cloumnN = @[@"id",@"name",@"scanTimes",@"tag",@"detailMessage",@"image",@"address",@"tel",@"zipcode",@"type",@"number",@"localY",@"charge",@"legal",@"localX",@"food",@"foodText",@"leader",@"business",@"createdate",@"title",@"content"];
    
    NSArray* p = [_sqlTool queryObjectsWithTableName:name cloumnName:cloumnN filter:filter limit:limit offset:offset stmt:^(sqlite3_stmt *stmt, NSMutableArray *arry) {
        NSInteger ID = sqlite3_column_int(stmt, 0);
        const unsigned char *name = sqlite3_column_text(stmt, 1);
        NSInteger scanTimes = sqlite3_column_int(stmt, 2);
        const unsigned char *tag = sqlite3_column_text(stmt, 3);
        const unsigned char *detailMessage = sqlite3_column_text(stmt, 4);
        const unsigned char *image = sqlite3_column_text(stmt, 5);
        
        const unsigned char *address = sqlite3_column_text(stmt, 6);
        const unsigned char *tel = sqlite3_column_text(stmt, 7);
        const unsigned char *zipcode = sqlite3_column_text(stmt, 8);
        const unsigned char *type = sqlite3_column_text(stmt, 9);
        const unsigned char *number = sqlite3_column_text(stmt, 10);
        const unsigned char *localY = sqlite3_column_text(stmt, 11);
        const unsigned char *charge = sqlite3_column_text(stmt, 12);
        const unsigned char *legal = sqlite3_column_text(stmt, 13);
        const unsigned char *localX = sqlite3_column_text(stmt, 14);
        const unsigned char *food = sqlite3_column_text(stmt, 15);
        const unsigned char *foodText = sqlite3_column_text(stmt, 16);
        const unsigned char *leader = sqlite3_column_text(stmt, 17);
        const unsigned char *business = sqlite3_column_text(stmt, 18);
        const unsigned char *createdate = sqlite3_column_text(stmt, 19);
        const unsigned char *title = sqlite3_column_text(stmt, 20);
        const unsigned char *content = sqlite3_column_text(stmt, 21);

        
        //@"address",@"tel",@"zipcode",@"type",@"number",@"localY",@"charge",@"legal",@"localX",@"food",@"foodText",@"store",@"leader",@"business",@"createdate",@"title",@"content"

        
        
        
        NSString* nameUTF8 = [NSString stringWithUTF8String:(const char*)name];
        NSString* tagUTF8 = [NSString stringWithUTF8String:(const char*)tag];
        NSString* detailMessageUTF8 = [NSString stringWithUTF8String:(const char*)detailMessage];
        NSString* imageUTF8 = [NSString stringWithUTF8String:(const char*)image];
        
        NSString* addressUTF8 = [NSString stringWithUTF8String:(const char*)address];
        NSString* telUTF8 = [NSString stringWithUTF8String:(const char*)tel];
        NSString* zipcodeUTF8 = [NSString stringWithUTF8String:(const char*)zipcode];
        NSString* typeUTF8 = [NSString stringWithUTF8String:(const char*)type];
        NSString* numberMessageUTF8 = [NSString stringWithUTF8String:(const char*)number];
        NSString* localYUTF8 = [NSString stringWithUTF8String:(const char*)localY];
        NSString* chargeUTF8 = [NSString stringWithUTF8String:(const char*)charge];
        NSString* legalUTF8 = [NSString stringWithUTF8String:(const char*)legal];
        NSString* localXUTF8 = [NSString stringWithUTF8String:(const char*)localX];
        NSString* foodUTF8 = [NSString stringWithUTF8String:(const char*)food];
        NSString* foodTextUTF8 = [NSString stringWithUTF8String:(const char*)foodText];
        NSString* leaderUTF8 = [NSString stringWithUTF8String:(const char*)leader];
        NSString* businessUTF8 = [NSString stringWithUTF8String:(const char*)business];
        NSString* createdateUTF8 = [NSString stringWithUTF8String:(const char*)createdate];
        NSString* titleUTF8 = [NSString stringWithUTF8String:(const char*)title];
        NSString* contentUTF8 = [NSString stringWithUTF8String:(const char*)content];
        

        
        [arry addObject:@(ID)];
        [arry addObject:nameUTF8];
        [arry addObject:@(scanTimes)];
        [arry addObject:tagUTF8];
        [arry addObject:detailMessageUTF8];
        [arry addObject:imageUTF8];
        
        [arry addObject:addressUTF8];
        [arry addObject:telUTF8];
        [arry addObject:zipcodeUTF8];
        [arry addObject:typeUTF8];
        [arry addObject:numberMessageUTF8];
        [arry addObject:localYUTF8];
        [arry addObject:chargeUTF8];
        [arry addObject:legalUTF8];
        [arry addObject:localXUTF8];
        [arry addObject:foodUTF8];
        [arry addObject:foodTextUTF8];
        [arry addObject:leaderUTF8];
        [arry addObject:businessUTF8];
        [arry addObject:createdateUTF8];
        [arry addObject:titleUTF8];
        [arry addObject:contentUTF8];
    }];
    
    //@"address",@"tel",@"zipcode",@"type",@"number",@"localY",@"charge",@"legal",@"localX",@"food",@"foodText",@"store",@"leader",@"business",@"createdate",@"title",@"content"

    //打包store;
    //顺序一定要与前面cloumnN一致
    NSMutableArray* stores = [[NSMutableArray  alloc]init];
    for (NSArray* i in p) {
        Store * store = [[Store alloc]init];
        store.ID = [i[0] intValue];
        store.name = i[1];
        store.scanTimes = [i[2] intValue];
        store.tag = i[3];
        store.detailMessage = i[4];
        store.image = i[5];
        store.address = i[6];
        store.tel = i[7];
        store.zipcode = i[8];
        store.type = i[9];
        store.number = i[10];
        store.localY = [i[11] floatValue];
        store.charge = i[12];
        store.legal = i[13];
        store.localX = [i[14] floatValue];
        store.food = i[15];
        store.foodText = i[16];
        store.leader = i[17];
        store.business = i[18];
        store.createdate = i[19];
        store.title = i[20];
        store.content = i[21];
        if([store.title isEqualToString:@"(null)"])store.title = store.name;
        else  store.name = store.title;

        [stores addObject:store];
    }
    return stores;
}
-(NSArray *)queryStore
{
    return [self queryStoreWithFilter:nil];
}
-(Store *)queryStoreWithStoreID:(NSInteger)ID
{
    NSString* filter = [NSString stringWithFormat:@" id = %d",ID];
    NSArray* StoreArry = [self queryStoreWithFilter:filter];
    Store* store =nil;
    if(StoreArry.count > 0)store= StoreArry[0];
    return store;
}

-(NSArray*)queryStoreWithFilter:(NSString* )filter
{
    return [self queryStoreWithFilter:filter limit:0 offset:0];
}

// 修改个人记录(修改传入Person对象ID对应的数据库记录的内容)
//- (void)updatePerson:(Person *)person
//{
//    
//}

// 删除个人记录
- (int)removeStore:(NSInteger)storeID
{
    //    NSDictionary* dic = @{@"id":@(personID)};
    NSString* filter = [NSString stringWithFormat:@" id = %d",storeID];
    return [_sqlTool deleteWithTableName:TABLE_NAME filter:filter];
}

@end
