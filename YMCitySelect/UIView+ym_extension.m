//代码地址：https://github.com/iosdeveloperSVIP/YMCitySelect
//原创：iosdeveloper赵依民
//邮箱：iosdeveloper@vip.163.com
//
//  UIView+ym_extension.m
//  YMChannelSwitching
//
//  Created by mac on 16/4/20.
//  Copyright © 2016年 YiMin. All rights reserved.
//

#import "UIView+ym_extension.h"

@implementation UIView (ym_extension)

-(void)setYm_x:(CGFloat)ym_x
{
    CGRect frame = self.frame;
    frame.origin.x = ym_x;
    self.frame = frame;
}

-(CGFloat)ym_x
{
    return self.frame.origin.x;
}

-(void)setYm_y:(CGFloat)ym_y
{
    CGRect frame = self.frame;
    frame.origin.y = ym_y;
    self.frame = frame;
}

-(CGFloat)ym_y
{
    return self.frame.origin.y;
}

-(void)setYm_width:(CGFloat)ym_width{
    CGRect frame = self.frame;
    frame.size.width = ym_width;
    self.frame = frame;
}

-(CGFloat)ym_width
{
    return self.frame.size.width;
}

-(void)setYm_height:(CGFloat)ym_height
{
    CGRect frame = self.frame;
    frame.size.height = ym_height;
    self.frame = frame;
}

-(CGFloat)ym_height
{
    return self.frame.size.height;
}

-(void)setYm_centerX:(CGFloat)ym_centerX
{
    CGPoint tempP =self.center;
    tempP.x = ym_centerX;
    self.center = tempP;
}
 
-(CGFloat)ym_centerX
{
    return self.center.x;
}

-(void)setYm_centerY:(CGFloat)ym_centerY
{
    CGPoint tempP = self.center;
    tempP.y = ym_centerY;
    self.center = tempP;
}

-(CGFloat)ym_centerY
{
    return self.center.y;
}

-(void)setYm_size:(CGSize)ym_size
{
    CGRect frame = self.frame;
    frame.size = ym_size;
    self.frame = frame;
}

-(CGSize)ym_size
{
    return self.frame.size;
}



@end
