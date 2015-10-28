//
//  Medicine.m
//  健康助手
//
//  Created by 未成年大叔 on 15/7/23.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "HomeBaseModel.h"

@implementation HomeBaseModel

- (HomeBaseModel*)initWithDict:(NSDictionary*)dic
{
    if(self = [super init])
    {
        _name = [self removeHtml:dic[@"name"]];            //名称
        _image =dic[@"image"];               //图片路径
        _detailMessage =dic[@"message"];   //详细信息
        _tag = dic[@"tag"];
         _scanTimes = [dic[@"count"] intValue];              //浏览次数
        _ID = [dic[@"id"] intValue];                     //唯一编码
        
        _title = dic[@"title"];
        _content = dic[@"content"];
    }

    return self;
}

- (HomeBaseModel*)initWithSearchDict:(NSDictionary*)dic
{
   
    if(self = [super init])
    {
        _name =[self removeHtml:dic[@"title"]] ;            //名称
        _image =dic[@"img"];               //图片路径
        _tag = dic[@"tag"];
        _ID = [dic[@"id"] intValue];                     //唯一编码
        
        _title = [self removeHtml:dic[@"title"]] ;
        _content = [self removeHtml:dic[@"content"]] ;
    }
    
    
    ///去除html格式

    return self;
}
-(NSString*)removeHtml:(NSString*)str
{
    //先用<和>将列表分割
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


-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_image forKey:@"image"];
    [aCoder encodeObject:_detailMessage forKey:@"message"];
    [aCoder encodeObject:_tag forKey:@"tag"];
    [aCoder encodeObject:@(_scanTimes) forKey:@"count"];
    [aCoder encodeObject:@(_ID) forKey:@"id"];
    
    [aCoder encodeObject:_title forKey:@"title"];
    [aCoder encodeObject:_content forKey:@"content"];

}
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        _name = [decoder decodeObjectForKey:@"name"];            //名称
        _image =[decoder decodeObjectForKey:@"image"];               //图片路径
        _detailMessage =[decoder decodeObjectForKey:@"message"];   //详细信息
        _tag = [decoder decodeObjectForKey:@"tag"];
        _scanTimes = [[decoder decodeObjectForKey:@"count"] intValue];              //浏览次数
        _ID = [[decoder decodeObjectForKey:@"id"] intValue];                     //唯
        
        _title = [decoder decodeObjectForKey:@"title"];
        _content =[decoder decodeObjectForKey:@"content"];
        

          }
    return self;
}



@end
