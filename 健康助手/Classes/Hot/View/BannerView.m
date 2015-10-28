//
//  BannerView.m
//  健康助手
//
//  Created by 未成年大叔 on 15/8/14.
//  Copyright (c) 2015年 itcast. All rights reserved.
//
#define ATTEMPCOUNT 9

#import "BannerView.h"
#import "MedicineTool.h"
#import "CheckTool.h"
#import "DiseaseTool.h"
#import "FoodTool.h"
#import "DetailCheckController.h"
#import "DetailMedicineController.h"
#import "Healthcfg.h"
#import "HttpTool.h"
#import "DetailFoodController.h"
#import "DetailDiseaseController.h"
static int times;

typedef enum {
    kBannerTypeMedic, // 药品大全
    kBannerTypeFood, // 健康饮食
    kBannerTypeCheck, // 健康饮食
    kBannerTypeDisease, // 健康饮食
}BannerType;
@interface BannerView()
{    
    int attempTimes ;//尝试获取banner图片的次数.超过ATTEMPCOUNT失败则停止
    

}
@property(nonatomic,assign)NSInteger medicineID;
@property(nonatomic,assign)NSInteger checkID;
@property(nonatomic,assign)NSInteger diseaseID;
@property(nonatomic,assign)NSInteger foddID;

@property(nonatomic,copy)NSString* medicineImage;
@property(nonatomic,copy)NSString* checkImage;
@property(nonatomic,copy)NSString* diseaseImage;
@property(nonatomic,copy)NSString* foodImage;

@property(nonatomic,retain)UIPageControl* page;
@property(nonatomic,retain)NSMutableArray* dataArry;


@end
@implementation BannerView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setShowsHorizontalScrollIndicator:NO];
        self.delegate = self;
        self.pagingEnabled =YES;
        [self startUI];
        self.dataArry = [[NSMutableArray alloc]init];
        
        
        
        [self addImageWithType:kBannerTypeFood];
        [self addImageWithType:kBannerTypeFood];
        [self addImageWithType:kBannerTypeFood];
        [self addImageWithType:kBannerTypeFood];
        [self addImageWithType:kBannerTypeMedic];

        
    }
    return self;
}

-(void)addImageWithType:(BannerType)type
{
    times++;
    
    switch (type) {
        case kBannerTypeFood:
        {
            [self getFoodWithBlock:^(NSString * image,NSInteger ID) {
                NSString* imgstr = [imageBaseURL stringByAppendingPathComponent:image];
                NSDictionary* dic = @{@"image":imgstr,@"id":@(ID),@"type":@(kBannerTypeFood)};
                [self.dataArry addObject:dic];
                times--;
                if(!times) [self reloadUI];
            } failure:^(NSError *err) {
                NSLog(@"kBannerTypeFood err  %@",err);
                times--;
                if(!times) [self reloadUI];

            }];
            break;
        }
        case kBannerTypeDisease:
        {
            [self getDiseaseWithBlock:^(NSString * image,NSInteger ID) {
                NSString* imgstr = [imageBaseURL stringByAppendingPathComponent:image];
                NSDictionary* dic = @{@"image":imgstr,@"id":@(ID),@"type":@(kBannerTypeDisease)};
                [self.dataArry addObject:dic];
                times--;

                if(!times)[self reloadUI];
            }failure:^(NSError *err) {
                NSLog(@"kBannerTypeDisease err  %@",err);
                times--;

                if(!times) [self reloadUI];
                
            }];

            break;
        }
        case kBannerTypeMedic:
        {
            [self getMedicineWithBlock:^(NSString * image,NSInteger ID) {
                NSString* imgstr = [imageBaseURL stringByAppendingPathComponent:image];
                NSDictionary* dic = @{@"image":imgstr,@"id":@(ID),@"type":@(kBannerTypeMedic)};
                [self.dataArry addObject:dic];
                times--;

                if(!times)[self reloadUI];
            }failure:^(NSError *err) {
                NSLog(@"kBannerTypeMedic err  %@",err);
                times--;

                if(!times)[self reloadUI];

            }];
            
            break;
        }
        default:
            break;
    }
}

