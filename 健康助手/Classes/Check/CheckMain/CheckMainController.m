//
//  MediclineController.m
//  健康助手
//
//  Created by 未成年大叔 on 15/7/24.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "CheckMainController.h"
#import "CheckClassifyController.h"
#import "CheckListController.h"
#import "CheckCollectController.h"
#import "CheckTool.h"
@interface CheckMainController ()

@end

@implementation CheckMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    [CheckTool initPath];
    
    [self setTitle:@"检查项目"];

    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    CGRect rect=_dock.frame;
    rect.origin.y -= 64;
    [_dock setFrame:rect];
    // 1.初始化所有的子控制器
    [self addAllChildControllers];
    
    // 2.初始化DockItems
    [self addDockItems];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 初始化所有的子控制器
- (void)addAllChildControllers
{
    // 2.列表
    CheckListController *msg = [[CheckListController alloc] init];
    [self addChildViewController:msg];
    

    // 1.分页
    CheckClassifyController *home = [[CheckClassifyController alloc] init];
    [self addChildViewController:home];
    
    //收藏
    CheckCollectController *collect = [[CheckCollectController alloc]init];
    [self addChildViewController:collect];
}

#pragma mark 实现导航控制器代理方法
// 导航控制器即将显示新的控制器


- (void)back
{
    [self.childViewControllers[_dock.selectedIndex] popViewControllerAnimated:YES];
}


#pragma mark 添加Dock
- (void)addDockItems
{
// 1.设置Dock的背景图片
    _dock.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbar_background.png"]];
    
    // 2.往Dock里面填充内容
    [_dock addItemWithIcon:@"tabbar_home.png" selectedIcon:@"tabbar_home_selected.png" title:@"热门"];
    
    [_dock addItemWithIcon:@"tabbar_message_center.png" selectedIcon:@"tabbar_message_center_selected.png" title:@"分类"];
    
    [_dock addItemWithIcon:@"tabbar_message_center.png" selectedIcon:@"tabbar_message_center_selected.png" title:@"收藏"];
    
    
 
}

- (void)dock:(Dock *)dock itemSelectedFrom:(int)from to:(int)to
{
    [super dock:dock itemSelectedFrom:from to:to];
    switch (_dock.selectedIndex) {
        case 0:
            self.title = @"检查项目";
            break;
        case 1:
            self.title = @"检查分类";
            break;
        case 2:
            self.title = @"检查收藏";
            break;
            
            
        default:
            break;
    }
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
