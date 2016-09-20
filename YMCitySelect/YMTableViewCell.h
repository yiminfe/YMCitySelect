//代码地址：https://github.com/iosdeveloperSVIP/YMCitySelect
//原创：iosdeveloper赵依民
//邮箱：iosdeveloper@vip.163.com
//
//  YMTableViewCell.h
//  YMCitySelect
//
//  Created by mac on 16/4/24.
//  Copyright © 2016年 YiMin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMCityModel.h"

@protocol YMTableViewCellDelegate <NSObject>

-(void)ymcollectionView:(UICollectionView *)collectionView didSelectItemAtCity :(YMCityModel *)city ;

@end

@interface YMTableViewCell : UITableViewCell

@property (nonatomic,strong) NSArray *citys;

@property (nonatomic,assign) CGFloat ym_cellHeight;

@property (nonatomic,weak) id<YMTableViewCellDelegate> ym_cellDelegate;

@end
