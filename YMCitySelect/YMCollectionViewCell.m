//代码地址：https://github.com/iosdeveloperSVIP/YMCitySelect
//原创：iosdeveloper赵依民
//邮箱：iosdeveloper@vip.163.com
//
//  YMCollectionViewCell.m
//  YMCitySelect
//
//  Created by mac on 16/4/24.
//  Copyright © 2016年 YiMin. All rights reserved.
//

#import "YMCollectionViewCell.h"
#import "UIView+ym_extension.h"

@implementation YMCollectionViewCell{
    UILabel *_ym_cityLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _ym_cityLabel = [[UILabel alloc] init];
        _ym_cityLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_ym_cityLabel];
        
        _ym_cityLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return self;
}
-(void)setTextColor:(UIColor *)textColor
{
    if(_textColor == textColor){
        return;
    }
    
    _textColor = textColor;
    _ym_cityLabel.textColor = _textColor;

    
    
}
-(void)setCity:(YMCityModel *)city{
    if ([city isKindOfClass:[NSString class]]) {
        city = [YMCityModel cityWithName:(NSString *)city];
    }
    
    _city = city;

    _ym_cityLabel.text = city.name;
    [_ym_cityLabel sizeToFit];
    if (_ym_cityLabel.ym_width > self.ym_width) {
        self.contentView.ym_width = _ym_cityLabel.ym_width + 15 ;
        self.ym_width = _ym_cityLabel.ym_width + 15 ;
    }
    _ym_cityLabel.center = self.contentView.center;
}

//-(void)setYm_cellWidth:(CGFloat)ym_cellWidth{
//    _ym_cellWidth = ym_cellWidth;
//    self.contentView.ym_width = ym_cellWidth;
//    self.ym_width = _ym_cellWidth;
//    _ym_cityLabel.center = self.contentView.center;
//}
-(void)layoutSubviews
{
    [super layoutSubviews];
    _ym_cityLabel.frame = self.bounds;
}
@end
