//
//  WBNavigationController.m
//  健康助手
//
//  Created by apple on 13-10-27.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "WBNavigationController.h"
#import "UIImage+MJ.h"

@interface WBNavigationController ()

@end

@implementation WBNavigationController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];

    
    // 1.appearance方法返回一个导航栏的外观对象
    // 修改了这个外观对象，相当于修改了整个项目中的外观
    UINavigationBar *bar = [UINavigationBar appearance];
    [bar setBackgroundColor: [UIColor clearColor]];
    
    // 2.设置导航栏的背景图片
//    [bar setBackgroundImage:[UIImage resizedImage:@"navigationbar_background.png"] forBarMetrics:UIBarMetricsDefault];
    
    
    // 3.设置导航栏文字的主题
    [bar setTitleTextAttributes:@{
      UITextAttributeTextColor : [UIColor blackColor],
UITextAttributeTextShadowOffset : [NSValue valueWithUIOffset:UIOffsetZero]
     }];
    
    // 4.修改所有UIBarButtonItem的外观
    UIBarButtonItem *barItem = [UIBarButtonItem appearance];
    // 修改item的背景图片
    [barItem setBackgroundImage:[UIImage imageNamed:@"navigationbar_button_background.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [barItem setBackgroundImage:[UIImage imageNamed:@"navigationbar_button_background_pushed.png"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    // 修改item上面的文字样式
    NSDictionary *dict = @{
                           UITextAttributeTextColor : [UIColor darkGrayColor],
                           UITextAttributeTextShadowOffset : [NSValue valueWithUIOffset:UIOffsetZero]
                           };
    [barItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    [barItem setTitleTextAttributes:dict forState:UIControlStateHighlighted];
    
    // 5.设置状态栏样式
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
 
    
}

//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    
//    
//    [super pushViewController:viewController animated:YES];
//}

@end
