//
//  MedicineCollectController.m
//  健康助手
//
//  Created by 未成年大叔 on 15/7/25.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "DiseaseCollectController.h"
#import "DiseaseTool.h"
#import "DiseaseCell.h"
#import "DetailDiseaseController.h"
#import "MJRefresh.h"
@interface DiseaseCollectController ()
{
}
@end

@implementation DiseaseCollectController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setTitle:@"收藏"];
    [self getData];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getData];
    [self.tableView reloadData];
}
-(void)addRefreshViews
{}
-(void)getData
{
    NSMutableArray* arry;
    arry = [DiseaseTool getDiseaseArryWithCoding];
    self.disease = arry;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [DiseaseTool deleteDisease:self.disease [indexPath.row]];

        [self.disease  removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        
    }
}
-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DiseaseCell* cell =  (DiseaseCell*)[tableView cellForRowAtIndexPath:indexPath];
    //    cell.topImageView.image = [UIImage imageNamed:@"cellHeader_highlighted.png"];
    
    DetailDiseaseController* controller = [[DetailDiseaseController alloc]init];
    controller.disease = cell.diseaseModel;
    [self.navigationController pushViewController:controller animated:YES];
    
    //    cell.topImageView.image = [UIImage imageNamed:@"cellHeader.png"];
    
    return indexPath;
    
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
