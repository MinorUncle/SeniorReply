//
//  Medicine.m
//  健康助手
//
//  Created by 未成年大叔 on 15/7/23.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "Disease.h"

@implementation Disease
@synthesize image = _image;
- (Disease*)initWithDict:(NSDictionary*)disease
{

    if(self = [super initWithDict:disease])
    {
        _image =disease[@"img"];               //重写路径key图片路径
        _place = disease[@"place"];           ///疾病部位
        _summary = disease[@"summary"];            //简介
        _symptomText = disease[@"symptomText"];          //疾病症状详情
        _drug = disease[@"drug"];                       //
        _causeText = disease[@"causeText"];             //
        _disease = disease[@"disease"];             //相关疾病
        
        _symptom = disease[@"symptom"];                //症状
        _diseaseText = disease[@"diseaseText"];         //相关病状详情
        _food = disease[@"food"];                 //食疗
        _foodText = disease[@"foodText"];                 //食疗
        _careText = disease[@"careText"];               //注意事项
        _department = disease[@"department"];               //科室
        _check = disease[@"check"];                     //相关检查
        _checkText = disease[@"checkText"];             //  检查详情
        _drugText = disease[@"drugText"];               //相关药物治疗详情
        
 
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

- (Disease*)initWithSearchDict:(NSDictionary*)disease
{
   
    if(self = [super initWithSearchDict:disease])
    {
        _image =disease[@"img"];               //重写路径key图片路径

     }
    return self;
}


-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:_image forKey:@"img"];
    [aCoder encodeObject:_place forKey:@"place"];
    [aCoder encodeObject:_summary forKey:@"summary"];           ///简介
    [aCoder encodeObject:_symptomText forKey:@"symptomText"];
    [aCoder encodeObject:_drug forKey:@"drug"];
    [aCoder encodeObject:_causeText forKey:@"causeText"];
    [aCoder encodeObject:_disease forKey:@"disease"];
    
    
    [aCoder encodeObject:_diseaseText forKey:@"diseaseText"];  //疾病说明
    [aCoder encodeObject:_symptom forKey:@"symptom"];      //相关病状
    [aCoder encodeObject:_food forKey:@"food"];      //食疗
    [aCoder encodeObject:_foodText forKey:@"foodText"];   //食疗
    [aCoder encodeObject:_careText forKey:@"careText"];          //注意事项
    [aCoder encodeObject:_department forKey:@"department"];             //科室
    [aCoder encodeObject:_check forKey:@"check"];        //相关检查
    [aCoder encodeObject:_checkText forKey:@"checkText"];     //  检查详情
    [aCoder encodeObject:_drugText forKey:@"drugText"];    //相关药物治疗详情
    





    
    
}
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super initWithCoder:decoder]) {
       
        _image =[decoder decodeObjectForKey:@"img"];               //图片路径
        _place =[decoder decodeObjectForKey:@"place"];           ///部位
        _summary = [decoder decodeObjectForKey:@"summary"];            //简介
        _symptomText = [decoder decodeObjectForKey:@"symptomText"];            //诊断
        _drug = [decoder decodeObjectForKey:@"drug"];            //
        _causeText = [decoder decodeObjectForKey:@"causeText"];            //病因
        _disease = [decoder decodeObjectForKey:@"disease"];

        _symptom =[decoder decodeObjectForKey:@"symptom"];              //相关病状
        _diseaseText = [decoder decodeObjectForKey:@"diseaseText"];
        _food = [decoder decodeObjectForKey:@"food"];              //食疗
        _foodText = [decoder decodeObjectForKey:@"foodText"];              //食疗
        _careText = [decoder decodeObjectForKey:@"careText"];              //注意事项
        _department =[decoder decodeObjectForKey:@"department"];               //科室
        _check = [decoder decodeObjectForKey:@"check"];                    //相关检查
        _checkText = [decoder decodeObjectForKey:@"checkText"];           //  检查详情
        _drugText = [decoder decodeObjectForKey:@"drugText"];
        
    }
    return self;
}



@end
