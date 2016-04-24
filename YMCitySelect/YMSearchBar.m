//代码地址：https://github.com/iosdeveloperSVIP/YMCitySelect
//原创：iosdeveloper赵依民
//邮箱：iosdeveloper@vip.163.com
//
//  YMSearchBar.m
//  YMCitySelect
//
//  Created by mac on 16/4/24.
//  Copyright © 2016年 YiMin. All rights reserved.
//

#import "YMSearchBar.h"
#import "UIView+ym_extension.h"

@implementation YMSearchBar

-(void)layoutSubviews{
    [super layoutSubviews];
    for (UIView *view in self.subviews) {
        for (UIView *tempView in view.subviews) {
            if ([tempView isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
                tempView.ym_y = 28;
            }
            if ([tempView isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
                UIButton *ym_btn = (UIButton *)tempView;
                [ym_btn setTitle:@"取消" forState:UIControlStateNormal];
                [ym_btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                ym_btn.ym_y = 26;
            }
        }
    }
}

@end
