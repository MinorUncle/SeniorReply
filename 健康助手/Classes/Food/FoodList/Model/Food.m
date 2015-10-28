//
//  Medicine.m
//  健康助手
//
//  Created by 未成年大叔 on 15/7/23.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "Food.h"

@implementation Food
@synthesize image = _image;
- (Food*)initWithDict:(NSDictionary*)food
{
    if(self = [super initWithDict:food])
    {
        _image =food[@"img"];               //重写路径key图片路径
        _food = food[@"food"];           ///材料
        _bar = food[@"bar"];            //食品主要功能
        

    }
    return self;
}

- (Food*)initWithSearchDict:(NSDictionary*)food
{
   
    if(self = [super initWithSearchDict:food])
    {
        _image =food[@"img"];               //图片路径

        self.name = [self removeHtml:food[@"name"]] ;
        self.title = [self removeHtml:food[@"name"]] ;
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



-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:_image forKey:@"img"];
    [aCoder encodeObject:_food forKey:@"food"];           ///材料
    [aCoder encodeObject:_bar forKey:@"bar"];

}
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super initWithCoder:decoder]) {
       
        _image =[decoder decodeObjectForKey:@"img"];               //图片路径
        _food =[decoder decodeObjectForKey:@"food"];           ///材料
        _bar = [decoder decodeObjectForKey:@"bar"];            //食品主要功能

          }
    return self;
}



@end
