//
//  ClassifyController.m
//  健康助手
//
//  Created by 未成年大叔 on 15/7/24.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "FoodClassifyController.h"
#import "FoodClassifyDetailController.h"
#import "classifyBox.h"
#import "FoodTool.h"
#import "FoodListController.h"
#import "Food.h"
#import "FDSlideBar.h"
@interface FoodClassifyController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
{
    UINavigationController* navcontroller;
}
@property (strong, nonatomic) FDSlideBar *slideBar;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation FoodClassifyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分类";
    self.edgesForExtendedLayout = UIRectEdgeNone;
     [self.view setBackgroundColor:[UIColor whiteColor]];
    [self getData:_ID];
    
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    

    // Do any additional setup after loading the view.
}
-(void)getData:(int)flg
{
    [FoodTool TypeWithParam:@{@"id":@(flg)} success:^(NSArray *food) {
        _foodClass = food;
        
        [self setupSlideBar];
        [self setupTableView];
    } failure:^(NSError *err) {
        MyLog(@"%@",err);
        
   
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Private

// Set up a slideBar and add it into view
- (void)setupSlideBar {
    FDSlideBar *sliderBar = [[FDSlideBar alloc] init];
    sliderBar.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1.0];
    
    // Init the titles of all the item
    NSMutableArray* mstr = [[NSMutableArray alloc]initWithCapacity:_foodClass.count];
    for (Food* i in _foodClass) {
        NSString* str = i.name;
        [mstr addObject:str];
    }
    sliderBar.itemsTitle = mstr;
    
    // Set some style to the slideBar
    sliderBar.itemColor = [UIColor blackColor];
    sliderBar.itemSelectedColor = [UIColor orangeColor];
    sliderBar.sliderColor = [UIColor orangeColor];
    
    // Add the callback with the action that any item be selected
    [sliderBar slideBarItemSelectedCallback:^(NSUInteger idx) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }];
    [self.view addSubview:sliderBar];
    _slideBar = sliderBar;
}

// Set up a tableView to show the content
- (void)setupTableView {
    // The frame of tableView, be care the width and height property
    CGRect frame = CGRectMake(0, 0, CGRectGetMaxY(self.view.frame) - CGRectGetMaxY(self.slideBar.frame) , CGRectGetWidth(self.view.frame));
    self.tableView = [[UITableView alloc] initWithFrame:frame];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.tableView];
    
    // Register the custom cell
    
    
    // Set the tableView center in the bottom of view. so after rotating, it shows rightly
    self.tableView.center = CGPointMake(CGRectGetWidth(self.view.frame) * 0.5, CGRectGetHeight(self.view.frame) * 0.5 + CGRectGetMaxY(self.slideBar.frame) * 0.5);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // Rotate the tableView 90 angle anticlockwise
    self.tableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.pagingEnabled = YES;
    self.tableView.allowsSelection = YES;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.slideBar.itemsTitle count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ContentCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ContentCell"];
    }
    
    [cell setUserInteractionEnabled:YES];

    [cell setBackgroundColor:[UIColor redColor]];
    FoodClassifyDetailController * controller;

    controller = [[FoodClassifyDetailController alloc]init];
    controller.ID = ((Food*)_foodClass[indexPath.row]).ID;
    navcontroller = [[UINavigationController alloc]initWithRootViewController:controller];

    [cell.contentView addSubview:navcontroller.view];
    // Rotate the cell's content 90 angle clockwise to show them rightly
    cell.contentView.transform = CGAffineTransformMakeRotation(M_PI_2);
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Height retrun the width of screen
    return CGRectGetWidth(self.view.frame);
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:scrollView.contentOffset];
    
    // Select the relating item when scroll the tableView by paging.
    [self.slideBar selectSlideBarItemAtIndex:indexPath.row];
}

@end
