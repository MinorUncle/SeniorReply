//
//  classifyBox.m
//  健康助手
//
//  Created by 未成年大叔 on 15/7/24.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#define boxH 25
#define boxHMargin 20    //box水平之间距离
#define boxVMargin 10
#define cellCount 3   //一行的个数
#define contentHPannd 20     //水平边距
#define contentVPannd 20     //垂直边距

#import "UIImage+MJ.h"
#import "classifyBox.h"

@interface ClassifyBox()
{
}
@end
@implementation ClassifyBox

-(id)initWithClassfyList:(NSArray*)classifyList
{
    if (self = [super init]) {
        _classifyList = classifyList;
        [self setUserInteractionEnabled:YES];
        [self addView];
        
    }
    return self;
}
-(void)setFrame:(CGRect)frame
{
    
    [super setFrame:frame];
    if (!_classifyList) {
        return;
    }
    NSInteger remainder = _classifyList.count % cellCount;
    NSInteger count = _classifyList.count - _classifyList.count%cellCount;
    float width = (self.bounds.size.width - 2.0*contentHPannd - (cellCount-1.0)*boxHMargin)/cellCount;
    CGRect rect = (CGRect){0,0,0,0};
    rect.size = CGSizeMake(width, boxH);
    int i = 0;
    for (i=0; i < count; i++) {
        float x = i % cellCount;
        float y = i / cellCount;
        rect.origin.x = contentHPannd + (boxHMargin + width)*x;
        rect.origin.y = contentVPannd + (boxVMargin + boxH)*y;
        UIButton* btn = self.subviews[i];
       
        [btn setFrame:rect];
    }
    if (remainder == 1) {
        rect.origin.x = contentHPannd;
        rect.origin.y = CGRectGetMaxY(rect) + boxVMargin;
        rect.size.width = self.bounds.size.width - 2*contentHPannd;
        UIButton* btn = self.subviews[i++];
        
        [btn setFrame:rect];
    }
    if (remainder == 2) {
        rect.origin.x = contentHPannd;
        rect.origin.y = CGRectGetMaxY(rect) + boxVMargin;
        rect.size.width = (self.bounds.size.width - 2*contentHPannd - boxHMargin) / 2.0;
        UIButton* btn = self.subviews[i++];
        
        [btn setFrame:rect];
        
        rect.origin.x += rect.size.width + boxHMargin;
        btn = self.subviews[i];
        [btn setFrame:rect];
    }
    self.contentSize = CGSizeMake(0, CGRectGetMaxY(rect));
    
    if (self.contentSize.height < self.bounds.size.height  - 44) {
        self.contentSize =CGSizeMake(0,self.bounds.size.height+1);
    }else{
        self.contentInset = UIEdgeInsetsMake(0, 0, 140, 0);
    }

}
-(void)addView
{
    if (_classifyList == nil) {
        return;
    }
    [self setBackgroundColor:[UIColor whiteColor]];
    MyLog(@"count %lu",(unsigned long)_classifyList.count);
    

    for (int i=0; i < _classifyList.count; i++) {
        
        UIButton* btn = [[UIButton alloc]init];
        [btn setTitle:_classifyList[i][@"name"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:10]];
        [btn setBackgroundImage:[UIImage resizedImage:@"common_card_background.png"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage resizedImage:@"common_card_background_highlighted.png"] forState:UIControlStateSelected];
        [btn setTag:[((NSDictionary*)_classifyList[i])[@"id"] intValue]];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:btn];
    }
}
-(void)btnClick:(UIButton*) btn
{
    [_MBdelegate ClassifyBox:self btnClick:btn.tag];
}
-(void)setMBdelegate:(id<ClassifyDelegate>)MBdelegate
{
    _MBdelegate = MBdelegate;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
