//代码地址：https://github.com/iosdeveloperSVIP/YMCitySelect
//原创：iosdeveloper赵依民
//邮箱：iosdeveloper@vip.163.com
//
//  YMTableViewCell.m
//  YMCitySelect
//
//  Created by mac on 16/4/24.
//  Copyright © 2016年 YiMin. All rights reserved.
//

#import "YMTableViewCell.h"
#import "UIView+ym_extension.h"
#import "YMCollectionViewCell.h"

@interface YMTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation YMTableViewCell{
    UICollectionView *_ym_collectionView;
    CGFloat ym_w;
}

static NSString *identifier = @"ym_collectionViewCell";
-(void)layoutSubviews
{
    [super layoutSubviews];
    
//    self.ym_width = [[UIApplication sharedApplication] keyWindow].bounds.size.width;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*)_ym_collectionView.collectionViewLayout;
    ym_w = ([[UIApplication sharedApplication] keyWindow].bounds.size.width - 72) / 3;
    CGFloat ym_h = ym_w / 3 + 10;
    layout.itemSize = CGSizeMake(ym_w, ym_h);
   
    _ym_collectionView.frame = CGRectMake(0, 0, self.ym_width - 27, self.ym_height) ;

    [_ym_collectionView reloadData];
    
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.ym_width = [[UIApplication sharedApplication] keyWindow].bounds.size.width;
        
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        self.backgroundColor =[UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1.0];
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        ym_w = ([[UIApplication sharedApplication] keyWindow].bounds.size.width - 72) / 3;
        
        CGFloat ym_h = ym_w / 3;
        layout.itemSize = CGSizeMake(ym_w, ym_h);
        layout.sectionInset = UIEdgeInsetsMake(15, 15, 0, 0);
        layout.minimumLineSpacing = 15;
        _ym_collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.ym_width - 27, self.ym_height) collectionViewLayout:layout];
        [_ym_collectionView registerClass:[YMCollectionViewCell
                                           class] forCellWithReuseIdentifier:identifier];
        _ym_collectionView.delegate = self;
        _ym_collectionView.dataSource = self;
        _ym_collectionView.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1.0];
        _ym_collectionView.scrollEnabled = NO;
        [self.contentView addSubview:_ym_collectionView];
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
        self.layer.drawsAsynchronously = YES;
        //注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ym_setReloadData) name:@"ym_locationReloadData" object:nil];
    }
    return  self;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.citys.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YMCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.city = self.citys[indexPath.item];
    cell.textColor = self.textColor;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YMCityModel *cityObj = self.citys[indexPath.item];
    if ([cityObj.name hasPrefix:@"定位失败"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ym_updateLocation" object:nil];
        YMCollectionViewCell *cell = (YMCollectionViewCell *)[_ym_collectionView cellForItemAtIndexPath:indexPath];
        
        YMCityModel *city = [[YMCityModel alloc] init];
        city.name = @"正在定位中...";
        cell.city = city ;
        cell.ym_cellWidth = ym_w;
        return;
    }
    if ([cityObj.name isEqualToString:@"正在定位中..."]) {
        return;
    }
    
    
    if ([self.ym_cellDelegate respondsToSelector:@selector(ymcollectionView:didSelectItemAtCity :)]) {
        
        
        [self.ym_cellDelegate ymcollectionView:collectionView didSelectItemAtCity :cityObj ];
        
        
        
    }
}

-(void)setCitys:(NSArray *)citys{
    _citys = citys;
    [_ym_collectionView reloadData];
}

-(void)setYm_cellHeight:(CGFloat)ym_cellHeight{
    _ym_cellHeight = ym_cellHeight;
    _ym_collectionView.ym_height = _ym_cellHeight;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}


- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor lightGrayColor];
}
- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
}

-(void)ym_setReloadData{
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
    YMCollectionViewCell *cell = (YMCollectionViewCell *)[_ym_collectionView cellForItemAtIndexPath:index];
    cell.city = self.citys[index.row];
    
    YMCityModel *city = self.citys[index.row];
    if (![city.name hasPrefix:@"定位失败"]) {
        cell.ym_cellWidth = ym_w;
    }
}


@end
