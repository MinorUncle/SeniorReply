//
//  DetailMedicineController.m
//  健康助手
//
//  Created by 未成年大叔 on 15/7/23.
//  Copyright (c) 2015年 itcast. All rights reserved.
//
#define titleFont [UIFont systemFontOfSize:24]
#define ContentFont [UIFont systemFontOfSize:12]
#define ContentH 20
#define ContentPadding 20
#define titleW 80
#define HeaderH 40
#import "DetailMedicineController.h"
#import "bHttpTool.h"
#import "Healthcfg.h"
#import "MedicineTool.h"
#import "UIImage+MJ.h"
#import "ConnentTool.h"

@interface DetailMedicineController ()
{
    NSInteger serachID;
    UIWebView* _webView;
}

@end

@implementation DetailMedicineController
-(DetailMedicineController *)initWithID:(NSInteger)ID
{
    if (self = [super init]) {
        serachID = ID;    }
    return self;
}
-(void)loadView
{
    [super loadView];
    UIScrollView* s = [[UIScrollView alloc] init];
    [s setFrame:self.view.frame];
    [s setBackgroundColor:[UIColor whiteColor]];

    self.view = s;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIBarButtonItem* item = [[UIBarButtonItem alloc] init];
    item.target = self;
    item.action = @selector(click);
    
     self.navigationItem.rightBarButtonItem = item;
    [self.navigationItem.rightBarButtonItem setTitle:@"收藏"];
     [self addContent];
    if (_medicine ==nil) {
    [MedicineTool DetailWithParam:@{@"id":@(serachID)} success:^(Medicine* medicin)
     {
         _medicine = medicin;
         [self setFram];
     }failure:^(NSError* err)
     {
         MyLog(@"%@",err);
     }
     ];
    }else {
        [self setFram];
    }
    // Do any additional setup after loading the view.
}
-(void)click
{
    [MedicineTool saveMedicine:_medicine];
    [self showNewStatusCount:YES];
}
#pragma mark 展示
- (void)showNewStatusCount:(BOOL)count
{
    // 1.创建按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.enabled = NO;
    btn.adjustsImageWhenDisabled = NO;
    
    [btn setBackgroundImage:[UIImage resizedImage:@"timeline_new_status_background.png"] forState:UIControlStateNormal];
    CGFloat w = self.view.frame.size.width;
    CGFloat h = 35;
    btn.frame = CGRectMake(0, kStatusDockHeight, w, h);
    NSString *title = count?@"收藏成功":@"收藏失败";
    [btn setTitle:title forState:UIControlStateNormal];
    [self.navigationController.view insertSubview:btn belowSubview:self.navigationController.navigationBar];
    
    // 2.开始执行动画
    CGFloat duration = 0.5;
    
    [UIView animateWithDuration:duration animations:^{ // 下来
        btn.transform = CGAffineTransformMakeTranslation(0, h);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:duration delay:1.0 options:UIViewAnimationOptionCurveLinear animations:^{// 上去
            btn.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [btn removeFromSuperview];
        }];
    }];
}
-(void)addContent
{
    _webView = [[UIWebView alloc]init];
    CGRect rect = self.view.bounds;
    rect.size.height -= kStatusHight;
    [_webView setFrame:rect];
    
    [self.view addSubview:_webView];
    
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setFram
{
    
    
    NSString* imgname = [imageBaseURL stringByAppendingPathComponent:_medicine.image];
    
    if([ConnentTool sharedConnentTool].mainScanType == kscanTypeNoImage)imgname = nil;

    NSString* name =[NSString stringWithFormat:@"<p style=\" text-align:center;\"><font color=\"#FF0000\">%@</font></p>",_medicine.name];
    NSString* image =[NSString stringWithFormat:@"<div style=\"text-align: center;\"><img alt=\"\" src=%@ /></div>",imgname];
    
    NSString* type = [NSString stringWithFormat:@"<p ><font color=\"#FF0000\">药品类型:  </font><font >%@</font></p>",_medicine.type];         //
    
    NSString* categroyNmae = [NSString stringWithFormat:@"<p ><font color=\"#FF0000\">药品分类:  </font><font >%@</font></p>",_medicine.categroyNmae];         //
    
    NSString* ANumber = [NSString stringWithFormat:@"<p ><font color=\"#FF0000\">编号:  </font><font >%@</font></p>",_medicine.ANumber];         //
    
    NSString* tag = [NSString stringWithFormat:@"<p ><font color=\"#FF0000\">药品标签Tag:  </font><font >%@</font></p>",_medicine.tag];         //
    
    

    NSString* message = [NSString stringWithFormat:@"<p ><font color=\"#FF0000\">药品详细内容:    </font><font >%@</font></p>",_medicine.detailMessage];
    
    
    
    NSString* webString = [NSString stringWithFormat:@"<html><body style=\"padding:%dpx;overflow:hidden;\">%@%@%@%@%@%@%@</body></html>",ContentPadding,name,image,type,categroyNmae,ANumber,tag,message];
    [_webView loadHTMLString:webString baseURL:nil];
    
   
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
