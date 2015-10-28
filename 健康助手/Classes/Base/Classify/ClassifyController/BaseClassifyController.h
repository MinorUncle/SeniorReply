//
//  ClassifyController.h
//  新浪微博
//
//  Created by 未成年大叔 on 15/7/24.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "classifyBox.h"

@interface BaseClassifyController : UIViewController <ClassifyDelegate>
@property(nonatomic,copy)NSArray* medicClass;

@end
