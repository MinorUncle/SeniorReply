//
//  MedicineCollectController.m
//  健康助手
//
//  Created by 未成年大叔 on 15/7/25.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "MedicineCollectController.h"
#import "MedicineTool.h"
#import "MedicineCell.h"
#import "DetailMedicineController.h"
@interface MedicineCollectController ()
{
}
@end

@implementation MedicineCollectController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"收藏"];
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
    arry = [MedicineTool getMedicineArryWithCoding];
    self.medicine= arry;
}
-(void)addRefreshViews{}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MedicineCell* cell =  (MedicineCell*)[tableView cellForRowAtIndexPath:indexPath];
//    cell.topImageView.image = [UIImage imageNamed:@"cellHeader_highlighted.png"];
//
    DetailMedicineController* controller = [[DetailMedicineController alloc]init];
    controller.medicine = cell.medicine;
    [self.navigationController pushViewController:controller animated:YES];
    
//    cell.topImageView.image = [UIImage imageNamed:@"cellHeader.png"];
    
       return indexPath;
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"1      %@",self.medicine);

        [MedicineTool deleteMedicine:self.medicine[indexPath.row]];
        NSLog(@"2      %@",self.medicine);

      //  [self.medicine removeObjectAtIndex:indexPath.row];

        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        
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
