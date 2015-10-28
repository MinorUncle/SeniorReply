//
//  Medicine.m
//  健康助手
//
//  Created by 未成年大叔 on 15/7/23.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "Store.h"

@implementation Store
@synthesize image = _image;
- (Store*)initWithDict:(NSDictionary*)store
{

    if(self = [super initWithDict:store])
    {
        _image =store[@"logo"];               //重写路径key图片路径
        _address = store[@"address"];           ///疾病部位
        
        _tel = store[@"tel"];            //简介
        _zipcode = store[@"zipcode"];          //疾病症状详情
        _number = store[@"number"];                       //
        _type = store[@"type"];             //
        
        _charge = store[@"charge"];                //症状
        _leader = store[@"leader"];         //相关病状详情
        _food = store[@"food"];                 //食疗
        _foodText = store[@"foodText"];                 //食疗
        _business = store[@"business"];               //注意事项
        _createdate = store[@"createdate"];               //科室
        _legal = store[@"legal"];                     //法定代表人
        _localX = [store[@"x"] floatValue];             //  地图x坐标
        _localY = [store[@"y"] floatValue];               //地图y坐标
        
 
    }
    return self;
}

-(NSString*)removeHtml:(NSString*)str
{
    NSArray *arr = [str componentsSeparatedByCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    str = @"";
    for (NSString* i in arr) {
        //        BOOL b = ![i containsString:@"/"]&&![i containsString:@"font"];
        
        BOOL b = !([i rangeOfString:@"/"].length > 0) && !([i rangeOfString:@"font"].length >0);
        if ( b) {
            str = [str stringByAppendingString:i];
        }
    }
    return str;
}

- (Store*)initWithSearchDict:(NSDictionary*)store
{
   
    if(self = [super initWithSearchDict:store])
    {
        _image =store[@"img"];               //重写路径key图片路径

     }
    return self;
}


-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:_image forKey:@"img"];
    [aCoder encodeObject:_address forKey:@"address"];
    [aCoder encodeObject:_tel forKey:@"tel"];           ///简介
    [aCoder encodeObject:_zipcode forKey:@"zipcode"];
    [aCoder encodeObject:_number forKey:@"number"];
    [aCoder encodeObject:_type forKey:@"type"];
    
    
    [aCoder encodeObject:_leader forKey:@"leader"];  //疾病说明
    [aCoder encodeObject:_charge forKey:@"charge"];      //相关病状
    [aCoder encodeObject:_food forKey:@"food"];      //食疗
    [aCoder encodeObject:_foodText forKey:@"foodText"];   //食疗
    [aCoder encodeObject:_business forKey:@"business"];          //注意事项
    [aCoder encodeObject:_createdate forKey:@"createdate"];             //科室
    [aCoder encodeObject:_legal forKey:@"legal"];        //法定代表人
    [aCoder encodeObject:@(_localX) forKey:@"localX"];     //  地图x坐标
    [aCoder encodeObject:@(_localY) forKey:@"localY"];    //地图y坐标
    





    
    
}
//

//long //医院ID
//name//string
//陶都名称//domain
//string//内部网站的域名(预留)
//logo//string//药店LOGO
//area//long//药店地方ID (预留)
//address//string//药店街道地址
//x//float//地图x坐标
//y//float//地图y坐标
//tel//string//电话
//zipcode//string//邮编
//url//string//官方网址
//numbe//string//证号 编号
//legal//string//法定代表人
//charge//string//企业负责人
//leader//string//质量负责人
//type//string//经营方式
//waddress//string//仓库地址
//business//string//经营范围
//supervise//long//（预留）
//createdate//date//创建时间
//message/string//药店简介
//count//int//药店访问次数
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super initWithCoder:decoder]) {
       
        _image =[decoder decodeObjectForKey:@"img"];               //图片路径
        _address =[decoder decodeObjectForKey:@"address"];           ///地址
        _tel = [decoder decodeObjectForKey:@"tel"];            //电话
        _zipcode = [decoder decodeObjectForKey:@"zipcode"];            //邮编
        _number = [decoder decodeObjectForKey:@"number"];            //证号 编号
        _type = [decoder decodeObjectForKey:@"type"];            //经营方式
        _charge =[decoder decodeObjectForKey:@"charge"];              // 企业负责人
        _leader = [decoder decodeObjectForKey:@"leader"];   //质量负责人
        _business = [decoder decodeObjectForKey:@"business"];              //经营范围
        _createdate =[decoder decodeObjectForKey:@"createdate"];               //创建日期
        _legal = [decoder decodeObjectForKey:@"legal"];                    //法定代表人
        _localX = [[decoder decodeObjectForKey:@"localX"] floatValue];           //  地图x坐标
        _localY = [[decoder decodeObjectForKey:@"localY"] floatValue];
        
        _food = [decoder decodeObjectForKey:@"food"];              //食疗
        _foodText = [decoder decodeObjectForKey:@"foodText"];              //食疗

        
    }
    return self;
}



@end
