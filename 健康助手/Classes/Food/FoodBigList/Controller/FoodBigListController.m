//
//  MedicineController.m
//  健康助手
//
//  Created by 未成年大叔 on 15/7/23.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#define serachH 40
#import "DetailFoodController.h"
#import "FoodBigListController.h"
#import "bHttpTool.h"
#import "Food.h"
#import "FoodTool.h"
#import "FoodBigListCell.h"
#import "MJRefresh.h"
#import "UIImage+MJ.h"
#import "CircleLoader.h"
#import "UMSocialSnsService.h"
#import "UMSocialSnsPlatformManager.h"
#import "FoodTool.h"
#import "bHttpTool.h"

@interface FoodBigListController ()<UMSocialUIDelegate>

@end

@implementation FoodBigListController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"药物列表";

    [self buildUI];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UINib* nib = [UINib nibWithNibName:@"FoodBigListCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"FoodBigListCell"];

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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FoodBigListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FoodBigListCell"];
    if (cell == nil) {
        cell = [[FoodBigListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FoodBigListCell"];
    }
    

    cell.isSearch = self.findState;
    cell.foodModel = self.food[indexPath.row];
    cell.listDelegate = self;
    
    return cell;
}



#pragma mark listCell Delegate

-(void)likeClick
{
}
-(void)shareClick:(FoodBigListCell*)cell
{
    
    [FoodTool DetailWithParam:@{@"id":@(cell.foodModel.ID)} success:^(Food* food){
        NSString* text = food.detailMessage;
 
        UIImage* image = cell.foodImgView.image;
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:@"507fcab25270157b37000010"
                                          shareText:text
                                         shareImage:image
                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToDouban,UMShareToRenren, nil]
                                           delegate:self];
         }failure:^(NSError* err)
         {
             MyLog(@"%@",err);
         }
     ];
    
  
    
}

@end
