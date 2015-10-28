//
//  MainBoxView.h
//  健康助手
//
//  Created by 未成年大叔 on 15/7/25.
//  Copyright (c) 2015年 itcast. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class MainBoxView;

@protocol MainBoxViewDelegate <NSObject>
@optional
-(void)MainBoxView:(MainBoxView*)box btnClick:(int) btnNum;
@end



@interface MainBoxView : UIScrollView
@property(nonatomic,weak) id<MainBoxViewDelegate> Mdelegate;

@end
