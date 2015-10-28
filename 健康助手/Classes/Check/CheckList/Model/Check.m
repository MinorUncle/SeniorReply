//
//  Medicine.m
//  健康助手
//
//  Created by 未成年大叔 on 15/7/23.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "Check.h"

@implementation Check
@synthesize image = _image,detailMessage = _detailText;

- (Check*)initWithDict:(NSDictionary*)check
{
    if(self = [super initWithDict:check])
    {
        _image = check[@"img"];               //重写路径key图片路径

        _menu = check[@"menu"];  //分类
        _summary = check[@"summary"];
        _detailText = check[@"detailText"];

    }
    return self;
}

- (Check*)initWithSearchDict:(NSDictionary*)check
{
   
    if(self = [super initWithSearchDict:check])
    {
        _image = check[@"img"];
      
    }
    return self;
}


-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:_image forKey:@"img"];
    [aCoder encodeObject:_menu forKey:@"menu"];
    [aCoder encodeObject:_summary forKey:@"summary"];
    [aCoder encodeObject:_detailText forKey:@"detailText"];

  

    
}
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super initWithCoder:decoder]) {
        
        _image =[decoder decodeObjectForKey:@"img"];               //图片路径
        _menu =[decoder decodeObjectForKey:@"menu"];
        _summary = [decoder decodeObjectForKey:@"summary"];
        _detailText =[decoder decodeObjectForKey:@"detailText"];
        
      
        
        
     
          }
    return self;
}



@end
