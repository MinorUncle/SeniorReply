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
#import "CheckCell.h"
#import "Check.h"
#import "Healthcfg.h"
#import "CheckTool.h"
@interface CheckCell ()
{

}
@end
@implementation CheckCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 1.添加数据本身的子控件
          // 2.添加被转发数据的子控件
        
       
    }
    return self;
}



#pragma mark 添加本身的子控件
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
    rect = (CGRect){CGRectGetMaxX(self.imageView.frame)+40,rect.origin.y + 10,self.bounds.size.width - self.imageView.frame.size.width,self.imageView.frame.size.height * 0.4};
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
    [CheckTool DetailWithParam:@{@"id":@(self.checkModel.ID)} success:^(id mesicines) {
        Check* check =mesicines;
         [CheckTool  saveCheck:check];
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

-(void)setCheckModel:(Check *)CheckModel
{
    _checkModel = CheckModel;
    // 1.配图
    
    [bHttpTool downloadImage:[imageBaseURL stringByAppendingPathComponent:_checkModel.image] place:[UIImage imageNamed:@"timeline_image_loading.png"] imageView:self.imageView];
    
    if ([CheckTool existCorrentCheck:_checkModel.ID]) {
        [self.LikeButton setSelected:YES];
    }else{
        [self.LikeButton setSelected:NO];
    }
 
   if(!self.isSerach)
   {
    //名称
    self.name.text = _checkModel.name;
    //
    self.leftTitle.text = _checkModel.menu;
    
    //.rightTitle.text = _checkModel.tag;
   }else
   {
       //名称
       self.name.text = _checkModel.title;
       //浏览次数
       self.leftTitle.text =[NSString stringWithFormat:@"浏览次数:%@",@(_checkModel.scanTimes)];
       //tag
       self.rightTitle.text = _checkModel.content;
   }
}





@end
