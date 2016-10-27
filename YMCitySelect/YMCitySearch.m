//代码地址：https://github.com/iosdeveloperSVIP/YMCitySelect
//原创：iosdeveloper赵依民
//邮箱：iosdeveloper@vip.163.com
//
//  YMCitySearch.m
//  YMCitySelect
//
//  Created by mac on 16/4/23.
//  Copyright © 2016年 YiMin. All rights reserved.
//

#import "YMCitySearch.h"
#import "YMCityModel.h"
#import "NSString+YM_Pinying.h"

@interface YMCitySearch ()

@end

@implementation YMCitySearch{
    NSMutableArray *_ym_resultArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self ym_setCitys];
    _ym_resultArray = [NSMutableArray array];
}

 

-(void)ym_setCitys{
    if (self.ym_cityArray) {
        
        NSMutableArray *array = [NSMutableArray array];
        
        [self.ym_cityArray enumerateObjectsUsingBlock:^(YMCityModel * city, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (city.full_index.length==0) {
                city.full_index = [city.name YM_Pinying_quanping];
            }
            
            if (city.short_index.length==0) {
                city.short_index = [city.name YM_Pinying_head];
            }
            
            [array addObject:city];
            
        }];
            
      
        _ym_cityArray = array ;
        
    }else{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"YMCitySelect.bundle/cities.plist" ofType:nil];
        NSArray *tempArray = [NSArray arrayWithContentsOfFile:path];
        _ym_cityArray = [NSMutableArray arrayWithCapacity:tempArray.count];
        [tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            YMCityModel *cityModel = [[YMCityModel alloc] init];
//            [cityModel setValuesForKeysWithDictionary:obj];
            cityModel.name = [obj objectForKey:@"name"];
            
            [_ym_cityArray addObject:cityModel];
            
        }];
    }
    
}

-(void)setYm_searchText:(NSString *)ym_searchText{
    _ym_searchText = ym_searchText;
    ym_searchText = [ym_searchText copy];
    ym_searchText = ym_searchText.lowercaseString;
    [_ym_resultArray removeAllObjects];
    for (YMCityModel *cityModel in _ym_cityArray) {
        if ([[cityModel.name lowercaseString] containsString:[ym_searchText lowercaseString]] || [[cityModel.full_index lowercaseString] containsString:[ym_searchText lowercaseString]] || [[cityModel.short_index lowercaseString] containsString:[ym_searchText lowercaseString]]) {
            [_ym_resultArray addObject:cityModel];
        }
    }
    [self.tableView reloadData];
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _ym_resultArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"ym_resultCitycell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    YMCityModel *cityModel = _ym_resultArray[indexPath.row];
    cell.textLabel.text = cityModel.name;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"有%zd个搜索结果",_ym_resultArray.count];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YMCityModel *cityModel = _ym_resultArray[indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ym_searchCityResult" object:nil userInfo:@{@"ym_searchCityResultKey": cityModel}];
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
