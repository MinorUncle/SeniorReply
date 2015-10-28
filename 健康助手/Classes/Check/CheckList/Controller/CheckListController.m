//
//  MedicineController.m
//  健康助手
//
//  Created by 未成年大叔 on 15/7/23.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#define serachH 40
#import "DetailCheckController.h"
#import "CheckListController.h"
#import "bHttpTool.h"
#import "Check.h"
#import "CheckTool.h"
#import "CheckCell.h"
#import "MJRefresh.h"
#import "UIImage+MJ.h"

@interface CheckListController ()

@end

@implementation CheckListController

- (void)viewDidLoad {
    [super viewDidLoad];

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
    [CheckTool SerachWithParam:@{@"keyword":self.keyWord,@"page":@(self.currentPage)} success:^(NSArray *check) {
        self.check = [NSMutableArray arrayWithArray:check];
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
    CheckCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListCheck"];
    if (cell == nil) {
        cell = [[CheckCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ListCheck"];
    }
    cell.isSerach = self.findState;

    cell.checkModel = self.check[indexPath.row];
    cell.row = indexPath.row;
    
    return cell;
}
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
