//
//  CommentController.m
//  健康助手
//
//  Created by 未成年大叔 on 15/7/22.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#define RepostBoxH 20
#import "CommentController.h"
#import "CommentTool.h"


@interface CommentController ()
{
    UITextView* textView;
}
@end

@implementation CommentController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildUI];
    [self bulidDock];
    // Do any additional setup after loading the view.
}
-(void)bulidDock
{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btn.imageView.contentMode = UIViewContentModeLeft ;
    [btn setImage:[UIImage imageNamed:@"box_check_true.png"] forState:UIControlStateSelected];
    
    
    [btn setImage:[UIImage imageNamed:@"box_check_false.png"] forState:UIControlStateNormal];
    
    [btn setTitle:@"同时转发" forState:UIControlStateNormal];
    CGRect rect = {0,self.view.bounds.size.height - RepostBoxH,self.view.bounds.size.width,RepostBoxH};
    [btn setFrame:rect];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    [btn setAdjustsImageWhenHighlighted:NO];
    
    [self.view addSubview:btn];
}
-(void)btnClick:(UIButton*)btn
{
    [btn setSelected:!btn.selected];
    
}
-(void)buildUI
{
    CGRect rect = self.view.bounds;
    rect.size.height -= RepostBoxH;
    textView = [[UITextView alloc]initWithFrame:rect];
    [self.view addSubview:textView];
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(back)];

    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(send)];
    self.navigationItem.rightBarButtonItem = rightItem;
}
-(void)back
{
    

}
-(void)send
{
  //  [CommentTool sendCommentWith:_statusID comment:textView.text];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
