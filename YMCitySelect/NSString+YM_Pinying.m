//
//  YM_Pinying.m
//  YMCitySelect
//
//  Created by tim on 16/9/21.
//  Copyright © 2016年 YiMin. All rights reserved.
//

#import "NSString+YM_Pinying.h"

@implementation NSString(YM_Pinying)
//chengdu
-(NSString *)YM_Pinying_quanping{
    NSMutableString *mutableString = [NSMutableString stringWithString:self];
    // Boolean CFStringTransform(CFMutableStringRef string, CFRange *range, CFStringRef transform, Boolean reverse);
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false); // 汉字转成拼音(不知道为什么英文是拉丁语的意思)
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformStripDiacritics, false); // 去掉音调
    
    [mutableString replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, mutableString.length)];
    
    
    return mutableString;
    
}

///CD
-(NSString *)YM_Pinying_head
{
    NSMutableString *mutableString = [NSMutableString stringWithString:self];
    // Boolean CFStringTransform(CFMutableStringRef string, CFRange *range, CFStringRef transform, Boolean reverse);
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false); // 汉字转成拼音(不知道为什么英文是拉丁语的意思)
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformStripDiacritics, false); // 去掉音调
    
    NSArray *py_array = [mutableString componentsSeparatedByString:@" " ];
    NSMutableArray *array= [NSMutableArray array ];
    [py_array enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [array addObject:[obj substringToIndex:1]];
        
    }];
    
    
    return [array componentsJoinedByString:@""];
    
    return self;
    
}

@end
