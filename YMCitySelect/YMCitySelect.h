//代码地址：https://github.com/iosdeveloperSVIP/YMCitySelect
//原创：iosdeveloper赵依民
//邮箱：iosdeveloper@vip.163.com
//
//  YMCitySelect.h
//  YMCitySelect
//
//  Created by mac on 16/4/23.
//  Copyright © 2016年 YiMin. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "YMCityModel.h"
#import "YMCityGroupsModel.h"


@protocol YMCitySelectDelegate <NSObject>

- (void)ym_ymCitySelectCity:(YMCityModel *)city;

@end


typedef  NSArray<YMCityGroupsModel *>*(^GetDataSourceBlock)(void) ;


@interface YMCitySelect : UIViewController

-(instancetype)initWithDelegate:(id)targe;

@property (nonatomic,weak) id<YMCitySelectDelegate> ymDelegate;

///获取城市数据
@property (copy,nonatomic) GetDataSourceBlock getGroupBlock;



@end
