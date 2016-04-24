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

@protocol YMCitySelectDelegate <NSObject>

- (void)ym_ymCitySelectCityName:(NSString *)cityName;

@end

@interface YMCitySelect : UIViewController

-(instancetype)initWithDelegate:(id)targe;

@property (nonatomic,weak) id<YMCitySelectDelegate> ymDelegate;

@end
