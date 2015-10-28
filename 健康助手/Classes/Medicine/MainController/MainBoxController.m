//
//  MainBoxController.m
//  健康助手
//
//  Created by 未成年大叔 on 15/7/25.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "MainBoxController.h"
#import "MediclineMainController.h"
#import "FoodMainController.h"
#import "DiseaseMainController.h"
#import "CheckMainController.h"
#import "StoreMainController.h"
@interface MainBoxController ()

@end

@implementation MainBoxController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buileUI];
    // Do any additional setup after loading the view.
}
-(void)buileUI
{
    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.title = @"首页";
    CGRect rect = self.view.bounds;
    rect.size.height -= 44;
    MainBoxView* BoxView = [[MainBoxView alloc]initWithFrame:rect];
    BoxView.Mdelegate = self;
    [self.view addSubview:BoxView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)MainBoxView:(MainBoxView*)box btnClick:(int) btnNum
{
    UIViewController* controller;

    switch (btnNum) {
        case 0:
            controller = [[MediclineMainController alloc]init];
            break;
        case 1:
            controller = [[FoodMainController alloc]init];
            
            break;
        case 2:
            controller = [[DiseaseMainController alloc]init];

            break;
        case 3:
            controller = [[CheckMainController alloc]init];

            break;
        case 4:
            controller = [[StoreMainController alloc]init];
            
            break;
        case 5:
            
            break;
        case 6:
            
            break;
        case 7:
            
            break;
        default:
            break;
    }
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
