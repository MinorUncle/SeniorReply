//
//  GroupCell.m
//  健康助手
//
//  Created by apple on 13-10-29.
//  Copyright (c) 2013年 itcast. All rights reserved.
//
#define ButtonW 60
#define ButtonH 26
#import "GroupCell.h"
#import "UIImage+MJ.h"
@interface GroupCell()
{
    UIImageView *_rightArrow;
}
@end
@implementation GroupCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 2.清空label的背景色
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.highlightedTextColor = self.textLabel.textColor;
    }
    return self;
}

#pragma mark 设置cell的类型
- (void)setCellType:(CellType)cellType
{
    _cellType = cellType;
    
    
    
    switch (cellType) {
        case kCellTypeArrow:
            if (_rightArrow == nil) {
                _rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_icon_arrow.png"]];
            }
            self.accessoryView = _rightArrow;
            break;
        case kCellTypeLabel:
            if (_rightLabel == nil) {
                UILabel *label = [[UILabel alloc] init];
                label.backgroundColor = [UIColor clearColor];
                label.textAlignment = NSTextAlignmentCenter;
                label.textColor = [UIColor grayColor];
                label.bounds = CGRectMake(0, 0, 80, 44);
                label.font = [UIFont systemFontOfSize:12];
                _rightLabel = label;
            }
            self.accessoryView = _rightLabel;
            break;
        case kCellTypeSwitch:
            if (_rightSwitch == nil) {
                _rightSwitch = [[UISwitch alloc] init];
            }
            self.accessoryView = _rightSwitch;
            break;
        case kCellTypeButton:
            if (_rightButton == nil) {
                UIButton *btn = [[UIButton alloc] init];
                
                btn.backgroundColor = [UIColor clearColor];
                btn.frame = CGRectMake(0, 0, ButtonW, ButtonH);
                btn.layer.borderWidth = 1.0;
                UIColor* color = [UIColor colorWithRed:125/255.0 green:191.0/255.0 blue:249/255.0 alpha:1];
                btn.layer.borderColor = color.CGColor;
                [btn setTitleColor:color forState:UIControlStateNormal];
                btn.layer.cornerRadius = ButtonH / 2.0;
                btn.titleLabel.font = [UIFont systemFontOfSize:10];
                _rightButton = btn;
            }
            self.accessoryView = _rightButton;
            break;
        case kCellTypeNone:
            self.accessoryView = nil;
            break;
            
        default:
            break;
    }
    
}

#pragma mark 设置cell所在的行号
- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    
    int count = [_myTableView numberOfRowsInSection:indexPath.section];
    if (count == 1) { // 这组只有1行
        _bg.image = [UIImage resizedImage:@"common_card_background.png"];
        _selectedBg.image = [UIImage resizedImage:@"common_card_background_highlighted.png"];
    } else if (indexPath.row == 0) { // 当前组的首行
        _bg.image = [UIImage resizedImage:@"common_card_top_background.png"];
        _selectedBg.image = [UIImage resizedImage:@"common_card_top_background_highlighted.png"];
    } else if (indexPath.row == count - 1) { // 当前组的末行
        _bg.image = [UIImage resizedImage:@"common_card_bottom_background.png"];
        _selectedBg.image = [UIImage resizedImage:@"common_card_bottom_background_highlighted.png"];
    } else { // 当前组的中间行
        _bg.image = [UIImage resizedImage:@"common_card_middle_background.png"];
        _selectedBg.image = [UIImage resizedImage:@"common_card_middle_background_highlighted.png"];
    }
}

@end
