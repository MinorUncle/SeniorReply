//
//  MedicineController.m
//  健康助手
//
//  Created by 未成年大叔 on 15/7/23.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#define serachH 40
#import "DetailFoodController.h"
#import "FoodListController.h"
#import "bHttpTool.h"
#import "Food.h"
#import "FoodTool.h"
#import "FoodCell.h"
#import "MJRefresh.h"
#import "UIImage+MJ.h"
#import "CircleLoader.h"

@interface FoodListController ()

@end

@implementation FoodListController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"药物列表";

    [self buildUI];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    

}

-(void)buildUI
{
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kTableBorderWidth, 0);
      self.view.backgroundColor = kGlobalBg;
}


-(void)serach:(UITextField*)textField
{
    if ([textField.text isEqualToString:@""])return;
    
    self.keyWord = textField.text;
    self.findState = YES;
    self.currentPage = 1;
    [FoodTool SerachWithParam:@{@"keyword":self.keyWord,@"page":@(self.currentPage)} success:^(NSArray *foods) {
        self.food = [NSMutableArray arrayWithArray:foods];
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
    FoodCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListMedicine"];
    if (cell == nil) {
        cell = [[FoodCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ListMedicine"];
    }
    
    cell.isSerach = self.findState;

    cell.foodModel = self.food[indexPath.row];

    cell.row = indexPath.row;
    
    return cell;
}


@end
