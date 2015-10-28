//
//  HotController.m
//  健康助手
//
//  Created by 未成年大叔 on 15/8/10.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "HotController.h"
#import "HotDetailHeader.h"
#import "tableScrollView.h"
#import "MedicineTool.h"
#import "FoodTool.h"
#import "CheckTool.h"
#import "DiseaseTool.h"
#import "Medicine.h"
#import "Food.h"
#import "Disease.h"
#import "Check.h"
#import "BaseList.h"
#import "BannerView.h"
#define TOP_Y 64
#define BUTTON_Y 170
#define DETAIL_H 70
typedef void (^dataSuccess)(NSMutableArray* data);
@interface HotController ()<HotDetailHeaderDelegate,tableScrollViewDelegate>
{
    
    BOOL isTopDirection;
    NSMutableArray* _currentArry;
}
@property(nonatomic,strong)NSMutableArray* disease;
@property(nonatomic,strong)NSMutableArray* check;
@property(nonatomic,strong)NSMutableArray* food;
@property(nonatomic,strong)NSMutableArray* medicine;


@property (nonatomic,strong)tableScrollView* tableView;
@property (nonatomic,strong)HotDetailHeader* hotDetail;
@property (nonatomic,strong)BannerView* banner;
@property (nonatomic,strong)UIImageView* bannerCover;

@end

@implementation HotController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"热门";
   [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self buildBanner];
    [self buildHotDedtailHeder];
    [self bulidTable];
    
    [self HotDetailHeader:_hotDetail btnClick:kHotDetailHeaderBtnTypeMedic];//首先点击药品大全
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)freshDataWithType:(HotDetailHeaderBtnType)type success:(dataSuccess) success
{
    switch (type) {
        case kHotDetailHeaderBtnTypeCheck:
        {
            if(self.check == nil){
                [CheckTool TypeWithParam:@{@"id":@(0)} success:^(NSArray *mesicines) {
                    NSMutableArray* arry = [NSMutableArray arrayWithArray:mesicines];
                    self.check = [[NSMutableArray alloc]init];
                   
                    for (Check* i in arry) {
                        NSDictionary* dic = @{@"name":i.name,@"ID":@(i.ID)};
                        [self.check addObject:dic];
                    }
                    
                    _currentArry = self.check;
                    success(_currentArry);

                } failure:^(NSError *err) {
                    MyLog(@"%@",err);
                    
                }];
            }
            else{
                _currentArry = self.check;
                success(_currentArry);
            }
            break;
        }
        case kHotDetailHeaderBtnTypeDisease:
        {
            if(self.disease == nil){
                [DiseaseTool TypeWithParam:@{@"id":@(0)} success:^(NSArray *disease) {
                    NSMutableArray* arry = [NSMutableArray arrayWithArray:disease];
                    self.disease = [[NSMutableArray alloc]init];
                    
                    for (Disease* i in arry) {
                        NSDictionary* dic = @{@"name":i.name,@"ID":@(i.ID)};
                        [self.disease addObject:dic];
                    }
                    
                    _currentArry = self.disease;
                    success(_currentArry);

                } failure:^(NSError *err) {
                    MyLog(@"%@",err);
                }];
            }else{
                _currentArry = self.disease;
                success(_currentArry);
            }
            
            break;
        }
        case kHotDetailHeaderBtnTypeFood:///food有两层
        {
            if(self.food == nil)
            {
                [FoodTool TypeWithParam:@{@"id":@(0)} success:^(NSArray *mesicines) {
                    NSMutableArray* arry = [NSMutableArray arrayWithArray:mesicines];
                    NSMutableArray* temArry = [[NSMutableArray alloc]init];
                    self.food = [[NSMutableArray alloc]init];
                    for (Food* i in arry) {
                        NSDictionary* dic = @{@"name":i.name,@"ID":@(i.ID)};
                        [temArry addObject:dic];
                    }
                    
                    
                    
                   __block int endFlg=0 ; //标志是否下载到最后
                    for (NSDictionary* i in temArry) {
                        NSInteger ID = [((NSNumber*)i[@"ID"]) integerValue];
                        [FoodTool TypeWithParam:@{@"id":@(ID)} success:^(NSArray *mesicines) {
                            NSMutableArray* arry = [NSMutableArray arrayWithArray:mesicines];
                            for (Food* i in arry) {
                                NSDictionary* dic = @{@"name":i.name,@"ID":@(i.ID)};
                                [self.food addObject:dic];
                            }
                            if(endFlg++ == temArry.count-1)
                            {
                                _currentArry = self.food;
                                success(_currentArry);
                            }
                        }failure:^(NSError* err){
                        }];
                    }
                    
                    
                
                } failure:^(NSError *err) {
                    MyLog(@"%@",err);
                }];
                
            }else{
                _currentArry = self.food;
                success(_currentArry);
            }
            break;
        }
            break;
        case kHotDetailHeaderBtnTypeMedic:
        {
            if(self.medicine == nil)
            {
                [MedicineTool TypeWithParam:@{@"id":@(0)} success:^(NSArray *mesicines) {
                    NSMutableArray* arry = [NSMutableArray arrayWithArray:mesicines];
                    self.medicine = [[NSMutableArray alloc]init];
                    
                    for (Medicine* i in arry) {
                        NSDictionary* dic = @{@"name":i.name,@"ID":@(i.ID)};
                        [self.medicine addObject:dic];
                    }
                    
                    _currentArry = self.medicine;
                    success(_currentArry);
                } failure:^(NSError *err) {
                    MyLog(@"%@",err);
                }];

            }else{
                _currentArry = self.medicine;
                success(_currentArry);
            }
            break;
        }
        default:
            break;
    }
}
-(void)buildBanner
{
    CGRect rect = CGRectMake(0, kStatusHight, self.view.bounds.size.width, BUTTON_Y - TOP_Y);
    _banner = [[BannerView alloc]initWithFrame:rect];
    
    
    [self.view addSubview:_banner];
    
    _bannerCover = [[UIImageView alloc]initWithFrame:_banner.bounds];
    [_bannerCover setBackgroundColor:[UIColor blackColor]];
    [_bannerCover setAlpha:0.0];
    [self.view addSubview:_bannerCover];
     
}
-(void)buildHotDedtailHeder
{
    _hotDetail = [HotDetailHeader header];
    CGRect rect = CGRectMake(0.0,BUTTON_Y, self.view.bounds.size.width, DETAIL_H);
    _hotDetail.frame = rect;
    //hotDetail中 slidebar移动的回调函数
    [_hotDetail slideBarItemSelectedCallback:^(NSUInteger idx) {
        [self.tableView moveToIndex:idx];
    }];
    _hotDetail.delegate = self;
    [self.view addSubview:_hotDetail];

}

