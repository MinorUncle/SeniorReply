//
//  HotDetailHeader.m
//  健康助手
//
//  Created by apple on 13-11-5.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "HotDetailHeader.h"
//#import "UIImage+MJ.h"
//#import "Status.h"
#import "FDSlideBar.h"
@interface HotDetailHeader()
{
    UIButton *_selectedBtn;
    CGPoint _preiviousLocal;//上一次的位置
    float _offSet;               //竖直方向偏移量
    
}
@property (weak, nonatomic) IBOutlet UIButton *medicines;
@property (weak, nonatomic) IBOutlet UIButton *foods;
@property (weak, nonatomic) IBOutlet UIButton *diseases;
@property (weak, nonatomic) IBOutlet UIButton *checks;

@end

@implementation HotDetailHeader

#pragma mark 监听按钮点击

-(void)setNeedsLayout
{
   // [super setNeedsLayout];
}
//-(void)updateConstraints
//{}
-(void)drawRect:(CGRect)rect
{
    UIImage* img = [UIImage imageNamed:@"statusdetail_comment_top_background.png"];
    img = [img stretchableImageWithLeftCapWidth:img.size.width *0.5 topCapHeight:img.size.height * 0.5];
    [img drawInRect:rect];
}
- (IBAction)btnClick:(UIButton *)sender {
    
    
    // 控制状态
    _selectedBtn.enabled = YES;
    sender.enabled = NO;
    _selectedBtn = sender;
    
    // 移动三角形指示器
    [UIView animateWithDuration:0.3 animations:^{
        CGPoint center = _hint.center;
        center.x  = sender.center.x;
        _hint.center = center;
    }];
    
    
    HotDetailHeaderBtnType type =0;
    if (sender == self.medicines) {
        type = kHotDetailHeaderBtnTypeMedic;
    } else if(sender == self.checks){
        type = kHotDetailHeaderBtnTypeCheck;
    }else if(sender == self.foods){
        type = kHotDetailHeaderBtnTypeFood;
    }else if(sender == self.diseases){
        type = kHotDetailHeaderBtnTypeDisease;
    }
    _currentBtnType = type;
    
    // 通知代理
    if ([_delegate respondsToSelector:@selector(HotDetailHeader:btnClick:)]) {
        [_delegate HotDetailHeader:self btnClick:type];
    }
    
    
}

+ (id)header
{
    HotDetailHeader* head = [[NSBundle mainBundle] loadNibNamed:@"HotDetailHeader" owner:nil options:nil][0];
    return head;
}

- (void)awakeFromNib
{
    [self btnClick:self.medicines];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
    [self setupSlideBar];
}
-(void)pan:(UIPanGestureRecognizer*)pan
{
    if (pan.state == UIGestureRecognizerStateChanged) {
        CGPoint curr = [pan translationInView:self];
        float tem;
        tem = curr.y - _preiviousLocal.y;
        _offSet = tem;
        _preiviousLocal = curr;
        
        
        [_delegate panWithView:self offset:_offSet];//根据偏移量通知代理
        
        
    }else if (pan.state == UIGestureRecognizerStateBegan)
    {
        _preiviousLocal = [pan translationInView:self];
    }else if(pan.state == UIGestureRecognizerStateEnded)
    {
        [self.delegate endPanWithView:self];//移动结束,通知代理
    }
    
    //  NSLog(@"pan");
}
- (void)setupSlideBar {
 
    self.backgroundColor = [UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1.0];

   
    //[self.slideView setBackgroundColor:[UIColor greenColor]];

    // Set some style to the slideBar
    self.slideView.itemColor = [UIColor blackColor];
    self.slideView.itemSelectedColor = [UIColor orangeColor];
    self.slideView.sliderColor = [UIColor orangeColor];
    
    // Add the callback with the action that any item be selected

}
-(void)setDataArry:(NSMutableArray *)dataArry
{
    _dataArry = dataArry;
    
    // Init the titles of all the item
    NSMutableArray* mstr = [[NSMutableArray alloc]initWithCapacity:_dataArry.count];
    for (NSDictionary* i in _dataArry) {
        NSString* str = i[@"name"];
        [mstr addObject:str];
    }
    self.slideView.itemsTitle = mstr;
    
}




- (void)selectSlideBarItemAtIndex:(NSUInteger)index
{
    [self.slideView selectSlideBarItemAtIndex:index];
}
- (void)slideBarItemSelectedCallback:(FDSlideBarItemSelectedCallback)callback//点击slideBar的回调函数;
{
    [self.slideView slideBarItemSelectedCallback:callback];
}
@end