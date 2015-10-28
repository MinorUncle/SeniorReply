//
//  StatusDetailController.m
//  健康助手
//
//  Created by apple on 13-11-5.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "StatusDetailController.h"
#import "StatusDetailCell.h"
#import "StatusDetailCellFrame.h"
#import "DetailHeader.h"
#import "StatusTool.h"
#import "Status.h"
#import "CommentCellFrame.h"
#import "RepostCellFrame.h"
#import "Comment.h"
#import "RepostCell.h"
#import "CommentCell.h"
#import "MJRefresh.h"

@interface StatusDetailController () <DetailHeaderDelegate>
{
    StatusDetailCellFrame *_detailFrame;
    NSMutableArray *_repostFrames; // 转发frame数据
    NSMutableArray *_commentFrames; // 评论frame数据
    
    DetailHeader *_detailHeader;
    
    MJRefreshHeader *_header;
    MJRefreshFooter *_footer;
    
    BOOL _commentLastPage; // 评论数据是否为最后一页
    BOOL _repostLastPage; // 转发数据是否为最后一页
}
@end

@implementation StatusDetailController
//kHideScroll

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.title = @"数据正文";
    self.view.backgroundColor = kGlobalBg;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kTableBorderWidth, 0);
    
    _detailFrame = [[StatusDetailCellFrame alloc] init];
    _detailFrame.status = _status;
    
    _repostFrames = [NSMutableArray array];
    _commentFrames = [NSMutableArray array];
    
    // 添加上拉加载更多
    __weak StatusDetailController* temSelf = self;
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        
            // 上拉加载更多
            if (_detailHeader.currentBtnType == kDetailHeaderBtnTypeRepost) {
                [temSelf loadMoreRepost]; // 加载更多的转发
            } else { // 加载更多的评论
                [temSelf loadMoreComment];
            }

    }];
    _footer = self.tableView.footer;
    _footer.hidden = YES;

    
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [temSelf loadNewStatus];

    }];
    

    _header = self.tableView.header;
    
    _detailHeader = [DetailHeader header];
    _detailHeader.delegate = self;
    
    // 默认点击了“评论”
    [self detailHeader:nil btnClick:kDetailHeaderBtnTypeComment];
}

#pragma mark 获得当前需要使用的数组
- (NSMutableArray *)currentFrames
{
    if (_detailHeader.currentBtnType == kDetailHeaderBtnTypeComment) {
        return _commentFrames;
    } else {
        return _repostFrames;
    }
}

#pragma mark - 数据源\代理方法
#pragma mark 1.有多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // 1.判断上拉加载更多控件要不要显示
    if (_detailHeader.currentBtnType == kDetailHeaderBtnTypeComment) {
        _footer.hidden = _commentLastPage;
    } else {
        _footer.hidden = _repostLastPage;
    }

    return 2;
}

#pragma mark 2.第section组头部控件有多高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) return 0;
    return 50;
}

#pragma mark 3.第section组有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (section == 0) {
//        return 1;
//    } else {
    return section ? [[self currentFrames] count]: 1;
//    } if (_detailHeader.currentBtnType == kDetailHeaderBtnTypeRepost) {
//        return _repostFrames.count;
//    } else {
//        return _commentFrames.count;
//    }
}

#pragma mark 4.indexPath这行的cell有多高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return _detailFrame.cellHeight;
    } else {
        return [self.currentFrames[indexPath.row] cellHeight];
    }
    
//    if (indexPath.section == 0) {
//        return _detailFrame.cellHeight;
//    } else if (_detailHeader.currentBtnType == kDetailHeaderBtnTypeRepost) {
//        return [_repostFrames[indexPath.row] cellHeight];
//    } else {
//        return [_commentFrames[indexPath.row] cellHeight];
//    }
}

#pragma mark 5.indexPath这行的cell长什么样子
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) { // 数据详情cell
        static NSString *CellIdentifier = @"DetailCell";
        StatusDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[StatusDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

        }
        
        cell.cellFrame = _detailFrame;
        
        return cell;
    } else if (_detailHeader.currentBtnType == kDetailHeaderBtnTypeRepost) {
        // 转发cell
        static NSString *CellIdentifier = @"RepostCell";
        RepostCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[RepostCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.myTableView = tableView;
        }
        
        cell.indexPath = indexPath;
        cell.cellFrame = _repostFrames[indexPath.row];
        
        return cell;
    } else {
        // 评论cell
        static NSString *CellIdentifier = @"CommentCell";
        CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.myTableView = tableView;
        }
        
        cell.indexPath = indexPath;
        cell.cellFrame = _commentFrames[indexPath.row];
        
        return cell;
    }
}

#pragma mark 判断第indexPath行的cell能不能达到选中状态
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section;
}

#pragma mark 6.第section组头部显示什么控件
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) return nil;
    _detailHeader.status = _status;
  

    return _detailHeader;
}

