//
//  BaseList.m
//  健康助手
//
//  Created by 未成年大叔 on 15/8/12.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "BaseList.h"
#import "MJRefresh.h"
@interface UITableView (GJ)
{
}
@end
@implementation UITableView (GJ)

-(BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
{

    return YES;
}
-(BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    
    //NO scroll不可以滚动 YES scroll可以滚动
    return YES;
}


@end
@interface BaseList ()

@end

@implementation BaseList

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self.tableView setDelaysContentTouches:NO];
    [self.tableView setCanCancelContentTouches:YES];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)setID:(NSInteger)ID
{
    _ID = ID;
    self.idKey=@"pid";
    [self getData];
    
}
- (UIViewController*)viewController:(UIView*)view
{
    for (UIView* next = [view superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}
-(void)getData
{
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
