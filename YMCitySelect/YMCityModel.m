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
        _full_index = [aDecoder decodeObjectForKey:@"full_index"];
        _short_index = [aDecoder decodeObjectForKey:@"short_index"];
        _districts = [aDecoder decodeObjectForKey:@"districts"];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:_id forKey:@"id"];
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_full_index forKey:@"full_index"];
    
    [aCoder encodeObject:_short_index forKey:@"short_index"];
    [aCoder encodeObject:_districts forKey:@"districts"];
    
    
}

@end
