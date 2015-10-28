//
//  FoodBigListCellView.h
//  健康助手
//
//  Created by 未成年大叔 on 15/10/24.
//  Copyright © 2015年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Food.h"
@protocol FoodBigListCellDegate
-(void)shareClick:(UITableViewCell*)cel;

@end


@interface FoodBigListCell : UITableViewCell 

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;
@property (weak, nonatomic) IBOutlet UIImageView *foodImgView;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@property (nonatomic)Food* foodModel;
@property (nonatomic)BOOL isSearch;

@property(weak,nonatomic) id <FoodBigListCellDegate>listDelegate;
@end
