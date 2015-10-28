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
#import "MedicineTool.h"
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

- (void)addAllSubviews
{
    [super addAllSubviews];
    // 1.配图
    [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
    CGRect rect = CGRectMake(2, 0, MedicCellW, MedicCellH);
    
    //绘制圆角
    [self.imageView.layer setCornerRadius:MedicCellH/2];
    [self.imageView.layer setMasksToBounds:YES];
    
    [self.imageView clearsContextBeforeDrawing];
    [self.imageView setFrame:rect];
    
    [self.contentView addSubview:self.imageView];
    
    
    
    
    //名称
    rect = (CGRect){CGRectGetMaxX(self.imageView.frame)+40,rect.origin.y + 10,self.bounds.size.width - self.imageView.frame.size.width,self.imageView.frame.size.height * 0.3};
    [self.name  setFrame:rect];
    
    
    //收藏按钮
    //   self.LikeButton.frame = ;
    UIImage* img = [UIImage imageNamed:@"like.png"];
    CGRect imgRect;
    imgRect.size = img.size;
    imgRect.size.height *= 0.4;
    imgRect.size.width *= 0.4;
    imgRect.origin.x = CGRectGetMaxX(self.imageView.frame)+10;
    imgRect.origin.y = CGRectGetMaxY(rect) +10;
    [self.LikeButton setFrame:imgRect];
    [self.LikeButton setImage:img forState:UIControlStateNormal];
    [self.LikeButton setImage:[UIImage imageNamed:@"like_select.png"] forState:UIControlStateSelected];
    [self.LikeButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //左边小标题
    [self.leftTitle setTextColor:[UIColor redColor]];
    [self.leftTitle setFont:[UIFont systemFontOfSize:12]];
    rect = (CGRect){CGRectGetMaxX(self.imageView.frame)+40,CGRectGetMaxY(rect),80,self.imageView.frame.size.height * 0.5};
    [self.leftTitle setFrame:rect];
    
    
    //右边小标题
    [self.rightTitle setTextColor:[UIColor redColor]];
    [self.rightTitle setFont:[UIFont systemFontOfSize:10]];
    rect = (CGRect){CGRectGetMaxX(rect)+10,rect.origin.y,self.bounds.size.width - CGRectGetMaxX(rect),rect.size.height};
    [self.rightTitle setFrame:rect];
    
    
}
-(void)click:(UIButton*)btn
{
    [btn setSelected:YES];
    [MedicineTool DetailWithParam:@{@"id":@(self.medicine.ID)} success:^(id mesicines) {
        Medicine* medicine = mesicines;
        [MedicineTool  saveMedicine:medicine];
    } failure:^(NSError *err) {
        [btn setSelected:NO];
    }];
}


- (UIViewController*)viewController:(UIView*)view
{
    for (UIView* next = [view superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}


-(void)setMedicine:(Medicine *)medicine
{
    _medicine = medicine;
    
    // 1.配图
    
    [bHttpTool downloadImage:[imageBaseURL stringByAppendingPathComponent:_medicine.image] place:[UIImage imageNamed:@"timeline_image_loading.png"] imageView:self.imageView];
    
    if ([MedicineTool existCorrentMedicine:_medicine.ID]) {
        [self.LikeButton setSelected:YES];
    }else{
        [self.LikeButton setSelected:NO];
    }
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


@end
