//
//  ConnentTool.h
//  健康助手
//
//  Created by 未成年大叔 on 15/8/7.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "Reachability.h"
typedef enum
{
    kscanTypeWithoutNet, //无网络离线状态
    kscanTypeNoImage ,//无图状态
    kscanTypeNormal ,//普通状态
    kscanTypeCache //缓存状态
}kscanType;
//kscanType mainScanType = kscanTypeNormal;

@interface ConnentTool : NSObject
single_interface(ConnentTool);
@property (nonatomic,assign)kscanType  mainScanType;
@property (nonatomic) Reachability *internetReachability;
-(void)startNotifier;

@end
