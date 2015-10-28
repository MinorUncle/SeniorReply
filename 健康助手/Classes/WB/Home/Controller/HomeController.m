//
//  HomeController.m
//  健康助手
//
//  Created by apple on 13-10-27.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "HomeController.h"
#import "UIBarButtonItem+MJ.h"
#import "AccountTool.h"
#import "StatusTool.h"
#import "Status.h"
#import "User.h"
#import "StatusCellFrame.h"
#import "StatusCell.h"
#import "MJRefresh.h"
#import "UIImage+MJ.h"
#import "StatusDetailController.h"
#import "CommentController.h"
#import "WriteStatusController.h"
@interface HomeController ()
{
    NSMutableArray *_statusFrames;
}
@end

@implementation HomeController
//kHideScroll

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1.设置界面属性
    [self buildUI];
    
    // 2.集成刷新控件
    [self addRefreshViews];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

#pragma mark 集成刷新控件
- (void)addRefreshViews
{
    _statusFrames = [NSMutableArray array];
    
    __weak HomeController* temSelf = self;
    
    [temSelf.tableView addLegendHeaderWithRefreshingBlock:^{
        // 1.第1条数据的ID
        StatusCellFrame *f = _statusFrames.count?_statusFrames[0]:nil;
        long long first = [f.status ID];
        
        // 2.获取数据数据
        [StatusTool statusesWithSinceId:first maxId:0 success:^(NSArray *statues){
            // 1.在拿到最新数据数据的同时计算它的frame
            NSMutableArray *newFrames = [NSMutableArray array];
            for (Status *s in statues) {
                StatusCellFrame *f = [[StatusCellFrame alloc] init];
                f.status = s;
                [newFrames addObject:f];
            }
            
            // 2.将newFrames整体插入到旧数据的前面
            [_statusFrames insertObjects:newFrames atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newFrames.count)]];
            
            // 3.刷新表格
            [self.tableView reloadData];
            
            // 4.让刷新控件停止刷新状态
            [temSelf.tableView.header endRefreshing];
            
            // 5.顶部展示最新数据的数目
            [self showNewStatusCount:statues.count];
        } failure:^(NSError *error) {
            [temSelf.tableView.header endRefreshing];
        }];

        
    }];
    [temSelf.tableView addLegendFooterWithRefreshingBlock:^{
        // 1.最后1条数据的ID
        StatusCellFrame *f = [_statusFrames lastObject];
        long long last = [f.status ID];
        
        // 2.获取数据数据
        [StatusTool statusesWithSinceId:0 maxId:last - 1 success:^(NSArray *statues){
            // 1.在拿到最新数据数据的同时计算它的frame
            NSMutableArray *newFrames = [NSMutableArray array];
            for (Status *s in statues) {
                StatusCellFrame *f = [[StatusCellFrame alloc] init];
                f.status = s;
                [newFrames addObject:f];
            }
            
            // 2.将newFrames整体插入到旧数据的后面
            [_statusFrames addObjectsFromArray:newFrames];
            
            // 3.刷新表格
            [self.tableView reloadData];
            
            // 4.让刷新控件停止刷新状态
            [temSelf.tableView.footer endRefreshing];
        } failure:^(NSError *error) {
            [temSelf.tableView.footer endRefreshing];
        }];

    }];
    [self.tableView.header beginRefreshing];
    
    

}

#pragma mark 展示最新数据的数目
- (void)showNewStatusCount:(int)count
{
    // 1.创建按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.enabled = NO;
    btn.adjustsImageWhenDisabled = NO;
    
    [btn setBackgroundImage:[UIImage resizedImage:@"timeline_new_status_background.png"] forState:UIControlStateNormal];
    CGFloat w = self.view.frame.size.width;
    CGFloat h = 35;
    btn.frame = CGRectMake(0, kStatusDockHeight, w, h);
    NSString *title = count?[NSString stringWithFormat:@"共有%d条新的数据", count]:@"没有新的数据";
    [btn setTitle:title forState:UIControlStateNormal];
    [self.navigationController.view insertSubview:btn belowSubview:self.navigationController.navigationBar];
    
    // 2.开始执行动画
    CGFloat duration = 0.5;
    
    [UIView animateWithDuration:duration animations:^{ // 下来
        btn.transform = CGAffineTransformMakeTranslation(0, h);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:duration delay:1.0 options:UIViewAnimationOptionCurveLinear animations:^{// 上去
            btn.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [btn removeFromSuperview];
        }];
    }];
}

#pragma mark 设置界面属性
- (void)buildUI
{
    // 1.设置标题
    self.title = @"我";
    
    // 2.左边的item
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"navigationbar_compose.png" highlightedIcon:@"navigationbar_compose_highlighted.png" target:self action:@selector(sendStatus)];
    
    // 3.右边的item
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithIcon:@"navigationbar_pop.png" highlightedIcon:@"navigationbar_pop_highlighted.png" target:self action:@selector(popMenu)];
    
    // 4.背景颜色

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kTableBorderWidth, 0);
      //  self.view.backgroundColor = kGlobalBg;
}

#pragma mark 发数据
- (void)sendStatus
{
    WriteStatusController* controller =[[WriteStatusController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark 弹出菜单
- (void)popMenu
{
    //MyLog(@"弹出菜单");
}

// 刷新数据：重新访问数据源，重新给数据源和代理发送所有需要的消息（重新调用数据源和代理所有需要的方法）
//    [tableView reloadData];

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _statusFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    StatusCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[StatusCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.cellFrame = _statusFrames[indexPath.row];
    
    return cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark - tableView delaget methods
#pragma mark 返回每一行cell的高度 每次tableView刷新数据的时候都会调用
// 而且会一次性算出所有cell的高度，比如有100条数据，一次性调用100次
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [_statusFrames[indexPath.row] cellHeight];
}

#pragma mark 监听cell的点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    StatusDetailController *detail = [[StatusDetailController alloc] init];
    StatusCellFrame *f = _statusFrames[indexPath.row];
    detail.status = f.status;
    [self.navigationController pushViewController:detail animated:YES];
}
@end