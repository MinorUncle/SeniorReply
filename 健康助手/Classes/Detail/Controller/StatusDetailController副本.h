//
//  StatusDetailController.h
//  新浪微博
//
//  Created by apple on 13-11-5.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Status;
@interface StatusDetailController : UITableViewController
@property (nonatomic, strong) Status *status;
@end