//
//  ConnentTool.m
//  健康助手
//
//  Created by 未成年大叔 on 15/8/7.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "ConnentTool.h"

@implementation ConnentTool
single_implementation(ConnentTool)
-(instancetype)init
{
    self = [super init];
    self.mainScanType = kscanTypeNormal;
    return self;

}
-(void)startNotifier
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    [self updateInterfaceWithReachability:self.internetReachability];

}
-(void)reachabilityChanged:(NSNotification*)notification
{
    Reachability *currentReachability = [notification object];
    [self updateInterfaceWithReachability:currentReachability];
}
-(void)updateInterfaceWithReachability:(Reachability*)reach
{
    NSString *msg = nil;
    if ([reach currentReachabilityStatus] == NotReachable) {
        self.mainScanType = kscanTypeWithoutNet;
        msg = @"网络连接断开,进入离线浏览状态 ";
    }else if ([reach currentReachabilityStatus] == ReachableViaWiFi){
        self.mainScanType = kscanTypeCache;
        msg = @"WiFi网络连接,进入缓存浏览";
    }else if ([reach currentReachabilityStatus] == ReachableViaWWAN){
        self.mainScanType = kscanTypeNormal;
        msg = @"移动网络连接,进入正常状态";
    }
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"知道了"otherButtonTitles:nil, nil];
    [alert show];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kConnectChangeNotification object:self];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}
@end
