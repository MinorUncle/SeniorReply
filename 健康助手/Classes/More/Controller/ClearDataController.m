//
//  ClearDataController.m
//  健康助手
//
//  Created by 未成年大叔 on 15/8/9.
//  Copyright (c) 2015年 itcast. All rights reserved.
//
#define kCachePath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]
#import "ClearDataController.h"
#import "GroupCell.h"
#import "CacheTool.h"
#import "CircleLoader.h"

@interface ClearDataController ()
{
    UIButton* _totalBtn;
    UIButton* _imageBtn;
    UIButton* _dataBtn;
}
@end

@implementation ClearDataController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//-(void)reductionSwitch:(UISwitch*)swit{
//    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:_swichIndex];
//    cell.textLabel.text =[NSString stringWithFormat:@"%@%0.2fMB",@"当前缓存",0.0];
//    [swit setOn:NO animated:YES];
//}


-(void)btnClick:(UIButton*)btn
{
    
    btn.titleLabel.text = @"";
    [CircleLoader setOnView:btn withTitle:nil animated:YES];

     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        switch (btn.tag) {
            case 0 + 100:
                [CacheTool clearCacheWithPath:kCachePath fliter:nil];
                break;
            case 1 + 100:
                [CacheTool clearImageCache];
                break;
            case 2 + 100:
                [CacheTool clearFileWithName:SqliteData];

                break;
                
            default:
                break;
        }
        [self performSelectorOnMainThread:@selector(clearDone:) withObject:btn waitUntilDone:YES];
    });
}
//-(void)clearCache:(UIButton*)swit
//{
//
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//    });
//    dispatch_async(
//                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
//                   , ^{
//                       
//                               NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
//                               
//                               NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
//                               //                       NSLog(@"files :%d",[files count]);
//                               for (NSString *p in files)
//                               {
//                                   NSError *error;
//                                   NSString *path = [cachPath stringByAppendingPathComponent:p];
//                                   if ([[NSFileManager defaultManager] fileExistsAtPath:path])
//                                   {
//                                       [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
//                                   }
//                               }
//
//                           [self performSelectorOnMainThread:@selector(clearDone::) withObject:swit waitUntilDone:YES];
//                   });
//    
//    
//}

-(void)clearDone:(UIButton* )btn
{
   

    [CircleLoader hideFromView:btn animated:YES];
    switch (btn.tag) {
        case 0 + 100:
        {
            [self setTotleLable:btn];
            [self setTotleLable:_dataBtn];
            
            [self setTotleLable:_imageBtn];

            
            break;
        }
        case 1 + 100:
        {
            [self setImageLable:btn];
            [self setTotleLable:_totalBtn];
        
            break;
        }
        case 2 + 100:
        {
            [self setDataLable:btn];
            [self setTotleLable:_totalBtn];
            break;
        }
        default:
            break;
    }
    

}
//delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(void)setTotleLable:(UIButton*)btn
{
        float totalSize = [CacheTool folderSizeAtPath:kCachePath];
    [btn setTitle:[NSString stringWithFormat:@"%0.2fMB",totalSize] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)setImageLable:(UIButton* )btn
{
    float imageSize = [CacheTool imageCache];
    [btn setTitle:[NSString stringWithFormat:@"%0.2fMB",imageSize] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)setDataLable:(UIButton *)btn
{
    float dataSize = [CacheTool fileSizeAtPath:SqliteData];
    [btn setTitle:[NSString stringWithFormat:@"%0.2fMB",dataSize] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    

}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupCell* cell = [[GroupCell alloc]init];
    cell.cellType = kCellTypeButton;

    switch (indexPath.row) {
        case 0:
            [cell.textLabel setText:@"总缓存大小"];
            _totalBtn = cell.rightButton;
            [self setTotleLable:cell.rightButton];
            break;
        case 1:
            [cell.textLabel setText:@"图片缓存大小"];
            _imageBtn = cell.rightButton;
            [self setImageLable:cell.rightButton];
            break;
        case 2:
            [cell.textLabel setText:@"数据缓存大小"];
            _dataBtn = cell.rightButton;
            [self setDataLable:cell.rightButton];
            break;
        default:
            break;
    }
    [cell.rightButton setTag:indexPath.row + 100];

    return cell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
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