-(void)setContentOffset:(CGPoint)contentOffset
{
    //系统自动调用contentOffset.y == -64,  未知原因
    CGPoint point = contentOffset;
    point.y = 0;
    [super setContentOffset:point];

}
-(void)startUI
{
    UIImage* img = [UIImage imageNamed:@"timeline_image_loading.png"];
    UIImageView* imgView = [[UIImageView alloc]init];
    imgView.frame = self.bounds;
    imgView.image = img;
    [self addSubview:imgView];
}
-(void)reloadUI
{
    for (UIView* view in self.subviews) {
        [view removeFromSuperview];
    }
  
   
    for (int i=0; i< self.dataArry.count; i++) {
        UIImageView* imgView = [[UIImageView alloc]init];
        NSString* img =self.dataArry[i][@"image"];
        MyLog(@"dataarry  %lu",(unsigned long)self.dataArry.count);
        [HttpTool downloadImage:img place:[UIImage imageNamed:@"timeline_image_loading.png"] imageView:imgView];
        CGRect rect = CGRectMake(self.bounds.size.width * i, 0,self.bounds.size.width, self.bounds.size.height);
        [imgView setFrame:rect];
        [self addSubview:imgView];

    }
    self.contentSize =(CGSize){self.bounds.size.width * self.dataArry.count,0};
    [self reloadPageControl];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    NSDictionary* dic = _dataArry[(int)(point.x / self.bounds.size.width)];
    
    
    switch ([dic[@"type"] intValue]) {
        case kBannerTypeDisease:
        {
            int ID = [(NSNumber*)dic[@"id"] integerValue];
            DetailDiseaseController* controller = [[DetailDiseaseController alloc]initWithID:ID];
            [[self viewController:self].navigationController pushViewController:controller animated:YES];
            break;
        }
        case kBannerTypeFood:
        {
            int ID = [(NSNumber*)dic[@"id"] integerValue];
            DetailFoodController* controller = [[DetailFoodController alloc]initWithID:ID];
            [[self viewController:self].navigationController pushViewController:controller animated:YES];
            break;
        }
        case kBannerTypeMedic:
        {
            int ID = [(NSNumber*)dic[@"id"] integerValue];
            DetailMedicineController* controller = [[DetailMedicineController alloc]initWithID:ID];
            [[self viewController:self].navigationController pushViewController:controller animated:YES];
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
//-(void)tapGestuer:(UITapGestureRecognizer*)tap
//{
//    int num = self.contentOffset.x / self.bounds.size.width;
//    NSInteger ID = [self.dataArry[num][@"id"] integerValue];
//    NSString* type = self.dataArry[num][@"type"];
//    if ([type isEqualToString:@"FOOD"]){
//        DetailFoodController* controller = [[DetailFoodController alloc]initWithID:ID];
//        
//        [[self viewController:self].navigationController pushViewController:controller animated:YES];
//    } else if ([type isEqualToString:@"DISEASE"]){
//        DetailDiseaseController* controller = [[DetailDiseaseController alloc]initWithID:ID];
//        
//        [[self viewController:self].navigationController pushViewController:controller animated:YES];
//    }
//}
- (void)reloadPageControl
{
    [_page removeFromSuperview];
    CGSize size = self.frame.size;
    UIPageControl *page = [[UIPageControl alloc] init];
    page.center = CGPointMake(size.width * 0.5, size.height * 0.95);
    page.numberOfPages = self.dataArry.count;
    page.currentPageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"new_feature_pagecontrol_checked_point.png"]];
    page.pageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"new_feature_pagecontrol_point.png"]];
    page.bounds = CGRectMake(0, 0, 150, 0);
    [self addSubview:page];
    _page = page;
}




-(void)getFoodWithBlock:(void (^)(NSString*,NSInteger))success failure:(void(^)(NSError*))failure
{
    
    NSInteger page =  arc4random()%1000;
    NSDictionary* pram =@{@"page":@(page),@"limit":@(1)};
    
    
    [FoodTool ListWithParam:pram success:^(NSArray *foods) {
        if (foods.count <=0 ) {
            return ;
        }
        Food *food = foods[0];
        if (((Food*)food).image != nil && ![((Food*)food).image isEqualToString:foodDefaultImage]) {
            
            success(((Food*)food).image,((Food*)food).ID);
            
        }else{
            [self getFoodWithBlock:^(NSString *image,NSInteger imgID) {
                success(image,imgID);
            } failure:^(NSError *err) {
                failure(err);
            }];
        }

    } failure:^(NSError *err) {
        failure(err);
    }];
    
    
}
-(void)getDiseaseWithBlock:(void (^)(NSString*,NSInteger))block failure:(void(^)(NSError*))failure
{
        NSInteger ID =  arc4random()%100;
        NSDictionary* pram =@{@"id":@(ID)};
        [DiseaseTool DetailWithParam:pram success:^(id disease) {
            
            if (((Disease*)disease).image != nil && ![((Disease*)disease).image isEqualToString:diseaseDefaultImage]) {
                block(((Disease*)disease).image,ID);
            }else{
                [self getDiseaseWithBlock:^(NSString *image,NSInteger imgID) {
                    block(image,imgID);
                    
                } failure:^(NSError *err) {
                    failure(err);
                }];
            }
        } failure:^(NSError *err) {
           failure(err);
        }];
    
}

-(void)getMedicineWithBlock:(void (^)(NSString*,NSInteger))block failure:(void(^)(NSError*))failure
{
    NSInteger ID =  arc4random()%100;
    NSDictionary* pram =@{@"id":@(ID)};
    [MedicineTool DetailWithParam:pram success:^(id medic) {
        
        if (((Medicine*)medic).image != nil && ![((Medicine*)medic).image isEqualToString:medicineDefaultImage]) {
            block(((Medicine*)medic).image,ID);
        }else{
            [self getMedicineWithBlock:^(NSString *image,NSInteger imgID) {
                block(image,imgID);
                
            } failure:^(NSError *err) {
                failure(err);
            }];
        }
    } failure:^(NSError *err) {
        failure(err);
    }];
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _page.currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGSize size = self.frame.size;
    CGPoint point = CGPointMake(size.width * 0.5+scrollView.contentOffset.x, size.height * 0.95);
    _page.center = point;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
