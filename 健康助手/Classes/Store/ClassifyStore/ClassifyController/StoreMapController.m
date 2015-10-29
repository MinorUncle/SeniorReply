//
//  MapViewBaseDemoViewController.m
//  BaiduMapSdkSrc
//
//  Created by BaiduMapAPI on 13-7-24.
//  Copyright (c) 2013年 baidu. All rights reserved.
//

#import "StoreMapController.h"
#import "StoreTool.h"
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Map/BMKPointAnnotation.h>

@interface StoreMapController()<UIGestureRecognizerDelegate,BMKLocationServiceDelegate> {
    BMKLocationService* _locService;
    NSArray* _storeArry;
    BMKUserLocation* _userLocal;
    

}
@end

@implementation StoreMapController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    _locService = [[BMKLocationService alloc]init];

    
    CGRect rect = self.view.bounds;
    rect.size.height -= kDockHeight;
    rect.size.height -= self.navigationController.navigationBar.bounds.size.height;
    _mapView = [[BMKMapView alloc]initWithFrame:rect];
    [self.view addSubview:_mapView];
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        //        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
    [self addCustomGestures];//添加自定义的手势
    _mapView.zoomEnabled = YES;
    _mapView.scrollEnabled = YES;
    _mapView.showMapScaleBar = YES;
    //自定义比例尺的位置
    _mapView.mapScaleBarPosition = CGPointMake(_mapView.frame.size.width - 70, _mapView.frame.size.height - 40);
    [_mapView setCompassPosition:CGPointMake(273,10)];


}

-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _locService.delegate = self;

    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    
    [self startLocation];
    [self startFollowing];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}
- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
}
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


#pragma mark - BMKMapViewDelegate

- (void)mapViewDidFinishLoading:(BMKMapView *)mapView {
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"BMKMapView控件初始化完成" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
//    [alert show];
//    alert = nil;
}

- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate {
    NSLog(@"map view: click blank");
}

- (void)mapview:(BMKMapView *)mapView onDoubleClick:(CLLocationCoordinate2D)coordinate {
    NSLog(@"map view: double click");
}

#pragma mark - 添加自定义的手势（若不自定义手势，不需要下面的代码）

- (void)addCustomGestures {
    /*
     *注意：
     *添加自定义手势时，必须设置UIGestureRecognizer的属性cancelsTouchesInView 和 delaysTouchesEnded 为NO,
     *否则影响地图内部的手势处理
     */
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTap.delegate = self;
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.cancelsTouchesInView = NO;
    doubleTap.delaysTouchesEnded = NO;
    
    [self.view addGestureRecognizer:doubleTap];
    
    /*
     *注意：
     *添加自定义手势时，必须设置UIGestureRecognizer的属性cancelsTouchesInView 和 delaysTouchesEnded 为NO,
     *否则影响地图内部的手势处理
     */
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;
    singleTap.delaysTouchesEnded = NO;
    [singleTap requireGestureRecognizerToFail:doubleTap];
    [self.view addGestureRecognizer:singleTap];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)theSingleTap {
    /*
     *do something
     */
    NSLog(@"附近数据更新");
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)theDoubleTap {
    /*
     *do something
     */
    
    [self showNearList];
    NSLog(@"my handleDoubleTap");
}

-(void)showNearList
{
    double x = _userLocal.location.coordinate.longitude;
    double y = _userLocal.location.coordinate.latitude;

    int limit = 5;
    [StoreTool LocalWithParam:@{@"x":@(x),@"y":@(y),@"limit":@(limit),@"type":@"count"} success:^(NSArray *storeList) {
        _storeArry = storeList;
        
        NSMutableArray* annotations = [NSMutableArray array];
        for (Store* i in _storeArry) {
            CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(i.localY, i.localX);
            NSString* title = i.name;
            NSLog(@"coord -- %f -- %f ",coord.longitude,coord.latitude);
            
            BMKPointAnnotation* point = [[BMKPointAnnotation alloc]init];
            point.title = title;
            point.coordinate = coord;
            [annotations addObject:point];
            
        }
        NSArray* temarry = _mapView.annotations;
        [_mapView removeAnnotations:temarry];
        [_mapView addAnnotations:annotations];
        
    } failure:^(NSError *err) {
        NSLog(@"%@",err.localizedDescription);
    }];
}
//普通态
-(void)startLocation
{
    NSLog(@"进入普通定位态");
    [_locService startUserLocationService];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
}

-(void)startFollowing
{
    NSLog(@"进入跟随态");
    
    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    _mapView.showsUserLocation = YES;
    
}
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    _userLocal = userLocation;
    NSLog(@"heading is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_mapView updateLocationData:userLocation];
    _userLocal = userLocation;
}


@end
