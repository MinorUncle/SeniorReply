//
//  ClassifyController.m
//  健康助手
//
//  Created by 未成年大叔 on 15/7/24.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "FoodClassifyDetailController.h"
#import "classifyBox.h"
#import "FoodTool.h"
#import "FoodListController.h"
#import "Food.h"
@interface FoodClassifyDetailController ()
{
    ClassifyBox* _box;
}
@end

@implementation FoodClassifyDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分类";
    self.edgesForExtendedLayout = UIRectEdgeNone;
     [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController setNavigationBarHidden:YES];
    [self getData:_ID];
    // Do any additional setup after loading the view.
}

-(void)getData:(int)flg
{
    [FoodTool TypeWithParam:@{@"id":@(flg)} success:^(NSArray *mesicines) {
        _foodClass = mesicines;
        [self buildUI];
    } failure:^(NSError *err) {
        MyLog(@"%@",err);
        
    }];
}
-(void)buildUI
{
    NSMutableArray* arry = [[NSMutableArray alloc]init];
    for (Food *i in _foodClass) {
        NSDictionary* dic = @{@"id":@(i.ID),@"name":i.name};
        [arry addObject:dic];
    }
    _box = [[ClassifyBox alloc]initWithClassfyList:arry];
    _box.MBdelegate = self;
    CGRect rect = self.view.bounds;
    [_box setFrame:rect];
    [self.view addSubview:_box];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)ClassifyBox:(ClassifyBox *)box btnClick:(int)btnNum
{
    
        FoodListController * controller = [[FoodListController alloc]init];
        controller.ID = btnNum;
        controller.title = @"食物列表";
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
