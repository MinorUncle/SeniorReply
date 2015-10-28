//
//  FoodBigListCellView.m
//  健康助手
//
//  Created by 未成年大叔 on 15/10/24.
//  Copyright © 2015年 itcast. All rights reserved.
//

#import "FoodBigListCell.h"
#import "bHttpTool.h"
#import "Healthcfg.h"

@implementation FoodBigListCell
- (IBAction)like:(id)sender {
}

- (void)awakeFromNib {
    // Initialization code
    self.layer.masksToBounds = YES;
    
   
    
    //解决按钮不能点击的问题
    [self bringSubviewToFront:self.likeBtn];
    [self bringSubviewToFront:self.shareBtn];
    
    
}

-(void)setFoodModel:(Food *)foodModel
{
    _foodModel = foodModel;
    
    [bHttpTool downloadImage:[imageBaseURL stringByAppendingPathComponent:_foodModel.image] place:[UIImage imageNamed:@"timeline_image_loading.png"] imageView:self.foodImgView];
    [self.titleLab setText:_foodModel.name];
    self.detailLab.numberOfLines = 0;
    [self.detailLab setFont:[UIFont systemFontOfSize:12]];
    if (self.isSearch) {
        [self.detailLab setText:_foodModel.content];
    }else{
        [self.detailLab setText:_foodModel.food];
    }
}
- (IBAction)sharebBtnClick:(id)sender {

    [self.listDelegate shareClick:self];
}
- (IBAction)likeBtnClick:(id)sender {
    
    [self.likeBtn setSelected:YES];
//    [DiseaseTool DetailWithParam:@{@"id":@(self.diseaseModel.ID)} success:^(id mesicines) {
//        Disease* disease = mesicines;
//        [DiseaseTool  saveDisease:disease];
//    } failure:^(NSError *err) {
//        [btn setSelected:NO];
//    }];

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
