
#define MBoxH 136
#define MBoxW 136

#define MContentHPannd 20     //水平边距
#define MContentVPannd 20     //垂直边距

#define MCellMargin 8  //盒子垂直间距

#import "UIImage+MJ.h"
#import "MainBoxView.h"
@interface MainBoxView()
{
}
@end
@implementation MainBoxView



-(void)buildBtnWithFlg:(int) flg img:(NSString*)img rect:(CGRect)rect
{
    UIButton* btn = [[UIButton alloc]init];
    UIImage* image = [UIImage imageNamed:img];
    UIImage* bgImag = [UIImage imageNamed:img];
    [btn setTag:flg];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    [btn setBackgroundImage:bgImag forState:UIControlStateSelected];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn setFrame:rect];
    [self addSubview:btn];

    
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self addView];
    }
    return self;
}
-(void)addView
{
    int flg = 0;
    CGSize size = self.bounds.size;
    //药品大全
    CGRect rect = (CGRect){MContentHPannd,MContentVPannd,0,0};
    rect.size = CGSizeMake(MBoxW, MBoxH);
    NSString* imgName = @"medicine.png";
    [self buildBtnWithFlg:flg++ img:imgName rect:rect];
    
    
    //健康食谱
    rect.origin = CGPointMake(size.width - MContentHPannd-MBoxW, rect.origin.y);
    imgName = @"food.png";
    [self buildBtnWithFlg:flg++ img:imgName rect:rect];
    
      //疾病查找  
    rect.origin = CGPointMake(MContentHPannd, CGRectGetMaxY(rect) + MCellMargin);
    imgName = @"diease.png";
    [self buildBtnWithFlg:flg++ img:imgName rect:rect];
    
    //检查项目
    rect.origin = CGPointMake(size.width - MContentHPannd-MBoxW, rect.origin.y);
    imgName = @"check.png";
    [self buildBtnWithFlg:flg++ img:imgName rect:rect];
    
    //药店大全
    rect.origin = CGPointMake(MContentHPannd, CGRectGetMaxY(rect) + MCellMargin);
    imgName = @"Store.png";
    [self buildBtnWithFlg:flg++ img:imgName rect:rect];
//
//    //健康图书
//    rect.origin = CGPointMake(size.width - MContentHPannd-MBoxW, rect.origin.y);
//    imgName = @"";
//    [self buildBtnWithFlg:flg++ img:imgName rect:rect];
//    
//    //健康资讯
//
//    rect.origin = CGPointMake(MContentHPannd, CGRectGetMaxY(rect) + MCellMargin);
//    imgName = @"";
//    [self buildBtnWithFlg:flg++ img:imgName rect:rect];
//    
//    //健康知识
//    rect.origin = CGPointMake(size.width - MContentHPannd-MBoxW, rect.origin.y);
//    imgName = @"";
//    [self buildBtnWithFlg:flg++ img:imgName rect:rect];
    
    [self setContentSize:CGSizeMake(0,CGRectGetMaxY(rect))];
    [self setContentInset:UIEdgeInsetsMake(0, 0, 44, 0)];

}
-(void)btnClick:(UIButton*) btn
{
    [_Mdelegate MainBoxView:self btnClick:btn.tag];
    }
@end