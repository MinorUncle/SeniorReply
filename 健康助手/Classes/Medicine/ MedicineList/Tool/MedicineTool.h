//
//  MedicineTool.h
//  健康助手
//
//  Created by 未成年大叔 on 15/7/23.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeBaseTool.h"
#import "Medicine.h"

@interface MedicineTool :HomeBaseTool
+ (NSMutableArray*)getMedicineArryWithCoding;
+ (void)saveMedicine:(Medicine *)medicine;
+(void)deleteMedicine:(Medicine *)medicine;
+(void)initPath;
+(void)initOffsetNumber;
+(BOOL)existCorrentMedicine:(NSInteger)ID;

@end
