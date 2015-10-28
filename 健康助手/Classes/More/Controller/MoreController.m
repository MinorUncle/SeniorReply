//
//  MoreController.m
//  健康助手
//
//  Created by apple on 13-10-27.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#define kDocPath NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]
#define kCachePath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]
#define headerIconWide 40
#define cellHight 44
#import "AccountsController.h"
#import "CacheTool.h"
#import "SDImageCache.h"
#import "FooterView.h"
#import "AccountTool.h"
#import "ConnentTool.h"
#import "ClearDataController.h"
#import "OauthController.h"
#import "TotalCollectController.h"
#pragma mark 这个类只用在MoreController
//@interface UITableView()
//
//@end
//@implementation UITableView
//
//- (BOOL)touchesShouldCancelInContentView:(UIView *)view
//{
//    if ([view isKindOfClass:[UIButton class]])
//    {
//        return YES;
//    }
//    return [super touchesShouldCancelInContentView:view];
//}
//
//@end
@interface LogutBtn : UIButton

@end

@implementation LogutBtn
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    
    CGFloat x = 10;
    CGFloat y = 0;
    CGFloat width = contentRect.size.width - 2 * x;
    CGFloat height = contentRect.size.height;
    return CGRectMake(x, y, width, height);
}
@end

#import "MoreController.h"
#import "UIImage+MJ.h"
#import "GroupCell.h"

@interface MoreController ()
{
    NSArray *_data;
    NSIndexPath* _swichIndex;//缓存开关的位置
    FooterView* _footView; //缓存footview;
}
@end

@implementation MoreController
//kHideScroll

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1.搭建UI界面
    [self buildUI];
    
    // 2.读取plist文件的内容
    [self loadPlist];
    
    // 3.设置tableView属性
    [self buildTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectChange) name:kConnectChangeNotification object:nil];
}

#pragma mark 设置tableView属性
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
- (void)buildTableView
{
 
    // 1.设置背景
    // backgroundView的优先级 > backgroundColor
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    [self.tableView setShowsVerticalScrollIndicator:NO];
    [self.tableView setDelaysContentTouches:NO];//取消点击延迟
    //    self.tableView.backgroundView = nil;
//    // 0~1
  //  self.tableView.backgroundColor = kGlobalBg;
//    
//    // 2.设置tableView每组头部的高度
//    self.tableView.sectionHeaderHeight = 5;
//    self.tableView.sectionFooterHeight = 0;
    
    // 3.要在tableView底部添加一个按钮
    LogutBtn *logout = [LogutBtn buttonWithType:UIButtonTypeCustom];
    // 设置背景图片
    [logout setImage:[UIImage resizedImage:@"common_button_big_red.png"] forState:UIControlStateNormal];
    [logout setImage:[UIImage resizedImage:@"common_button_big_red_highlighted.png"] forState:UIControlStateHighlighted];
    // tableFooterView的宽度是不需要设置。默认就是整个tableView的宽度
    logout.bounds = CGRectMake(0, 0, 0, 44);
    
    // 4.设置按钮文字
    [logout setTitle:@"退出登录" forState:UIControlStateNormal];
    [logout addTarget:self action:@selector(layout) forControlEvents:UIControlEventTouchUpInside];
    
//    logout.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    self.tableView.tableFooterView = logout;
    
    // 增加底部额外的滚动区域
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == _data.count - 1) {
        return 10;
    }
    return 0;
}

#pragma mark 读取plist文件的内容
- (void)loadPlist
{
    // 1.获得路径
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"More" withExtension:@"plist"];
    
    // 2.读取数据
    _data = [NSArray arrayWithContentsOfURL:url];
    
}

#pragma mark 搭建UI界面

- (void)buildUI
{
    self.edgesForExtendedLayout = UIRectEdgeNone;

    [self.view setBackgroundColor:[UIColor blackColor]];
    // 1.设置标题
    self.title = @"更多";
    // 2.设置右上角按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStyleBordered target:nil action:nil];
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
};

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)    return  _data.count;
    else return  0;
}

