//
//  HotController.h
//  健康助手
//
//  Created by 未成年大叔 on 15/8/10.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotController : UIViewController
@property (nonatomic,assign)int ID; //分类id
@property (nonatomic,assign)int currentPage;//当前浏览页数
@property (nonatomic,copy)NSString* idKey;  //pid则按照分类浏览,id则按照最新浏览
@end
