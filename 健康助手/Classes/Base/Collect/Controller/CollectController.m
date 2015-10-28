//
//  MedicineCollectController.m
//  健康助手
//
//  Created by 未成年大叔 on 15/7/25.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "CollectController.h"
#import "MedicineTool.h"
#import "MedicineCell.h"
#import "DetailMedicineController.h"
@interface CollectController ()
{
}
@end

@implementation CollectController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"收藏"];
    [self getData];
    // Do any additional setup after loading the view.
}


-(void)getData
{
    NSMutableArray* arry;
    arry = [MedicineTool getMedicineArryWithCoding];
    _medicines = arry;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _medicines==nil?0:_medicines.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MedicineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListMedicine"];
    if (cell == nil) {
        cell = [[MedicineCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ListMedicine"];
    }
    
    cell.medicine = _medicines[indexPath.row];
    cell.row = indexPath.row;
    
    return cell;
}
-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MedicineCell* cell =  (MedicineCell*)[tableView cellForRowAtIndexPath:indexPath];
//    cell.topImageView.image = [UIImage imageNamed:@"cellHeader_highlighted.png"];
    
    DetailMedicineController* controller = [[DetailMedicineController alloc]initWithID:cell.medicine.ID];
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
        [MedicineTool deleteMedicine:_medicines[indexPath.row]];
        [_medicines removeObjectAtIndex:indexPath.row];

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
