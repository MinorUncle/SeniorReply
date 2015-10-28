//
//  DetailMedicineController.m
//  健康助手
//
//  Created by 未成年大叔 on 15/7/23.
//  Copyright (c) 2015年 itcast. All rights reserved.
//
#define titleFont 10
#define ContentFont 12
#define ContentH 20
#define ContentPadding 20
#define titleW 80
#define HeaderH 40
#import "DetailStoreController.h"
#import "bHttpTool.h"
#import "Healthcfg.h"
#import "StoreTool.h"
#import "UIImage+MJ.h"
#import "Healthcfg.h"
#import "ConnentTool.h"


@interface DetailStoreController ()
{
    int serachID;
    UIWebView* webview;
    NSString* webString;
    UIImageView* _imageView;
    }

@end

@implementation DetailStoreController
-(DetailStoreController *)initWithID:(int)ID
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
    
    if(_store ==nil)
    {
    [StoreTool DetailWithParam:@{@"id":@(serachID)} success:^(Store* store)
     {
         _store = store;
         [self setFram];
     }failure:^(NSError* err)
     {
         MyLog(@"%@",err);
     }
     ];}else{
        [self setFram];
    }
    // Do any additional setup after loading the view.
}
-(void)click
{
    [StoreTool saveStore:_store];
    [self showNewStatusCount:YES];
}
-(void)addContent
{
    webview = [[UIWebView alloc]init];
    CGRect rect = self.view.bounds;
    rect.size.height -= kStatusHight;
    [webview setFrame:rect];
    
    [self.view addSubview:webview];
}
-(void)setFram
{
//    UILabel* _name;
//    UILabel* _tel;         //简介
//    UILabel* _telTip;
//    UIWebView* _type;
//    UILabel* _typeTip;     //病因
//    UILabel* _address;
//    UILabel* _addressTip;
//    UIWebView* _message;
//    UILabel* _messageTip;
//    UILabel* _number;         //相关药品
//    UILabel* _numberTip;
//    UILabel* _relatedStore;  //相关疾病
//    UILabel* _relatedStoreTip;
//    UIWebView* _detailText;
//    UILabel* _detailTextTip;
    
    
    NSString* imgname = [imageBaseURL stringByAppendingPathComponent:_store.image];
    if([ConnentTool sharedConnentTool].mainScanType == kscanTypeNoImage)imgname = nil;

    NSString* _name =[NSString stringWithFormat:@"<p style=\" text-align:center;\"><font color=\"#FF0000\">%@</font></p>",_store.name];
    NSString* _image =[NSString stringWithFormat:@"<div style=\"text-align: center;\"><img alt=\"\" src=%@ /></div>",imgname];
     NSString* _address = [NSString stringWithFormat:@"<p ><font color=\"#FF0000\">药店地址:  </font><font >%@</font></p>",_store.address];
    
       NSString* _createdate = [NSString stringWithFormat:@"<p ><font color=\"#FF0000\">创建时间:  </font><font >%@</font></p>",_store.createdate];
    
    NSString* _tel = [NSString stringWithFormat:@"<p ><font color=\"#FF0000\">联系电话:  </font><font >%@</font></p>",_store.tel];         //简介
    
    NSString* _charge =[NSString stringWithFormat:@"<p ><font color=\"#FF0000\" >企业负责人:      </font><font >%@</font></p>",_store.charge];  //
    NSString* _zipcode = [NSString stringWithFormat:@"<p ><font color=\"#FF0000\">邮编 :  </font><font >%@</font></p>",_store.zipcode];
    
    NSString* _leader = [NSString stringWithFormat:@"<p ><font color=\"#FF0000\">质量负责人 :  </font><font >%@</font></p>",_store.leader];
    

    NSString* _type =[NSString stringWithFormat:@"<p><font color= \"#ff0000\" >经营方式:  </font><font  >%@</font></p>",_store.type];
 
    NSString* _number =[NSString stringWithFormat:@"<p ><font color=\"#FF0000\">证号:  </font><font >%@</font></p>",_store.number];        //相关药品
  
    NSString* _legal =[NSString stringWithFormat:@"<p ><font color=\"#FF0000\" >法定代表人:      </font><font >%@</font></p>",_store.legal];  //法定代表人


//    NSString* _food =[NSString stringWithFormat:@"<p ><font color=\"#FF0000\" >食疗:      </font><font >%@</font></p>",_store.food];  //相关疾病
//    NSString* _foodText = [NSString stringWithFormat:@"<p ><font color=\"#FF0000\">食疗详情 :  </font><font >%@</font></p>",_store.foodText];
//    
//

    
    webString = [NSString stringWithFormat:@"<html><body style=\"padding:%dpx;overflow:hidden;\">%@%@%@%@%@%@%@%@%@%@%@</body></html>",ContentPadding,_name,_image,_address,_createdate,_tel,_zipcode,_type,_charge,_legal,_leader,_number];
    [webview loadHTMLString:webString baseURL:nil];
    
 
}
#pragma mark 展示最新数据的数目
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

@end
