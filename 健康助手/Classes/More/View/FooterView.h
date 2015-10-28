//
//  FooterCell.h
//  健康助手
//
//  Created by 未成年大叔 on 15/8/8.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FooterViewDelegate
-(void)dumpFromNum:(NSInteger)soc ToNum:(NSInteger)des;
@end
@interface FooterView : UIView
@property (nonatomic,weak)id<FooterViewDelegate> delegate;
- (id)initWithBtnNames:(NSArray*)name images:(NSArray*)img;
-(void)setToNum:(NSInteger)toNum;

@end
