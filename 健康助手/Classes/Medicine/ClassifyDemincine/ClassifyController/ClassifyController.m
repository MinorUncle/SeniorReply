//
//  ClassifyController.m
//  健康助手
//
//  Created by 未成年大叔 on 15/7/24.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "ClassifyController.h"
#import "classifyBox.h"
#import "MedicineTool.h"
#import "MedicineListController.h"
@interface ClassifyController ()

@end

@implementation ClassifyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分类";
    self.edgesForExtendedLayout = UIRectEdgeNone;
     [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [MedicineTool TypeWithParam:nil success:^(NSArray *mesicines) {
        _medicClass = mesicines;
        [self buildUI];
    } failure:^(NSError *err) {
        MyLog(@"%@",err);
    }];
     
    
    // Do any additional setup after loading the view.
}
-(void)buildUI
{
    NSMutableArray* arry = [[NSMutableArray alloc]init];
    for (Medicine *i in _medicClass) {
        NSDictionary* dic = @{@"id":@(i.ID),@"name":i.name};
        [arry addObject:dic];
    }
   
    ClassifyBox* box = [[ClassifyBox alloc]initWithClassfyList:arry];
    box.MBdelegate = self;
    CGRect rect = self.view.bounds;
    [box setFrame:rect];
    [self.view addSubview:box];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)ClassifyBox:(ClassifyBox *)box btnClick:(int)btnNum
{
    MedicineListController * controller = [[MedicineListController alloc]init];
    controller.ID = btnNum;
    
    [self.navigationController pushViewController:controller animated:YES];
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