#pragma mark 每当有一个新的cell进入屏幕视野范围内就会调用
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    // forIndexPath:indexPath 跟 storyboard配套使用的
    GroupCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[GroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        // 设置cell所在的tableView
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    
    // 1.取出这行对应的字典数据
    NSDictionary *dict = _data[indexPath.row];
    // 2.设置文字
    cell.textLabel.text = dict[@"name"];

    cell.cellType = kCellTypeArrow;
    if([cell.textLabel.text isEqualToString:@"当前缓存"])
    {
        _swichIndex = indexPath;
        cell.cellType = kCellTypeLabel;
         float t =  [CacheTool folderSizeAtPath:kDocPath];
        t += [CacheTool folderSizeAtPath:kCachePath];
        [cell.rightLabel setText:[NSString stringWithFormat:@"%0.2fMB",t]];
    }

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell.textLabel.text isEqualToString:@"帐号管理"]) {
        // 跳到账号管理控制器
        AccountsController *accounts = [[AccountsController alloc] init];
        [self.navigationController pushViewController:accounts animated:YES];
    }else if ([cell.textLabel.text isEqualToString:@"当前缓存"]) {
        // 跳到清除缓存管理控制器
        ClearDataController *accounts = [[ClearDataController alloc] init];
        [self.navigationController pushViewController:accounts animated:YES];
    }else if ([cell.textLabel.text isEqualToString:@"我的收藏"]) {
        TotalCollectController *accounts = [[TotalCollectController alloc] init];
        [self.navigationController pushViewController:accounts animated:YES];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect rect = [tableView rectForHeaderInSection:section];
    UIView* view = [[UIView alloc]init];
    view.frame = rect;
    if (section == 0) {
        [view setBackgroundColor:[UIColor clearColor]];

        
        UIImageView* imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"stars.jpeg"]];
        [imgView setUserInteractionEnabled:YES];
        rect.size.height -=10;
        [imgView setFrame:rect];
        [imgView.layer setShadowColor:[UIColor blackColor].CGColor];
    //    [imgView.layer setShadowRadius:5];
        [imgView.layer setShadowOffset:CGSizeMake(0.0, 5)];
        [imgView.layer setShadowOpacity:0.3];
        
        UIButton* btn = [[UIButton alloc]init];
        rect =CGRectMake((rect.size.width - headerIconWide)/2.0, (rect.size.height -headerIconWide)/2.0, headerIconWide, headerIconWide);
        [btn setFrame:rect];
        [btn.layer setCornerRadius:headerIconWide/2.0];
        [btn.layer setBorderWidth:2.0];
        [btn.layer setBorderColor:[UIColor grayColor].CGColor];
        [btn.layer setMasksToBounds:YES];
        [btn setImage:[UIImage imageNamed:@"headIcon.jpg"] forState:UIControlStateNormal];
        [imgView addSubview:btn];
        [btn addTarget:self action:@selector(headClick) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        UILabel* lab = [[UILabel alloc]init];
        lab.frame = CGRectMake(0, 0, 100, 15);
        rect.origin.y += headerIconWide;
        lab.center = (CGPoint){CGRectGetMidX(rect),CGRectGetMidY(rect)};
        [lab setTextAlignment:NSTextAlignmentCenter];
        [lab setText:[AccountTool sharedAccountTool].account.uid];
        [lab setTextColor:[UIColor whiteColor]];
        
        [imgView addSubview:lab];
        [view addSubview:imgView];
    }else{
        
        if(_footView == nil)
        {
            
            [view setBackgroundColor:[UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1]];
            NSArray* names = [[NSArray alloc]initWithObjects:@"离线模式",@"无图模式",@"普通模式",@"缓存模式",nil];
            NSArray* images = [[NSArray alloc]initWithObjects:@"offline.png",@"noPic.png",@"normal.png",@"wifi.png", nil];
            FooterView *footview = [[FooterView alloc]initWithBtnNames:names images:images];
            footview.delegate = self;
            [footview setFrame:view.bounds];
            _footView = footview;
            
            [footview setToNum:[ConnentTool sharedConnentTool].mainScanType];
        }
        
        [view addSubview:_footView];
        
    }
    return view;
}

-(void)headClick
{
    AccountsController *accounts = [[AccountsController alloc] init];
    [self.navigationController pushViewController:accounts animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section != 0) {
        return 80.0;
    }
    return 140.0;
}

-(void)connectChange
{
    [_footView setToNum:[ConnentTool sharedConnentTool].mainScanType];
}

//delegate;
-(void)dumpFromNum:(NSInteger)soc ToNum:(NSInteger)des
{
    if(soc == des)return;
    NSString* msg;
    switch (des) {
        case 0:
            [[ConnentTool sharedConnentTool] setMainScanType:kscanTypeWithoutNet];
            msg = @"进入离线模式";
            break;
        case 1:
            [[ConnentTool sharedConnentTool] setMainScanType:kscanTypeNoImage];
            msg = @"进入无图模式";
            break;
        case 2:
            [[ConnentTool sharedConnentTool] setMainScanType:kscanTypeNormal];
            msg = @"进入普通模式";
            break;
        case 3:
            [[ConnentTool sharedConnentTool] setMainScanType:kscanTypeCache];
            msg = @"进入缓存模式";
            break;
            
        default:
            break;
      }

    UIAlertView* alter = [[UIAlertView alloc]initWithTitle:msg message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];

    [alter show];
}
-(void)layout
{
    [[AccountTool sharedAccountTool] clean];
    OauthController* controller = [[OauthController alloc]init];
    //        [self.navigationController pushViewController:controller animated:YES];
    [self presentViewController:controller animated:YES completion:nil];

}
@end
