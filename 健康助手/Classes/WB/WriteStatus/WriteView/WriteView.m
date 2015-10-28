//
//  WriteView.m
//  健康助手
//
//  Created by 未成年大叔 on 15/7/23.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#define RepostBoxH 30
#import "WriteView.h"

@implementation WriteView

-(id)initWithText:(NSString*)t
{
    if (self = [super init]) {
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn setBackgroundColor:[UIColor whiteColor]];
        [_btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _btn.imageView.contentMode = UIViewContentModeLeft ;
        [_btn setImage:[UIImage imageNamed:@"box_check_true.png"] forState:UIControlStateSelected];
        
        [_btn setImage:[UIImage imageNamed:@"box_check_false.png"] forState:UIControlStateNormal];
        
        [_btn setTitle:t forState:UIControlStateNormal];
        
        [_btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
        [_btn setAdjustsImageWhenHighlighted:NO];
        [self addSubview:_btn];
        
        _textView = [[UITextView alloc]init];
        [self addSubview:_textView];
        
    }
   
    return self;
}
-(void)btnClick:(UIButton*)btn
{
    [btn setSelected:!btn.selected];
    _btnSelected = !_btnSelected;
    
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    CGRect rect = {0,frame.size.height - RepostBoxH,frame.size.width,RepostBoxH};
    [_btn setFrame:rect];
    MyLog(@"CG %@",NSStringFromCGRect(_btn.bounds));

    
    rect = (CGRect){0,0,self.bounds.size.width,self.bounds.size.height - RepostBoxH};
    [_textView setFrame:rect];
    _textView.backgroundColor = [UIColor redColor];
}


@end
