//
//  HotDetailHeader.h
//  健康助手
//
//  Created by 未成年大叔 on 15/8/11.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDSlideBar.h"
@class Status, HotDetailHeader;
typedef enum {
    kHotDetailHeaderBtnTypeMedic, // 药品大全
    kHotDetailHeaderBtnTypeFood, // 健康饮食
    kHotDetailHeaderBtnTypeCheck, // 健康饮食
    kHotDetailHeaderBtnTypeDisease, // 健康饮食
} HotDetailHeaderBtnType;

@protocol HotDetailHeaderDelegate <NSObject>
@optional
- (void)HotDetailHeader:(HotDetailHeader *)header btnClick:(HotDetailHeaderBtnType)index;

//控制拖动时移动
-(void)panWithView:(UIView*)view offset:(float)heigh;
//控制拖动停止
-(void)endPanWithView:(UIView*)view;

@end




@interface HotDetailHeader : UIView
@property (weak, nonatomic) IBOutlet UIImageView *hint;



- (IBAction)btnClick:(UIButton *)sender;
- (void)selectSlideBarItemAtIndex:(NSUInteger)index;                //移动到了第index个item;
- (void)slideBarItemSelectedCallback:(FDSlideBarItemSelectedCallback)callback;//点击slideBar的回调函数;

+ (id)header;

@property (weak, nonatomic) IBOutlet FDSlideBar *slideView;
@property (nonatomic,strong)NSMutableArray* dataArry;            //包含名字和id
@property (nonatomic, weak) id<HotDetailHeaderDelegate> delegate;

@property (nonatomic, assign, readonly) HotDetailHeaderBtnType currentBtnType;
@end
