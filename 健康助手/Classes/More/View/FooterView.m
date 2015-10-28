//
//  FooterCell.m
//  健康助手
//
//  Created by 未成年大叔 on 15/8/8.
//  Copyright (c) 2015年 itcast. All rights reserved.
//
#define CELLPADDINGW 40


#define BTNWHIDE 40
#import "FooterView.h"
@interface FooterView()
{
    NSArray* _btnArry;
    NSInteger _currectBtn;
    NSArray* _names;
    NSArray* _images;
}
@end
@implementation FooterView


- (id)initWithBtnNames:(NSArray*)name images:(NSArray*)img
{
    self = [super init];
    if(self)
    {
        _names = name;
        _images = img;
        int number = name.count;
        _btnArry = [[NSArray alloc]init];
        
       
            for (int i = 0; i<number; i++) {
            UIButton* button =[[UIButton alloc] init];
            [button setTag:i];
            [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
        }
    }
    return self;
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    int number = [self subviews].count;
    //计算相邻距离
    float btnMagin = (self.bounds.size.width - 2.0* CELLPADDINGW - number * BTNWHIDE) / (number - 1);
    CGRect rect = CGRectMake(CELLPADDINGW, (frame.size.height-BTNWHIDE)/2.0, BTNWHIDE, BTNWHIDE);
    for (int i = 0; i<number; i++) {
        UIButton* button =[self subviews][i];
       
        [button setFrame:rect];
        [button setImage:[UIImage imageNamed:@"cover.png"] forState:UIControlStateNormal];
        
        
        UILabel* lable = [[UILabel alloc]init];
        CGRect labRect = rect;
        labRect.origin.y += CELLPADDINGW;
        labRect.size.height =20;
        [lable setFrame:labRect];
        [lable setText:_names[i]];
        [lable setFont:[UIFont systemFontOfSize:10.0]];
        [lable setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:lable];
        
        rect.origin.x += btnMagin +BTNWHIDE;
    }
    
}
-(void)btnClick:(UIButton*)btn
{
    NSInteger currect = _currectBtn;
    [self setToNum:btn.tag];
    [_delegate dumpFromNum:currect ToNum:btn.tag];
    

}
-(void)setToNum:(NSInteger)toNum
{
    
    CATransition *anim = [[CATransition alloc]init];
    anim.type = @"fade";
    UIButton* btnDesc = [self subviews][toNum];
    [btnDesc setImage:[UIImage imageNamed:_images[toNum]] forState:UIControlStateNormal];
    [btnDesc.layer addAnimation:anim forKey:nil];
    
    UIButton* btnSoc = [self subviews][_currectBtn];
    [btnSoc setImage:[UIImage imageNamed:@"cover.png"] forState:UIControlStateNormal];
    [btnSoc.layer addAnimation:anim forKey:nil];

    
    _currectBtn = toNum;

}


@end
