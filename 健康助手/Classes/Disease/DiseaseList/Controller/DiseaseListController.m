//
//  MedicineController.m
//  健康助手
//
//  Created by 未成年大叔 on 15/7/23.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#define serachH 40
#import "DetailDiseaseController.h"
#import "DiseaseListController.h"
#import "bHttpTool.h"
#import "Disease.h"
#import "DiseaseTool.h"
#import "DiseaseCell.h"
#import "MJRefresh.h"
#import "UIImage+MJ.h"

@interface DiseaseListController ()
{
    NSString* _keyWord;
}
@end

@implementation DiseaseListController

- (void)viewDidLoad {
    [super viewDidLoad];

    //放在函数中则会调用两次
    
    [self buildUI];
    
   

}


-(void)buildUI
{
    self.edgesForExtendedLayout = UIRectEdgeNone;


}

-(void)serach:(UITextField*)textField
{
    if ([textField.text isEqualToString:@""])return;
    
    self.keyWord = textField.text;
    self.findState = YES;
    self.currentPage = 1;
    [DiseaseTool SerachWithParam:@{@"keyword":self.keyWord,@"page":@(self.currentPage)} success:^(NSArray *disease) {
        self.disease = [NSMutableArray arrayWithArray:disease];
        [self.tableView reloadData];
    } failure:^(NSError *err) {
        MyLog(@"%@",err);
    }];
    
}


#pragma mark - Table view data source
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITextField* textView;
    if (section == 0) {
      
        CGRect rect = (CGRect){0,0,self.view.bounds.size.width,serachH};
        textView = [[UITextField alloc]init];
        [textView setFrame:rect];
        UIImage* img = [UIImage resizedImage:@"serach.png"];
        [textView setBackground:img];
        textView.delegate = self;
        
        
        UIImageView* leftImgView = [[UIImageView alloc]init];
        UIImage* leftImg = [UIImage imageNamed:@"search_icon.png"];
        leftImgView.image = leftImg;
        rect.origin = (CGPoint){5,(serachH - leftImg.size.height)/2.0};
        rect.size = leftImg.size;
        [leftImgView setFrame:rect];
        textView.leftView =leftImgView;
        textView.leftViewMode = UITextFieldViewModeAlways;
        textView.clearsOnBeginEditing = NO;
        [textView addTarget:self action:@selector(serach:) forControlEvents:UIControlEventEditingDidEnd];
        
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(serach:) name:UITextFieldTextDidEndEditingNotification object:textView];
        
    }
    return textView;
}

//- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
//{
//    if(!self.findState)
//    {
//        [DiseaseTool ListWithParam:@{(self.idKey == nil?@"id":self.idKey):@(self.ID),@"page":@(self.currentPage)} success:^(NSArray *disease) {
//            
//            [self.disease addObjectsFromArray:disease];
//            [self.tableView reloadData];
//            [refreshView endRefreshing];
//            [self showNewStatusCount:disease.count];
//            self.currentPage++;
//            
//        } failure:^(NSError *err) {
//            MyLog(@"err---%@",err);
//            [refreshView endRefreshing];
//            
//        }];
//    }else{
//        
//        [DiseaseTool SerachWithParam:@{@"keyword":self.keyWord,@"page":@(self.currentPage)} success:^(NSArray *disease) {
//            [self.disease addObjectsFromArray:disease];
//            [self.tableView reloadData];
//            
//            [refreshView endRefreshing];
//            self.currentPage++;
//        } failure:^(NSError *err) {
//            MyLog(@"%@",err);
//            [refreshView endRefreshing];
//        }];
//        
//    }
//}
//
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DiseaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListDisease"];
    if (cell == nil) {
        cell = [[DiseaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ListDisease"];
    }
    cell.isSerach = self.findState;
    cell.diseaseModel =self.disease[indexPath.row];
    cell.row = indexPath.row;
    
    return cell;
}

@end
