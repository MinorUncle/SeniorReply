//
//  WriteView.h
//  健康助手
//
//  Created by 未成年大叔 on 15/7/23.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WriteView : UIView
{
    UIButton* _btn;
}
@property (nonatomic,assign,readonly)BOOL btnSelected;
@property (nonatomic,strong)UITextView* textView;
-(id)initWithText:(NSString*)t;

@end
