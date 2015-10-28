//
//  tableScrollView.m
//  健康助手
//
//  Created by 未成年大叔 on 15/8/11.
//  Copyright (c) 2015年 itcast. All rights reserved.
//
#define HEAD_H 60
#import "tableScrollView.h"
#import "DiseaseBaseController.h"
#import "CheckBaseController.h"
#import "MediclineBaseController.h"
#import "FoodBaseController.h"
@interface tableScrollView()<UIScrollViewDelegate>
{
    NSInteger _currentIndex;
    NSInteger _preTouchHPoint;
    NSInteger _preon;
    NSMutableArray* _tablesArry;

    
}
@property(nonatomic,assign)TableScrollViewType currentType;
@property(nonatomic,strong)NSMutableArray* dataArry;
@property(nonatomic,retain)UIViewController* supController;
@end

@implementation tableScrollView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self setPagingEnabled:YES];
        self.delegate = self;
        self.backgroundColor= [UIColor whiteColor];
    }
    return self;
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    

    self.contentSize = CGSizeMake(5 * self.bounds.size.width, 0);
    
    
}
-(UIViewController *)supController
{
    if (_supController == nil) {
        _supController = [self viewController:self];
    }
    return _supController;
}


-(void)setCurrentType:(TableScrollViewType)currentType
{
    for (UIView* i in self.subviews) {
        [i removeFromSuperview];
    }
    if(self.dataArry.count <3)
    {
        MyLog(@"分类个数小于三,数据获取错误,请重试");
        return;
    }

    switch (currentType) {
        case kTableScrollViewTypeCheck:
        {
            CGRect rect = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
            CheckBaseController* tableViewFrist1 = [[CheckBaseController alloc]init];
            NSDictionary* dic = self.dataArry[0];
            tableViewFrist1.ID = [dic[@"ID"] integerValue];
            tableViewFrist1.view.frame = rect;
            tableViewFrist1.Navigationdelegate = self.supController.navigationController;
            [self addSubview:tableViewFrist1.view];
            
            CheckBaseController* tableViewFrist2 = [[CheckBaseController alloc]init];
            dic = self.dataArry[1];
            tableViewFrist2.ID =[dic[@"ID"] integerValue];
            rect.origin.x += self.bounds.size.width;
            tableViewFrist2.view.frame = rect;
            tableViewFrist2.Navigationdelegate = self.supController.navigationController;
            [self addSubview:tableViewFrist2.view];
            
            CheckBaseController* tableViewFrist3 = [[CheckBaseController alloc]init];
            dic = self.dataArry[2];
            tableViewFrist3.ID =[dic[@"ID"] integerValue];
            rect.origin.x += self.bounds.size.width;
            tableViewFrist3.view.frame = rect;
            tableViewFrist3.Navigationdelegate = self.supController.navigationController;
            [self addSubview:tableViewFrist3.view];
          
            
            _tablesArry =[NSMutableArray arrayWithObjects:tableViewFrist1,tableViewFrist2,tableViewFrist3,nil];
            
            break;
        }
        case kTableScrollViewTypeDisease:
        {
            
            CGRect rect = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
            DiseaseBaseController* tableViewFrist1 = [[DiseaseBaseController alloc]init];
            NSDictionary* dic = self.dataArry[0];
            tableViewFrist1.ID = [dic[@"ID"] integerValue];
            tableViewFrist1.view.frame = rect;
            tableViewFrist1.Navigationdelegate = self.supController.navigationController;
            [self addSubview:tableViewFrist1.view];
            
            DiseaseBaseController* tableViewFrist2 = [[DiseaseBaseController alloc]init];
            dic = self.dataArry[1];
            tableViewFrist2.ID =[dic[@"ID"] integerValue];
            rect.origin.x += self.bounds.size.width;
            tableViewFrist2.view.frame = rect;
            tableViewFrist2.Navigationdelegate = self.supController.navigationController;
            [self addSubview:tableViewFrist2.view];
            
            DiseaseBaseController* tableViewFrist3 = [[DiseaseBaseController alloc]init];
            dic = self.dataArry[2];
            tableViewFrist3.ID =[dic[@"ID"] integerValue];
            rect.origin.x += self.bounds.size.width;
            tableViewFrist3.view.frame = rect;
            tableViewFrist3.Navigationdelegate = self.supController.navigationController;

            [self addSubview:tableViewFrist3.view];
            
            
            _tablesArry =[NSMutableArray arrayWithObjects:tableViewFrist1,tableViewFrist2,tableViewFrist3,nil];
            

            break;
        }
        case kTableScrollViewTypeFood:
        {
            {
                CGRect rect = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
                FoodBaseController* tableViewFrist1 = [[FoodBaseController alloc]init];
                NSDictionary* dic = self.dataArry[0];
                tableViewFrist1.ID = [dic[@"ID"] integerValue];
                tableViewFrist1.view.frame = rect;
                tableViewFrist1.Navigationdelegate = self.supController.navigationController;
                [self addSubview:tableViewFrist1.view];
                
                FoodBaseController* tableViewFrist2 = [[FoodBaseController alloc]init];
                dic = self.dataArry[1];
                tableViewFrist2.ID =[dic[@"ID"] integerValue];
                rect.origin.x += self.bounds.size.width;
                tableViewFrist2.view.frame = rect;
                tableViewFrist2.Navigationdelegate = self.supController.navigationController;
                [self addSubview:tableViewFrist2.view];
                
                FoodBaseController* tableViewFrist3 = [[FoodBaseController alloc]init];
                dic = self.dataArry[2];
                tableViewFrist3.ID =[dic[@"ID"] integerValue];
                rect.origin.x += self.bounds.size.width;
                tableViewFrist3.view.frame = rect;
                tableViewFrist3.Navigationdelegate = self.supController.navigationController;
                [self addSubview:tableViewFrist3.view];
                
                
                _tablesArry =[NSMutableArray arrayWithObjects:tableViewFrist1,tableViewFrist2,tableViewFrist3,nil];
                
                
                break;
            }
        }
        case kTableScrollViewTypeMedic:
        {
            CGRect rect = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
            MedicineBaseController* tableViewFrist1 = [[MedicineBaseController alloc]init];
            NSDictionary* dic = self.dataArry[0];
            tableViewFrist1.ID = [dic[@"ID"] integerValue];
            tableViewFrist1.view.frame = rect;
            tableViewFrist1.Navigationdelegate = self.supController.navigationController;
            [self addSubview:tableViewFrist1.view];
                       
            MedicineBaseController* tableViewFrist2 = [[MedicineBaseController alloc]init];
            dic = self.dataArry[1];
            tableViewFrist2.ID =[dic[@"ID"] integerValue];
            rect.origin.x += self.bounds.size.width;
            tableViewFrist2.view.frame = rect;
            tableViewFrist2.Navigationdelegate = self.supController.navigationController;
            [self addSubview:tableViewFrist2.view];
            
            MedicineBaseController* tableViewFrist3 = [[MedicineBaseController alloc]init];
            dic = self.dataArry[2];
            tableViewFrist3.ID =[dic[@"ID"] integerValue];
            rect.origin.x += self.bounds.size.width;
            tableViewFrist3.view.frame = rect;
            tableViewFrist3.Navigationdelegate = self.supController.navigationController;
            [self addSubview:tableViewFrist3.view];
            
            
            _tablesArry =[NSMutableArray arrayWithObjects:tableViewFrist1,tableViewFrist2,tableViewFrist3,nil];
            

            break;
        }
        default:
            break;
    }
}
- (UIViewController*)viewController:(UIView*)view
{
    for (UIView* next = [view superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}
-(void)setDataArry:(NSMutableArray *)dataArry Type:(TableScrollViewType)type
{
    _dataArry = dataArry;
    self.currentType = type;
    self.contentSize = CGSizeMake(dataArry.count * self.bounds.size.width, 0);
    [self moveToIndex:0];
    
}
-(void)moveToIndex:(NSInteger)num
{
//    [self shortTableArry];
    CGPoint point = self.contentOffset;
    point.x = num * self.bounds.size.width;

    int temNum = num;
    __block  int offset = 0;
    
    //如果
    offset = (temNum - _currentIndex) * self.bounds.size.width;
    
    //是否移动table的标记,在两边,则不需要移动
    BOOL flg = (offset > 0 && temNum >2) || (offset < 0 && temNum < _dataArry.count-3);
    if(!flg)offset = 0;

    if (offset != 0) {
        //如果大于0 则用最右边的一道num位置,否则最左边移到num位置
        
        if(offset > 0){
            int max =0;
            for (BaseList* i in _tablesArry) {
                if (i.view.frame.origin.x > max) {
                    max = i.view.frame.origin.x;
                }
            }
            offset = temNum  * self.frame.size.width - max ;
        }else {
            int min = 999999;
            for (BaseList* i in _tablesArry) {
                if (i.view.frame.origin.x <min) {
                    min = i.view.frame.origin.x;
                }
            }
            offset = temNum  * self.frame.size.width - min ;

        }
        
                for (int j=0; j<_tablesArry.count;j++) {
                    
                    BaseList* i = (BaseList*)_tablesArry[j];
                    
                    //浮点数相等的比较  //判断是否为当前界面显示table
                    BOOL flg =i.view.frame.origin.x - _currentIndex * self.frame.size.width > -0.1 && i.view.frame.origin.x - _currentIndex * self.frame.size.width < 0.1;
                    //如果当前i为界面当前显示的table则不更新数据,最后去更新;否则现在更新
                    if (!flg) {
                        
                        int numI = i.view.frame.origin.x /(self.bounds.size.width -1);  //当前的table在屏幕第几个位置;
                        int numOffset = offset/(self.bounds.size.width -1);//移动的屏幕个数,减一防止浮点误差,
                        
                        int tem = temNum - numOffset - numI;//减一防止浮点误差,tem为当前table与移动的table的距离
                        NSDictionary* dic = _dataArry[temNum - tem];
                        i.ID = [dic[@"ID"] integerValue];
                        [i.tableView reloadData];
                    }
                }
    }
    
   
    
    [UIView animateWithDuration:0.5 animations:^{
        
        for (BaseList * i in _tablesArry) {
            CGRect rect = i.view.frame;
            rect.origin.x += offset;
            i.view.frame = rect;
        }
        self.contentOffset = point;

        
        
    } completion:^(BOOL finished) {
        //调整位置
        [self adjustTable];
    }];
    
   
    
}

/**
 *  将_tablearry中的table按照位置从小到大排列
 */
//-(void)shortTableArry
//{
//    int count = _tablesArry.count;
//    for (int  i=0; i<count ;i++) {
//        for (int j=0; j<count; j++) {
//            if (((BaseList*)_tablesArry[i]).view.frame.origin.x >  ((BaseList*)_tablesArry[j]).view.frame.origin.x) {
//                BaseList* temList =(BaseList*)_tablesArry[i];
//                _tablesArry[i] = _tablesArry[j];
//                _tablesArry[j] = temList;
//            }
//        }
//    }
//}
//-(void)moveToLeft
//{
//}


-(void)adjustTable
{
    NSInteger offset = self.contentOffset.x;
    _currentIndex = offset / self.bounds.size.width;
    
    
    
    for (BaseList* i in _tablesArry) {
        CGRect rect = i.view.frame;
        if (offset - i.view.frame.origin.x < 10 && offset - i.view.frame.origin.x > -10) {//当前table
            continue;
        }else if (_currentIndex < _dataArry.count-1 && offset -i.view.frame.origin.x > self.bounds.size.width + 10) {//加10防止误差//当左边有两个时说明右边没有,则需要将最左边的移到右边做准备
            rect.origin.x =offset + self.bounds.size.width;
            [i.view setFrame:rect];
            
            //准备好右边table
            NSDictionary* dic = self.dataArry[_currentIndex + 1];
            i.ID = [dic[@"ID"] integerValue];
            [i.tableView reloadData];
            NSLog(@"补充右边");
            
            
        }else if(_currentIndex >0 && i.view.frame.origin.x - offset >  self.bounds.size.width  + 10){//加10防止误差
            rect.origin.x =offset -  self.bounds.size.width;
            [i.view setFrame:rect];
            
            //准备好左边table
            NSDictionary* dic = self.dataArry[_currentIndex - 1];
            i.ID = [dic[@"ID"] integerValue];

            [i.tableView reloadData];
            
            NSLog(@"补充左边");
        }else if(i.view.frame.origin.x - offset > self.bounds.size.width  - 10 && i.view.frame.origin.x - offset < self.bounds.size.width  + 10){
            NSDictionary* dic = self.dataArry[_currentIndex + 1];
            if(i.ID != [dic[@"ID"] integerValue])
            {
                i.ID = [dic[@"ID"] integerValue];
                [i.tableView reloadData];
                
                NSLog(@"更新右边数据,如果有变化");

            }
            
        }else if(offset - i.view.frame.origin.x  > self.bounds.size.width  - 10 && offset - i.view.frame.origin.x  < self.bounds.size.width  + 10){
            NSDictionary* dic = self.dataArry[_currentIndex - 1];
            if(i.ID != [dic[@"ID"] integerValue])
            {
                i.ID = [dic[@"ID"] integerValue];
                [i.tableView reloadData];
                
                NSLog(@"更新左边数据,如果有变化");

            }
            
        }
    }
    
    //还原当前table
    //    ((UITableView*)_tablesArry[_currentIndex]).delegate = self;
    //    ((UITableView*)_tablesArry[_currentIndex]).hidden = NO;
    
}


//scroll代理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint P = [self.panGestureRecognizer translationInView:self];
    if (_preTouchHPoint < P.x) {
        //     NSLog(@"向右移动");
        // ((UITableView*) _tablesArry[_currentIndex]).delegate = nil;
        //  [((UITableView*) _tablesArry[_currentIndex +1]) reloadData];
        //  r = 4;
    }else{
        //     NSLog(@"向左移动");
    }
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self adjustTable];
    [self.tableScrollViewdelegate tableScrollView:self moveReach:_currentIndex];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    CGPoint p = [self.panGestureRecognizer translationInView:self];
    _preTouchHPoint = p.x;
    // NSLog(@"%f",self.contentOffset.x);
}
@end
