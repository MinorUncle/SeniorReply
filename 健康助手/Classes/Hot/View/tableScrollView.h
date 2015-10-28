//
//  tableScrollView.h
//  健康助手
//
//  Created by 未成年大叔 on 15/8/11.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
@class tableScrollView;
typedef enum {
    kTableScrollViewTypeMedic, // 药品大全
    kTableScrollViewTypeFood, // 健康饮食
    kTableScrollViewTypeCheck, // 健康饮食
    kTableScrollViewTypeDisease, // 健康饮食
} TableScrollViewType;

@protocol tableScrollViewDelegate
- (void)tableScrollView:(tableScrollView *)table moveReach:(NSInteger)index;

@end
@interface tableScrollView : UIScrollView
@property(nonatomic,weak)id <tableScrollViewDelegate> tableScrollViewdelegate;

-(void)moveToIndex:(NSInteger)num;
-(void)setDataArry:(NSMutableArray *)dataArry Type:(TableScrollViewType)type;
@end
