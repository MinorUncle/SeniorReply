//
//  DiseaseSQLiteManager.m
//  健康助手
//
//  Created by 未成年大叔 on 15/8/7.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "DiseaseSQLiteManager.h"
#import "Sqlite3Tool.h"

#define TABLE_NAME @"Disease_t"
#define CLOUMN_NAME @""

@interface DiseaseSQLiteManager()
{
    // SQLite数据库的连接，基于该连接可以进行数据库操作
    Sqlite3Tool *_sqlTool;
    NSString* _tableName;
    NSString* _cloumnName;
}
@end
@implementation DiseaseSQLiteManager
single_implementation(DiseaseSQLiteManager)

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
- (void)addDisease:(Disease *)disease
{
    NSDictionary* valus = @{@"name":[NSString stringWithFormat:@"'%@'", disease.name],
                            @"id":@(disease.ID),
                            @"scanTimes":[NSString stringWithFormat:@"'%@'", @(disease.scanTimes)],
                            @"tag":[NSString stringWithFormat:@"'%@'",disease.tag],
                            @"detailMessage":[NSString stringWithFormat:@"'%@'",disease.detailMessage],
                            @"image":[NSString stringWithFormat:@"'%@'",disease.image],
                            
                            @"place":[NSString stringWithFormat:@"'%@'",disease.place],
                            @"summary":[NSString stringWithFormat:@"'%@'",disease.summary],
                            @"symptomText":[NSString stringWithFormat:@"'%@'",disease.symptomText],
                            @"causeText":[NSString stringWithFormat:@"'%@'",disease.causeText],
                            @"drug":[NSString stringWithFormat:@"'%@'",disease.drug],
                            @"drugText":[NSString stringWithFormat:@"'%@'",disease.drugText],
                            @"symptom":[NSString stringWithFormat:@"'%@'",disease.symptom],
                            @"relevanceCheck":[NSString stringWithFormat:@"'%@'",disease.check],
                            @"checkText":[NSString stringWithFormat:@"'%@'",disease.checkText],
                            @"food":[NSString stringWithFormat:@"'%@'",disease.food],
                            @"foodText":[NSString stringWithFormat:@"'%@'",disease.foodText],
                            @"disease":[NSString stringWithFormat:@"'%@'",disease.disease],
                            @"diseaseText":[NSString stringWithFormat:@"'%@'",disease.diseaseText],
                            @"careText":[NSString stringWithFormat:@"'%@'",disease.careText],
                            @"department":[NSString stringWithFormat:@"'%@'",disease.department],
                            @"title":[NSString stringWithFormat:@"'%@'",disease.title],
                            @"content":[NSString stringWithFormat:@"'%@'",disease.content]};
    
    
    [_sqlTool insertWithTableName:_tableName values:valus];
    //[self execSql:sql msg:@"添加个人记录"];
}
-(void)createTable
{
    //@"place",@"summary",@"symptomText",@"causeText",@"drug",@"drugText",@"symptom",@"check",@"checkText",@"food",@"foodText",@"disease",@"diseaseText",@"careText",@"department",@"title",@"content"
    NSDictionary* dic = @{@"id":@"integer PRIMARY KEY",
                          @"name":@"text",
                          @"scanTimes":@"integer",
                          @"tag":@"text",
                          @"detailMessage":@"text",
                          @"image":@"text",
                          
                          @"place":@"text",
                          @"summary":@"text",
                          @"symptomText":@"text",
                          @"causeText":@"text",
                          @"drug":@"text",
                          @"drugText":@"text",
                          @"symptom":@"text",
                          @"relevanceCheck":@"text",
                          @"checkText":@"text",
                          @"food":@"text",
                          @"foodText":@"text",
                          @"disease":@"text",
                          @"diseaseText":@"text",
                          @"careText":@"text",
                          @"department":@"text",
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
//@property(nonatomic,copy)NSString* place;             //部位
//@property(nonatomic,copy) NSString* summary;               //简介
//@property(nonatomic,copy) NSString* symptomText;               //病状详情
//@property(nonatomic,copy) NSString* causeText;               //发病原因
//@property(nonatomic,copy) NSString* drug;               //相关药品
//@property(nonatomic,copy) NSString* drugText;               //相关药物治疗详情
//@property(nonatomic,copy) NSString* symptom;               //相关病状
//@property(nonatomic,copy) NSString* check;               //相关检查
//@property(nonatomic,copy) NSString* checkText;               //相关检查详情
//@property(nonatomic,copy) NSString* food;               //食疗食物
//@property(nonatomic,copy) NSString* foodText;               //食疗
//@property(nonatomic,copy) NSString* disease;               //相关疾病信息
//@property(nonatomic,copy) NSString* diseaseText;               //疾病说明
//@property(nonatomic,copy) NSString* careText;               //注意事项
//@property(nonatomic,copy) NSString* department;               //科室
//@property(nonatomic,copy) NSString* title;               //搜索标题
//@property(nonatomic,copy) NSString* content;               //内容



-(NSArray*)queryDiseaseWithFilter:(NSString* )filter limit:(NSInteger)limit offset:(NSInteger)offset
{
    NSString* name = _tableName;
    NSArray* cloumnN = @[@"id",@"name",@"scanTimes",@"tag",@"detailMessage",@"image",@"place",@"summary",@"symptomText",@"causeText",@"drug",@"drugText",@"symptom",@"relevanceCheck",@"checkText",@"food",@"foodText",@"disease",@"diseaseText",@"careText",@"department",@"title",@"content"];
    
    NSArray* p = [_sqlTool queryObjectsWithTableName:name cloumnName:cloumnN filter:filter limit:limit offset:offset stmt:^(sqlite3_stmt *stmt, NSMutableArray *arry) {
        NSInteger ID = sqlite3_column_int(stmt, 0);
        const unsigned char *name = sqlite3_column_text(stmt, 1);
        NSInteger scanTimes = sqlite3_column_int(stmt, 2);
        const unsigned char *tag = sqlite3_column_text(stmt, 3);
        const unsigned char *detailMessage = sqlite3_column_text(stmt, 4);
        const unsigned char *image = sqlite3_column_text(stmt, 5);
        
        const unsigned char *place = sqlite3_column_text(stmt, 6);
        const unsigned char *summary = sqlite3_column_text(stmt, 7);
        const unsigned char *symptomText = sqlite3_column_text(stmt, 8);
        const unsigned char *causeText = sqlite3_column_text(stmt, 9);
        const unsigned char *drug = sqlite3_column_text(stmt, 10);
        const unsigned char *drugText = sqlite3_column_text(stmt, 11);
        const unsigned char *symptom = sqlite3_column_text(stmt, 12);
        const unsigned char *relevanceCheck = sqlite3_column_text(stmt, 13);
        const unsigned char *checkText = sqlite3_column_text(stmt, 14);
        const unsigned char *food = sqlite3_column_text(stmt, 15);
        const unsigned char *foodText = sqlite3_column_text(stmt, 16);
        const unsigned char *disease = sqlite3_column_text(stmt, 17);
        const unsigned char *diseaseText = sqlite3_column_text(stmt, 18);
        const unsigned char *careText = sqlite3_column_text(stmt, 19);
        const unsigned char *department = sqlite3_column_text(stmt, 20);
        const unsigned char *title = sqlite3_column_text(stmt, 21);
        const unsigned char *content = sqlite3_column_text(stmt, 22);

        
        //@"place",@"summary",@"symptomText",@"causeText",@"drug",@"drugText",@"symptom",@"check",@"checkText",@"food",@"foodText",@"disease",@"diseaseText",@"careText",@"department",@"title",@"content"

        
        
        
        NSString* nameUTF8 = [NSString stringWithUTF8String:(const char*)name];
        NSString* tagUTF8 = [NSString stringWithUTF8String:(const char*)tag];
        NSString* detailMessageUTF8 = [NSString stringWithUTF8String:(const char*)detailMessage];
        NSString* imageUTF8 = [NSString stringWithUTF8String:(const char*)image];
        
        NSString* placeUTF8 = [NSString stringWithUTF8String:(const char*)place];
        NSString* summaryUTF8 = [NSString stringWithUTF8String:(const char*)summary];
        NSString* symptomTextUTF8 = [NSString stringWithUTF8String:(const char*)symptomText];
        NSString* causeTextUTF8 = [NSString stringWithUTF8String:(const char*)causeText];
        NSString* drugMessageUTF8 = [NSString stringWithUTF8String:(const char*)drug];
        NSString* drugTextUTF8 = [NSString stringWithUTF8String:(const char*)drugText];
        NSString* symptomUTF8 = [NSString stringWithUTF8String:(const char*)symptom];
        NSString* checkUTF8 = [NSString stringWithUTF8String:(const char*)relevanceCheck];
        NSString* checkTextUTF8 = [NSString stringWithUTF8String:(const char*)checkText];
        NSString* foodUTF8 = [NSString stringWithUTF8String:(const char*)food];
        NSString* foodTextUTF8 = [NSString stringWithUTF8String:(const char*)foodText];
        NSString* diseaseUTF8 = [NSString stringWithUTF8String:(const char*)disease];
        NSString* diseaseTextUTF8 = [NSString stringWithUTF8String:(const char*)diseaseText];
        NSString* careTextUTF8 = [NSString stringWithUTF8String:(const char*)careText];
        NSString* departmentUTF8 = [NSString stringWithUTF8String:(const char*)department];
        NSString* titleUTF8 = [NSString stringWithUTF8String:(const char*)title];
        NSString* contentUTF8 = [NSString stringWithUTF8String:(const char*)content];
        

        
        [arry addObject:@(ID)];
        [arry addObject:nameUTF8];
        [arry addObject:@(scanTimes)];
        [arry addObject:tagUTF8];
        [arry addObject:detailMessageUTF8];
        [arry addObject:imageUTF8];
        
        [arry addObject:placeUTF8];
        [arry addObject:summaryUTF8];
        [arry addObject:symptomTextUTF8];
        [arry addObject:causeTextUTF8];
        [arry addObject:drugMessageUTF8];
        [arry addObject:drugTextUTF8];
        [arry addObject:symptomUTF8];
        [arry addObject:checkUTF8];
        [arry addObject:checkTextUTF8];
        [arry addObject:foodUTF8];
        [arry addObject:foodTextUTF8];
        [arry addObject:diseaseUTF8];
        [arry addObject:diseaseTextUTF8];
        [arry addObject:careTextUTF8];
        [arry addObject:departmentUTF8];
        [arry addObject:titleUTF8];
        [arry addObject:contentUTF8];
    }];
    
    //@"place",@"summary",@"symptomText",@"causeText",@"drug",@"drugText",@"symptom",@"check",@"checkText",@"food",@"foodText",@"disease",@"diseaseText",@"careText",@"department",@"title",@"content"

    //打包disease;
    //顺序一定要与前面cloumnN一致
    NSMutableArray* diseases = [[NSMutableArray  alloc]init];
    for (NSArray* i in p) {
        Disease * disease = [[Disease alloc]init];
        disease.ID = [i[0] intValue];
        disease.name = i[1];
        disease.scanTimes = [i[2] intValue];
        disease.tag = i[3];
        disease.detailMessage = i[4];
        disease.image = i[5];
        disease.place = i[6];
        disease.summary = i[7];
        disease.symptomText = i[8];
        disease.causeText = i[9];
        disease.drug = i[10];
        disease.drugText = i[11];
        disease.symptom = i[12];
        disease.check = i[13];
        disease.checkText = i[14];
        disease.food = i[15];
        disease.foodText = i[16];
        disease.disease = i[17];
        disease.diseaseText = i[18];
        disease.careText = i[19];
        disease.department = i[20];
        disease.title = i[21];
        disease.content = i[22];
        if([disease.title isEqualToString:@"(null)"])disease.title = disease.name;
        else  disease.name = disease.title;

        [diseases addObject:disease];
    }
    return diseases;
}
-(NSArray *)queryDisease
{
    return [self queryDiseaseWithFilter:nil];
}
-(Disease *)queryDiseaseWithDiseaseID:(NSInteger)ID
{
    NSString* filter = [NSString stringWithFormat:@" id = %d",ID];
    NSArray* DiseaseArry = [self queryDiseaseWithFilter:filter];
    Disease* disease =nil;
    if(DiseaseArry.count > 0)disease= DiseaseArry[0];
    return disease;
}

-(NSArray*)queryDiseaseWithFilter:(NSString* )filter
{
    return [self queryDiseaseWithFilter:filter limit:0 offset:0];
}

// 修改个人记录(修改传入Person对象ID对应的数据库记录的内容)
//- (void)updatePerson:(Person *)person
//{
//    
//}

// 删除个人记录
- (int)removeDisease:(NSInteger)diseaseID
{
    //    NSDictionary* dic = @{@"id":@(personID)};
    NSString* filter = [NSString stringWithFormat:@" id = %d",diseaseID];
    return [_sqlTool deleteWithTableName:TABLE_NAME filter:filter];
}

@end
