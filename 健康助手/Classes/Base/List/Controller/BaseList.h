//
//  BaseList.h
//  健康助手
//
//  Created by 未成年大叔 on 15/8/12.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseList : UITableViewController
@property (nonatomic,assign)NSInteger ID;
@property (nonatomic,assign)NSInteger currentPage;
@property (nonatomic,retain)NSString* idKey;  //pid则按照分类浏览,id则按照最新浏览
@property (nonatomic,copy)NSString* keyWord;  

@property (nonatomic,assign)BOOL findState; //是否查找状态
//- (void)showNewStatusCount:(int)count;
@property(nonatomic,retain)UINavigationController* Navigationdelegate;
- (UIViewController*)viewController:(UIView*)view;
@end
