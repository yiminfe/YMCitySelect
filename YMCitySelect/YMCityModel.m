//代码地址：https://github.com/iosdeveloperSVIP/YMCitySelect
//原创：iosdeveloper赵依民
//邮箱：iosdeveloper@vip.163.com
//
//  YMCityModel.m
//  YMCitySelect
//
//  Created by mac on 16/4/25.
//  Copyright © 2016年 YiMin. All rights reserved.
//

#import "YMCityModel.h"

@implementation YMCityModel

+(instancetype)cityWithName:(NSString *)name
{
    YMCityModel *obj = [[YMCityModel alloc] init];
    obj.name = name;
    
    return obj;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self == [super init]) {
        _id = [aDecoder decodeObjectForKey:@"id"];
        _name = [aDecoder decodeObjectForKey:@"name"];
        _pinYin = [aDecoder decodeObjectForKey:@"pinYin"];
        _pinYinHead = [aDecoder decodeObjectForKey:@"pinYinHead"];
        _districts = [aDecoder decodeObjectForKey:@"districts"];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:_id forKey:@"id"];
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_pinYin forKey:@"pinYin"];
    
    [aCoder encodeObject:_pinYinHead forKey:@"pinYinHead"];
    [aCoder encodeObject:_districts forKey:@"districts"];
    
    
}

@end
