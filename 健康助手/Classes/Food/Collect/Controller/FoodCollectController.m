//
//  MedicineCollectController.m
//  健康助手
//
//  Created by 未成年大叔 on 15/7/25.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "FoodCollectController.h"
#import "FoodTool.h"
#import "FoodCell.h"
#import "DetailFoodController.h"
@interface FoodCollectController ()
{
}
@end

@implementation FoodCollectController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setTitle:@"收藏"];
    [self getData];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getData];
    [self.tableView reloadData];
}
-(void)getData
{
    NSMutableArray* arry;
    arry = [FoodTool getFoodArryWithCoding];
    self.food = arry;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addRefreshViews{}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FoodCell* cell =  (FoodCell*)[tableView cellForRowAtIndexPath:indexPath];
//    cell.topImageView.image = [UIImage imageNamed:@"cellHeader_highlighted.png"];
    
    DetailFoodController* controller = [[DetailFoodController alloc]init];
    controller.food = cell.foodModel;
    [self.navigationController pushViewController:controller animated:YES];
    
    return indexPath;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [FoodTool deleteFood:self.food[indexPath.row]];
        [self.food removeObjectAtIndex:indexPath.row];

        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
