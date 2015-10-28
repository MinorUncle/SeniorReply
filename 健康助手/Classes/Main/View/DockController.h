//
//  DockController.h
//  测试Dock
//
//  Created by apple on 13-10-27.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dock.h"

@interface DockController : UIViewController
{
    Dock *_dock;
}
- (void)dock:(Dock *)dock itemSelectedFrom:(int)from to:(int)to;
@property (nonatomic, readonly) UIViewController *selectedController;
@end
