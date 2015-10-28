//
//  classifyBox.h
//  健康助手
//
//  Created by 未成年大叔 on 15/7/24.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class ClassifyBox;

@protocol ClassifyDelegate <NSObject>
@optional
-(void)ClassifyBox:(ClassifyBox*)box btnClick:(int) btnNum;
@end
@interface ClassifyBox : UIScrollView
@property(nonatomic,strong) NSArray* classifyList;
-(id)initWithClassfyList:(NSArray*)classifyList;
@property(nonatomic,weak) id<ClassifyDelegate> MBdelegate;

@end
