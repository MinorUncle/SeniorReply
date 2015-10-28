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
#import "DetailController.h"
#import "bHttpTool.h"
#import "Healthcfg.h"
#import "MedicineTool.h"
#import "UIImage+MJ.h"


@interface DetailController ()
{
    int serachID;
    UIImageView* _imageView;
    UILabel* _name;
    UILabel* _type;         //药品类型
    UILabel* _typeTip;
    UILabel* _categoryName;
    UILabel* _categoryNameTip; //药品分类
    UILabel* _count;
    UILabel* _countTip;
    UIWebView* _message;
    UILabel* _messageTip;
    UILabel* _tag;
    UILabel* _tagTip;
    UILabel* _ANumber;
    UILabel* _ANumberTip;
}

@end

@implementation DetailController
-(DetailController *)initWithID:(int)ID
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
    [MedicineTool DetailWithParam:@{@"id":@(serachID)} success:^(Medicine* medicin)
     {
         _medicine = medicin;
         [self setFram];
     }failure:^(NSError* err)
     {
         MyLog(@"%@",err);
     }
     ];
    // Do any additional setup after loading the view.
}
-(void)click
{
    [MedicineTool saveMedicine:_medicine];
    [self showNewStatusCount:YES];
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
-(void)addContent
{
    //名称
    _name = [[UILabel alloc]init];
    [_name setFont:titleFont];
    _name.textAlignment =  NSTextAlignmentCenter;
    [_name setTextColor:[UIColor redColor]];

    [self.view addSubview:_name];
    
    //配图
    _imageView = [[UIImageView alloc]init];

    [self.view addSubview:_imageView];

    //类型标题
    _typeTip = [[UILabel alloc]init];
    _typeTip.text = @"药品类型:";
    [_typeTip setFont:ContentFont];
    
    [self.view addSubview:_typeTip];
    //
    _type   = [[UILabel alloc]init];         //药品类型
    [self.view addSubview:_type];
    [_type setFont:ContentFont];


    //分类名称
    _categoryName = [[UILabel alloc]init];
    [self.view addSubview:_categoryName];
    [_categoryName setFont:ContentFont];

    //分类标题

    _categoryNameTip = [[UILabel alloc]init];
    _categoryNameTip.text = @"药品分类:";
    [self.view addSubview:_categoryNameTip];
    [_categoryNameTip setFont:ContentFont];

    
    
    //药品详细内容
    _message = [[UIWebView alloc]init];
    [self.view addSubview:_message];
    //药品详细内容标题
    _messageTip = [[UILabel alloc]init];
    _messageTip.text = @"药品详细内容";
    [_messageTip setFont:ContentFont];
    [self.view addSubview:_messageTip];
    
    //药品备注
    _tag = [[UILabel alloc]init];
    [_tag setFont:ContentFont];

    [self.view addSubview:_tag];
    //药品备注标题
    _tagTip = [[UILabel alloc]init];
    _tagTip.text = @"药品标签Tag:";
    [_tagTip setFont:ContentFont];
    [self.view addSubview:_tagTip];
    //国药准字
    _ANumber = [[UILabel alloc]init];
    [self.view addSubview:_ANumber];
    [_ANumber setFont:ContentFont];

    //国药准字标题
    _ANumberTip = [[UILabel alloc]init];
    _ANumberTip.text = @"";
    [self.view addSubview:_ANumberTip];
    [_ANumberTip setFont:ContentFont];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setFram
{
    float width = self.view.bounds.size.width - ContentPadding;
    if(_medicine == nil)return;
    _name.text = _medicine.name;
    CGRect rect = (CGRect){ContentPadding,0,width,HeaderH};
   
    [_name setFrame:rect];
    
    [bHttpTool downloadImage:[imageBaseURL stringByAppendingPathComponent:_medicine.image] place:[UIImage imageNamed:@"timeline_image_loading.png"] imageView:_imageView];
    rect.origin.y += rect.size.height;
    rect.size.height = 100;
    rect.size.width = 320;
   
    [_imageView setFrame:rect];
    [_imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    
    rect.origin.x = ContentPadding;
    rect.origin.y += rect.size.height;
    rect.size.height = ContentH;
    rect.size.width = titleW;
    _typeTip.text = @"药品类型:";
    [_typeTip setFrame:rect];
    
    
    _type.text = _medicine.type;         //药品类型
    rect.origin.x = rect.size.width+10;
    rect.size.width = width - rect.origin.x;
    [_type setFrame:rect];
    
//    
//    rect.origin.y += rect.size.height;
//    CGSize textSize = [_type.text sizeWithFont:ContentFont  constrainedToSize:CGSizeMake(self.view.bounds.size.width - 2 * kCellBorderWidth, MAXFLOAT)];
//    [_type  setFrame:(CGRect){rect.origin,textSize}];

    
    
    
    //药品分类标题
    rect.origin.x = ContentPadding;
    rect.origin.y += rect.size.height;
    rect.size.height = ContentH;
    rect.size.width = titleW;
    _categoryNameTip.text = @"药品分类:";
    [_categoryNameTip setFrame:rect];
    
    //药品类型
    rect.origin.x = rect.size.width+10;
    rect.size.width = width - rect.origin.x;
    [_categoryName setFrame:rect];
     _categoryName.text = _medicine.categroyNmae;
    MyLog(@"%@",_categoryName.text);
    
    //国药编号标题
    rect.origin.x =ContentPadding;
    rect.origin.y += rect.size.height;
    rect.size.height = ContentH;
    rect.size.width = titleW;
    _ANumberTip.text = @"编号:";
    [_ANumberTip setFrame:rect];
    
    //国药编号标题
    _ANumber.text = _medicine.ANumber;
    rect.origin.x = rect.size.width+10;
    rect.size.width = width - rect.origin.x;
    [_ANumber setFrame:rect];
    
    
    
    //药品标签标题
    rect.origin.x = ContentPadding;
    rect.origin.y += rect.size.height;
    rect.size.height = ContentH;
    rect.size.width = titleW;
    [_tagTip setFrame:rect];
    _tagTip.text = @"药品标签Tag:";
    
    //药品标签
    rect.origin.x = rect.size.width+10;
    rect.size.width = width - rect.origin.x;
    _tag.text = _medicine.tag;
    _tag.lineBreakMode = NSLineBreakByWordWrapping;
    _tag.numberOfLines = 0;
    CGSize textSize = [_tag.text sizeWithFont:ContentFont  constrainedToSize:CGSizeMake(rect.size.width, MAXFLOAT)];
    
    
    rect.size = textSize;
    [_tag setFrame:rect];
    

    //内容标题
    rect.origin.x = ContentPadding;
    rect.origin.y += rect.size.height;
    rect.size.height = ContentH;
    rect.size.width = titleW;
    _messageTip.text = @"药品详细内容:";
    [_messageTip setFrame:rect];
    
    //详细内容
     NSString* messageString = _medicine.detailMessage;
    rect.origin.x = 0;
    rect.origin.y += rect.size.height;
    messageString = [NSString stringWithFormat:@"<html><body style=\"font-size: 12px;padding:%dpx;overflow:hidden;\">%@</body></html>",ContentPadding,messageString];
        [_message loadHTMLString:messageString baseURL:nil];
    textSize = [messageString sizeWithFont:ContentFont  constrainedToSize:CGSizeMake(self.view.bounds.size.width, MAXFLOAT)];
    textSize.height +=120;
    
    [_message setFrame:(CGRect){rect.origin,textSize}];
    [_message setUserInteractionEnabled:NO];
    [_message.scrollView setShowsHorizontalScrollIndicator:NO];
    [_message.scrollView setShowsVerticalScrollIndicator:NO];
//    [_message]
    [((UIScrollView*)self.view)setContentSize:CGSizeMake(0, CGRectGetMaxY(_message.frame))];
    
    
   
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