#pragma mark - DetailHeader的代理方法
- (void)detailHeader:(DetailHeader *)header btnClick:(DetailHeaderBtnType)index
{
    // 1.先刷新表格(马上显示对应的旧数据)
    [self.tableView reloadData];
    
    if (index == kDetailHeaderBtnTypeRepost) { // 点击了转发
        

        [self loadNewRepost];
    } else if (index == kDetailHeaderBtnTypeComment) { // 点击了评论
        
        
        [self loadNewComment];
    }
}


#pragma mark 解析模型数据为frame数据
- (NSMutableArray *)framesWithModels:(NSArray *)models class:(Class)class
{
    NSMutableArray *newFrames = [NSMutableArray array];
    for (BaseText *s in models) {
        BaseTextCellFrame *f = [[class alloc] init];
        f.baseText = s;
        [newFrames addObject:f];
    }
    return newFrames;
}

#pragma mark 加载最新的数据数据
- (void)loadNewStatus
{
    [StatusTool statusWithId:_status.ID success:^(Status *status) {
        _status = status;
        _detailFrame.status = status;
        
        // 刷新表格
        [self.tableView reloadData];
        
        [_header endRefreshing];
    } failure:^(NSError *r){
        [_header endRefreshing];
    }];
}

#pragma mark 加载最新的转发数据
- (void)loadNewRepost
{
    long long firstId = _repostFrames.count?[[_repostFrames[0] baseText] ID]:0;
    
    [StatusTool repostsWithSinceId:firstId maxId:0 statusId:_status.ID success:^(NSArray *reposts, int totoalNumber, long long nextCursor) {
        // 1.解析最新的转发frame数据
        NSMutableArray *newFrames = [self framesWithModels:reposts class:[RepostCellFrame class]];
//        for (BaseText *s in reposts) {
//            BaseTextCellFrame *f = [[RepostCellFrame alloc] init];
//            f.baseText = s;
//            [newFrames addObject:f];
//        }
        _status.repostsCount = totoalNumber;
        
        // 2.添加数据
        [_repostFrames insertObjects:newFrames atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newFrames.count)]];
        
        _repostLastPage = nextCursor == 0;
        
        // 3.刷新表格
        [self.tableView reloadData];
        
    } failure:nil];
}

#pragma mark 加载最新的评论数据
- (void)loadNewComment
{
    long long firstId = _commentFrames.count?[[_commentFrames[0] baseText] ID]:0;
    
    [StatusTool commentsWithSinceId:firstId maxId:0 statusId:_status.ID success:^(NSArray *comments, int totalNumber, long long nextCursor) {
        // 1.解析最新的评论frame数据
        NSMutableArray *newFrames = [self framesWithModels:comments class:[CommentCellFrame class]];
//        for (BaseText *c in comments) {
//            BaseTextCellFrame *f = [[CommentCellFrame alloc] init];
//            f.baseText = c;
//            [newFrames addObject:f];
//        }
        
        _status.commentsCount = totalNumber;
        
        // 2.添加数据到旧数据的前面
        [_commentFrames insertObjects:newFrames atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newFrames.count)]];
        
        _commentLastPage = nextCursor == 0;
        
        // 3.刷新表格
        [self.tableView reloadData];
    } failure:nil];
}

#pragma mark 加载更多的转发数据
- (void)loadMoreRepost
{
    long long lastId = [[[_repostFrames lastObject] baseText] ID] - 1;
    
    [StatusTool repostsWithSinceId:0 maxId:lastId statusId:_status.ID success:^(NSArray *reposts, int totalNumber, long long nextCursor) {
        // 1.解析最新的评论frame数据
        NSMutableArray *newFrames = [self framesWithModels:reposts class:[RepostCellFrame class]];
//        for (BaseText *s in reposts) {
//            BaseTextCellFrame *f = [[RepostCellFrame alloc] init];
//            f.baseText = s;
//            [newFrames addObject:f];
//        }
        
        _status.repostsCount = totalNumber;
        
        // 2.添加数据到旧数据的后面
        [_repostFrames addObjectsFromArray:newFrames];
        
        _repostLastPage = nextCursor == 0;
        
        // 3.刷新表格
        [self.tableView reloadData];
        
        [_footer endRefreshing];
    } failure:^(NSError *error) {
        [_footer endRefreshing];
    }];
}

#pragma mark 加载更多的评论数据
- (void)loadMoreComment
{
    long long lastId = [[[_commentFrames lastObject] baseText] ID] - 1;
    
    [StatusTool commentsWithSinceId:0 maxId:lastId statusId:_status.ID success:^(NSArray *comments, int totalNumber, long long nextCursor) {
        // 1.解析最新的评论frame数据
        NSMutableArray *newFrames = [self framesWithModels:comments class:[CommentCellFrame class]];
//        for (BaseText *c in comments) {
//            BaseTextCellFrame *f = [[CommentCellFrame alloc] init];
//            f.baseText = c;
//            [newFrames addObject:f];
//        }
        
        _status.commentsCount = totalNumber;
        
        // 2.添加数据到旧数据的后面
        [_commentFrames addObjectsFromArray:newFrames];
        _commentLastPage = nextCursor == 0;
        
        // 3.刷新表格
        [self.tableView reloadData];
        
        [_footer endRefreshing];
    } failure:^(NSError *error) {
        [_footer endRefreshing];
    }];
}
@end