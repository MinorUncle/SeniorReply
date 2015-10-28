//
//  FriednshipController.m
//  健康助手
//
//  Created by apple on 13-10-27.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "FriednshipController.h"
#import "GroupCell.h"
#import "FriendshipTool.h"
#import "AccountTool.h"
#import "User.h"
#import "HttpTool.h"

@interface FriednshipController ()

@end

@implementation FriednshipController
//kHideScroll

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _data = [NSMutableArray array];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    User *u = _data[indexPath.row];
    
    // 头像
    [HttpTool downloadImage:u.profileImageUrl place:[UIImage imageNamed:@"Icon.png"] imageView:cell.imageView];
    
    // 昵称
    cell.textLabel.text = u.screenName;
    
    return cell;
}

@end