-(void)bulidTable
{
    CGRect rect = _hotDetail.frame;
    rect.origin.y = CGRectGetMaxY(rect);
    rect.size.height = self.view.bounds.size.height - rect.origin.y -2 ;
    rect.size.width = self.view.bounds.size.width;
    // The frame of tableView, be care the width and height property
//    CGRect frame = CGRectMake(0, bannerH, CGRectGetMaxY(self.view.frame) - CGRectGetMaxY(self.slideBar.frame) , CGRectGetWidth(self.view.frame));
    self.tableView = [[tableScrollView alloc] initWithFrame:rect];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.tableView];
    
    self.tableView.tableScrollViewdelegate = self;
    
}



//-(void)dragView:(UIView *)view toViewPoint:(CGPoint)point
//{
//    CGPoint p = _tableView.center;
//    p.x += point.x;
//    p.y += point.y;
//    
//    _tableView.center = p;
//    
//}
//detailDelegate
/**
 *  结束拖动,根据位置和拖动方向让控件归位
 *
 *  @param view  拖动的控件

 */
-(void)endPanWithView:(UIView *)view
{
    CGRect rect1 = _hotDetail.frame;
    CGRect rect2 = _tableView.frame;
    CGRect rect3 = _banner.frame;

    if (isTopDirection) {
        rect1.origin.y = TOP_Y;
        rect2.origin.y = CGRectGetMaxY(rect1);
        rect2.size.height = self.view.bounds.size.height - rect2.origin.y;
        rect3.origin.y = kStatusHight - _banner.bounds.size.height* 0.3;
        

        
        [UIView animateWithDuration:0.2 animations:^{
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            [_bannerCover setAlpha:0.5];
            [_bannerCover setFrame:rect3];
            [_banner setFrame:rect3];
            [_hotDetail setFrame:rect1];
            [_tableView setFrame:rect2];
        }];
    } else {
        rect1.origin.y = BUTTON_Y;
        rect2.origin.y = CGRectGetMaxY(rect1);
        rect2.size.height = self.view.bounds.size.height - rect2.origin.y;
        rect3.origin.y = kStatusHight;

        [UIView animateWithDuration:0.2 animations:^{
            [_bannerCover setAlpha:0.0];
            [_bannerCover setFrame:rect3];
            [_banner setFrame:rect3];
            [_hotDetail setFrame:rect1];
            [_tableView setFrame:rect2];
        }];
    }

}
/**
 *  根据偏移量offset移动view,并且记录方向
 *
 *  @param view  拖动的控件
 *  @param heigh 偏移量
 */
