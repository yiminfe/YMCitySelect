//代码地址：https://github.com/iosdeveloperSVIP/YMCitySelect
//原创：iosdeveloper赵依民
//邮箱：iosdeveloper@vip.163.com
//
//  YMCollectionViewCell.h
//  YMCitySelect
//
//  Created by mac on 16/4/24.
//  Copyright © 2016年 YiMin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMCityModel.h"

@interface YMCollectionViewCell : UICollectionViewCell

@property (nonatomic,copy) YMCityModel *city;

@property (nonatomic,assign) CGFloat ym_cellWidth;
@property (strong,nonatomic) UIColor *textColor;

@end
