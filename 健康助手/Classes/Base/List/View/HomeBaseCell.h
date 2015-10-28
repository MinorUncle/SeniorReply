//
//  MedicineCell.h
//  健康助手
//
//  Created by 未成年大叔 on 15/7/23.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCell.h"
@class HomeBaseModel;

@interface HomeBaseCell : BaseCell
@property(nonatomic,strong)HomeBaseModel* baseModel;
@property(nonatomic,assign)NSInteger row;
//@property(nonatomic,strong)UIImageView* topImageView;

@property(nonatomic,strong)UIImageView* imageView;
@property(nonatomic,strong)UILabel* name;
@property(nonatomic,strong)UILabel* leftTitle;
@property(nonatomic,strong)UILabel* rightTitle;
@property(nonatomic,strong)UIButton* LikeButton;

- (void)addAllSubviews;




@end