-(void)panWithView:(UIView *)view offset:(float)heigh
{
    CGRect rect1 = _hotDetail.frame;
    CGRect rect2 = _tableView.frame;
    CGRect rect3 = _banner.frame;

    
    if (heigh > 0) {
        isTopDirection = NO;
        rect1.origin.y += heigh;
        if (rect1.origin.y < BUTTON_Y) {
            
            float alpha = _bannerCover.alpha;
            float rate = heigh/_bannerCover.frame.size.height;
            alpha -= 0.5 * rate;
            [_bannerCover setAlpha:alpha];
            
            rect3.origin.y += heigh* 0.3;
            [_banner setFrame:rect3];
            [_bannerCover setFrame:rect3];

            
             _hotDetail.frame = rect1;
            
            rect2.origin.y = CGRectGetMaxY(rect1);
            rect2.size.height = self.view.bounds.size.height - rect2.origin.y;
            _tableView.frame = rect2;
            
           
        }
    }else{
        isTopDirection = YES;
        rect1.origin.y += heigh;
        if (rect1.origin.y  > TOP_Y ) {
            
            float alpha = _bannerCover.alpha;
            float rate = heigh/_bannerCover.frame.size.height;
            alpha -= 0.5 * rate;
            [_bannerCover setAlpha:alpha];
            
            rect3.origin.y += heigh* 0.3;
            [_banner setFrame:rect3];
            [_bannerCover setFrame:rect3];

            
            _hotDetail.frame = rect1;
            
            rect2.origin.y = CGRectGetMaxY(rect1);
            rect2.size.height = self.view.bounds.size.height - rect2.origin.y;
            _tableView.frame = rect2;

        }
    }
    
    
    
}
-(void)HotDetailHeader:(HotDetailHeader *)header btnClick:(HotDetailHeaderBtnType)index
{
   [self freshDataWithType:index success:^(NSMutableArray *data) {
       
       //更新数据
       [self.hotDetail setDataArry:data];

       
       
       //将hotdetail中的btn类型装换为tablescroll中的类型
       TableScrollViewType type;
       switch (index) {
           case kHotDetailHeaderBtnTypeCheck:
               type = kTableScrollViewTypeCheck;
               break;
           case kHotDetailHeaderBtnTypeDisease:
               type = kTableScrollViewTypeDisease;
               break;
           case kHotDetailHeaderBtnTypeFood:
               type = kTableScrollViewTypeFood;
               break;
           case kHotDetailHeaderBtnTypeMedic:
               type = kTableScrollViewTypeMedic;
               break;
               
           default:
               break;
       }
       [self.tableView setDataArry:data Type:type];
       
       
   }];

}


//tablescrollview代理,移动到了index
-(void)tableScrollView:(tableScrollView *)table moveReach:(NSInteger)index
{
    [self.hotDetail selectSlideBarItemAtIndex:index];
}
@end

