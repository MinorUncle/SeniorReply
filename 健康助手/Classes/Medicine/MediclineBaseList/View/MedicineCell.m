//
//  MedicineCell.m
//  健康助手
//
//  Created by 未成年大叔 on 15/7/23.
//  Copyright (c) 2015年 itcast. All rights reserved.
//
#define MedicIMGH 160
#define MedicIMGW 220
#define MedicCellH 44   //图片占用高度
#define MedicCellW 44   //图片占用宽度
#import "bHttpTool.h"
#import "UIImage+MJ.h"
#import "MedicineCell.h"
#import "Medicine.h"
#import "Healthcfg.h"
@interface MedicineCell ()
{

}
@end
@implementation MedicineCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}


-(void)setMedicine:(Medicine *)medicine
{
    _medicine = medicine;
    
    // 1.配图
    
    [bHttpTool downloadImage:[imageBaseURL stringByAppendingPathComponent:_medicine.image] place:[UIImage imageNamed:@"timeline_image_loading.png"] imageView:self.imageView];
    
    if (!self.isSerach) {
        //名称
        
        self.name.text = _medicine.name;
        
        //类型
        
        self.leftTitle.text = _medicine.type;
        
        //产地
        self.rightTitle.text = _medicine.factory;
    }else
    {
        //名称
        self.name.text = _medicine.title;
        //浏览次数
        self.leftTitle.text =[NSString stringWithFormat:@"浏览次数:%@",@(_medicine.scanTimes)];
        //tag
        self.rightTitle.text = _medicine.content;
    }
}

//-(void)setRow:(int)row{
//    self.row = row;
//    if (row == 0) {
//        _bg.image = [UIImage resizedImage:@"common_card_top_background.png"];
//        _selectedBg.image =[UIImage resizedImage:@"common_card_middle_background_highlighted.png"];
//    }

//}




@end
