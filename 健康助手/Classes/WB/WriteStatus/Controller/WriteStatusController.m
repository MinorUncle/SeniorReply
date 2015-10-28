//
//  WriteStatusController.m
//  健康助手
//
//  Created by 未成年大叔 on 15/7/23.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "WriteStatusController.h"
#import "WriteView.h"
#import "WriteTool.h"
@interface WriteStatusController ()
{
    WriteView* _writeView;
}
@end

@implementation WriteStatusController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildUI];
    [self bulidDock];
    // Do any additional setup after loading the view.
}
-(void)bulidDock
{
    CGRect rect =self.view.bounds;
    rect.origin.y += kStatusHight;
    rect.size.height -= kStatusHight;
    _writeView = [[WriteView alloc]initWithText:@"是否公开"];
    
    [self.view addSubview:_writeView];
    [_writeView setFrame:rect];


}

-(void)buildUI
{
 
//    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
    
    //leftItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonItemStyleDone];
 //   UIBarButtonItem* leftItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(back)];

    self.navigationItem.leftBarButtonItem.title = @"取消";
    self.navigationItem.leftBarButtonItem.image = nil;
    self.navigationItem.leftBarButtonItem.customView = nil;

    
    NSLog(@"%@",self.navigationItem.leftBarButtonItem);
    
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(send)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}
-(void)back
{
    
    
}
-(void)send
{
    [WriteTool sendStatusWithArticle:_writeView.textView.text permission:_writeView.btnSelected ? 1 : 0 success:^(Status *sta) {
        [self.navigationController popViewControllerAnimated:YES];

    } failure:^(NSError *er) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"发送失败!!!" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
    }];
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
