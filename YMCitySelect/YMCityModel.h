//代码地址：https://github.com/iosdeveloperSVIP/YMCitySelect
//原创：iosdeveloper赵依民
//邮箱：iosdeveloper@vip.163.com
//
//  YMCityModel.h
//  YMCitySelect
//
//  Created by mac on 16/4/25.
//  Copyright © 2016年 YiMin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMCityModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *pinYin;

@property (nonatomic, copy) NSString *pinYinHead;

@property (nonatomic, strong) NSArray *districts;

@end
