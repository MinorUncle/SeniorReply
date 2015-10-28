//
//  CollectController.m
//  健康助手
//
//  Created by 未成年大叔 on 15/8/10.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "TotalCollectController.h"
#import "MedicineTool.h"
#import "MedicineCell.h"
#import "DetailMedicineController.h"
#import "FoodTool.h"
#import "FoodCell.h"
#import "DetailFoodController.h"
#import "DiseaseTool.h"
#import "DiseaseCell.h"
#import "DetailDiseaseController.h"
#import "CheckTool.h"
#import "CheckCell.h"
#import "DetailCheckController.h"
@interface TotalCollectController ()
{
    NSMutableArray* _medicineModel;
    NSMutableArray* _foodModel;
    NSMutableArray* _checkModel;
    NSMutableArray* _diseaseModel;
    
}

@end

@implementation TotalCollectController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    [self setTitle:@"收藏"];
   // [self getData];
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
    
    _medicineModel = [MedicineTool getMedicineArryWithCoding];
    _foodModel = [FoodTool getFoodArryWithCoding];
    _checkModel = [CheckTool getCheckArryWithCoding];
    _diseaseModel = [DiseaseTool getDiseaseArryWithCoding];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
                return _medicineModel==nil?0:_medicineModel.count;
            break;
        case 1:
                return _foodModel==nil?0:_foodModel.count;
            break;
        case 2:
                return _checkModel==nil?0:_checkModel.count;
            break;
        case 3:
                return _diseaseModel==nil?0:_diseaseModel.count;
            break;
            
        default:
            return 0;
            break;
    }
   
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
        {
            MedicineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListMedicine"];
            if (cell == nil) {
                cell = [[MedicineCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ListMedicine"];
            }
            
            cell.medicine = _medicineModel[indexPath.row];
            cell.row = (int)indexPath.row;
            return cell;

            break;
        }
        case 1:
        {
            FoodCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListFood"];
            if (cell == nil) {
                cell = [[FoodCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ListFood"];
            }
            
            cell.foodModel = _foodModel[indexPath.row];
            cell.row = indexPath.row;
            return cell;

            break;
        }
        case 2:
        {
            CheckCell *cell = [tableView dequeueReusableCellWithIdentifier:@"checkFood"];
            if (cell == nil) {
                cell = [[CheckCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"checkFood"];
            }
            
            cell.checkModel = _checkModel[indexPath.row];
            cell.row = indexPath.row;
            return cell;

            break;
        }
        case 3:
        {
            DiseaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"diseaseFood"];
            if (cell == nil) {
                cell = [[DiseaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"deseaseFood"];
            }
            
            cell.diseaseModel = _diseaseModel[indexPath.row];
            cell.row = indexPath.row;
            return cell;

            break;
        }
            
        default:
            return nil;
            break;
    }

    
    
    
    
    
    
}
-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            MedicineCell* cell =  (MedicineCell*)[tableView cellForRowAtIndexPath:indexPath];
            //    cell.topImageView.image = [UIImage imageNamed:@"cellHeader_highlighted.png"];
            
            DetailMedicineController* controller = [[DetailMedicineController alloc]init];
            controller.medicine = cell.medicine;
            [self.navigationController pushViewController:controller animated:YES];
            break;

        }
        case 1:
        {
            
            FoodCell* cell =  (FoodCell*)[tableView cellForRowAtIndexPath:indexPath];
            //    cell.topImageView.image = [UIImage imageNamed:@"cellHeader_highlighted.png"];
            
            DetailFoodController* controller = [[DetailFoodController alloc]init];
            controller.food = cell.foodModel;
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
        case 2:
        {
            CheckCell* cell =  (CheckCell*)[tableView cellForRowAtIndexPath:indexPath];
            //    cell.topImageView.image = [UIImage imageNamed:@"cellHeader_highlighted.png"];
            
            DetailCheckController* controller = [[DetailCheckController alloc]init];
            controller.check = cell.checkModel;
            [self.navigationController pushViewController:controller animated:YES];
            break;

        }
        case 3:
        {
            DiseaseCell* cell =  (DiseaseCell*)[tableView cellForRowAtIndexPath:indexPath];
            //    cell.topImageView.image = [UIImage imageNamed:@"cellHeader_highlighted.png"];
            
            DetailDiseaseController* controller = [[DetailDiseaseController alloc]init];
            controller.disease = cell.diseaseModel;
            [self.navigationController pushViewController:controller animated:YES];
            break;

        }
            
        default:
            return 0;
            break;
    }

    
    
   
    
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
        
        
        switch (indexPath.section) {
            case 0:
            {
                [MedicineTool deleteMedicine:_medicineModel[indexPath.row]];
                break;

            }
            case 1:
            {
                [FoodTool deleteFood:_foodModel[indexPath.row]];
                break;
            }
            case 2:
            {
                
                [CheckTool deleteCheck:_checkModel[indexPath.row]];
                break;
            }
            case 3:
            {
                [DiseaseTool deleteDisease:_diseaseModel[indexPath.row]];
                break;
            }
                
            default:
                return ;
                break;
        }

 
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"药品大全";
            break;
        case 1:
            return @"健康饮食";
            break;
        case 2:
            return @"疾病检查";
            break;
        case 3:
            return @"疾病查询";
            break;
            
        default:
            return nil;
            break;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
