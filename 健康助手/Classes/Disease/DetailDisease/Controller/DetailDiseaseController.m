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
#import "DetailDiseaseController.h"
#import "bHttpTool.h"
#import "Healthcfg.h"
#import "DiseaseTool.h"
#import "UIImage+MJ.h"
#import "Healthcfg.h"
#import "ConnentTool.h"


@interface DetailDiseaseController ()
{
    int serachID;
    UIWebView* webview;
    NSString* webString;
    UIImageView* _imageView;
    }

@end

@implementation DetailDiseaseController
-(DetailDiseaseController *)initWithID:(int)ID
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
    
    if(_disease ==nil)
    {
    [DiseaseTool DetailWithParam:@{@"id":@(serachID)} success:^(Disease* food)
     {
         _disease = food;
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
    [DiseaseTool saveDisease:_disease];
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
//    UILabel* _summary;         //简介
//    UILabel* _summaryTip;
//    UIWebView* _causeText;
//    UILabel* _causeTextTip;     //病因
//    UILabel* _place;
//    UILabel* _placeTip;
//    UIWebView* _message;
//    UILabel* _messageTip;
//    UILabel* _drug;         //相关药品
//    UILabel* _drugTip;
//    UILabel* _relatedDisease;  //相关疾病
//    UILabel* _relatedDiseaseTip;
//    UIWebView* _detailText;
//    UILabel* _detailTextTip;
    
    
    NSString* imgname = [imageBaseURL stringByAppendingPathComponent:_disease.image];
    if([ConnentTool sharedConnentTool].mainScanType == kscanTypeNoImage)imgname = nil;

    NSString* _name =[NSString stringWithFormat:@"<p style=\" text-align:center;\"><font color=\"#FF0000\">%@</font></p>",_disease.name];
    NSString* _image =[NSString stringWithFormat:@"<div style=\"text-align: center;\"><img alt=\"\" src=%@ /></div>",imgname];
     NSString* _place = [NSString stringWithFormat:@"<p ><font color=\"#FF0000\">疾病部位:  </font><font >%@</font></p>",_disease.place];
    
       NSString* _department = [NSString stringWithFormat:@"<p ><font color=\"#FF0000\">科室:  </font><font >%@</font></p>",_disease.department];
    
    NSString* _summary = [NSString stringWithFormat:@"<p ><font color=\"#FF0000\">疾病简介:  </font><font >%@</font></p>",_disease.summary];         //简介
    
    NSString* _symptom =[NSString stringWithFormat:@"<p ><font color=\"#FF0000\" >相关症状:      </font><font >%@</font></p>",_disease.symptom];  //相关症状
    NSString* _symptomText = [NSString stringWithFormat:@"<p ><font color=\"#FF0000\">相关症状详情 :  </font><font >%@</font></p>",_disease.symptomText];
    
    NSString* _dis =[NSString stringWithFormat:@"<p ><font color=\"#FF0000\" >相关疾病:      </font><font >%@</font></p>",_disease.disease];  //相关疾病
    NSString* _diseaseText = [NSString stringWithFormat:@"<p ><font color=\"#FF0000\">相关疾病详情 :  </font><font >%@</font></p>",_disease.diseaseText];
    

    NSString* _causeText =[NSString stringWithFormat:@"<p><font color= \"#ff0000\" >病因:  </font><font  >%@</font></p>",_disease.causeText];
 
    NSString* _drug =[NSString stringWithFormat:@"<p ><font color=\"#FF0000\">相关药品:  </font><font >%@</font></p>",_disease.drug];        //相关药品
    NSString* _drugText = [NSString stringWithFormat:@"<p ><font color=\"#FF0000\">相关药品详情 :  </font><font >%@</font></p>",_disease.drugText];
    
    

    
  
    NSString* _check =[NSString stringWithFormat:@"<p ><font color=\"#FF0000\" >相关检查:      </font><font >%@</font></p>",_disease.check];  //相关检查
    NSString* _checkText = [NSString stringWithFormat:@"<p ><font color=\"#FF0000\">相关检查详情 :  </font><font >%@</font></p>",_disease.checkText];
    

    NSString* _food =[NSString stringWithFormat:@"<p ><font color=\"#FF0000\" >食疗:      </font><font >%@</font></p>",_disease.food];  //相关疾病
    NSString* _foodText = [NSString stringWithFormat:@"<p ><font color=\"#FF0000\">食疗详情 :  </font><font >%@</font></p>",_disease.foodText];
    


    
    webString = [NSString stringWithFormat:@"<html><body style=\"padding:%dpx;overflow:hidden;\">%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@</body></html>",ContentPadding,_name,_image,_place,_department,_summary,_symptom,_symptomText,_causeText,_dis,_diseaseText,_drug,_drugText,_check,_checkText,_food,_foodText];
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
