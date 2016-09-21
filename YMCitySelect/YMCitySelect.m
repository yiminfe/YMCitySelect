//代码地址：https://github.com/iosdeveloperSVIP/YMCitySelect
//原创：iosdeveloper赵依民
//邮箱：iosdeveloper@vip.163.com
//
//  YMCitySelect.m
//  YMCitySelect
//
//  Created by mac on 16/4/23.
//  Copyright © 2016年 YiMin. All rights reserved.
//

#import "YMCitySelect.h"
#import "YMCitySearch.h"
#import "YMSearchBar.h"
#import "UIView+ym_extension.h"
#import "YMCityGroupsModel.h"
#import "YMTableViewCell.h"
#import <CoreLocation/CoreLocation.h>

@interface YMCitySelect ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,YMTableViewCellDelegate>
@property (nonatomic,strong) NSMutableArray *ym_cityNames;
@property (nonatomic,strong) YMCitySearch *ym_citySearch;

@end

@implementation YMCitySelect{
    YMSearchBar *_ym_searchBar;
    UITableView *_ym_tableView;
    UIButton *_ym_cover;
    UILabel *_ym_selectCity;
    UIView *_ym_navView;
    NSMutableArray *_ym_ctiyGroups;
    NSUserDefaults *_ym_userDefaults;
    CLLocationManager *_ym_locationManager;
    UIButton *_ym_locationCityName;
    NSMutableArray *_ym_locationcityArry;
}

static NSString *reuseIdentifier = @"ym_cellTwo";

-(NSMutableArray *)ym_cityNames{
    if (!_ym_cityNames) {
        _ym_cityNames = [NSMutableArray array];
    }
    return _ym_cityNames;
}

-(YMCitySearch *)ym_citySearch{
    if (!_ym_citySearch) {
                YMCitySearch *ym_citySearchCtrl = [YMCitySearch new];
                ym_citySearchCtrl.getGroupBlock = self.getGroupBlock;

                [self addChildViewController:ym_citySearchCtrl];
                [self.view addSubview:ym_citySearchCtrl.view];
        ym_citySearchCtrl.view.frame = CGRectMake(0, 64, self.view.ym_width, self.view.ym_height - 64);
                _ym_citySearch = ym_citySearchCtrl;
            }
            return _ym_citySearch;
}

-(instancetype)initWithDelegate:(id)targe{
    self = [super init];
    if (self) {
        self.ymDelegate = targe;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self ym_setSearchBar];
    [self ym_setNavView];
    [self ym_setCityGroups];
    [self ym_setCityNames];
    [self ym_setTableView];
    [self ym_setLocationManager];
    [self ym_setcationCityName];
    
     
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ym_setLocationManager) name:@"ym_updateLocation" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ym_setSearchCityResult:) name:@"ym_searchCityResult" object:nil];
}

-(void)ym_setSearchBar{
    _ym_searchBar = [[YMSearchBar alloc] initWithFrame:CGRectMake(0, 44, self.view.ym_width, 64)];
    _ym_searchBar.placeholder = @"请输入城市名/拼音/首字母拼音";
    _ym_searchBar.delegate = self;
    [self.view addSubview:_ym_searchBar];

    
    
    NSLayoutConstraint *topC = [NSLayoutConstraint constraintWithItem:_ym_searchBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *leftC = [NSLayoutConstraint constraintWithItem:_ym_searchBar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    NSLayoutConstraint *rightC = [NSLayoutConstraint constraintWithItem:_ym_searchBar attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0];
//    NSLayoutConstraint *heightC = [NSLayoutConstraint constraintWithItem:_ym_searchBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:64];
    
//    [_ym_searchBar addConstraints:@[topC,leftC,rightC ]];
    
    
    
}

-(void)ym_setNavView{
    _ym_navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    _ym_navView.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 63.5, _ym_navView.ym_width, 0.5)];
    lineView.backgroundColor = [UIColor colorWithRed:171.0/255.0 green:172.0/255.0 blue:171.0/255.0 alpha:1.0];
    [_ym_navView addSubview:lineView];
    UIButton *closeBtn = [[UIButton alloc] init];
    if (self.closeBtnImage) {
        [closeBtn setImage:self.closeBtnImage forState:UIControlStateNormal];
//        [closeBtn setImage:self.closeBtnImage forState:UIControlStateHighlighted];
        
    }else{
        [closeBtn setImage:[UIImage imageNamed:@"YMCitySelect.bundle/btn_navigation_close_hl"] forState:UIControlStateNormal];
        [closeBtn setImage:[UIImage imageNamed:@"YMCitySelect.bundle/btn_navigation_close"] forState:UIControlStateHighlighted];
        
    }
    
    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn sizeToFit];
    closeBtn.ym_x = 5;
    closeBtn.ym_centerY = _ym_navView.ym_centerY + 10;
    [_ym_navView addSubview:closeBtn];
    _ym_selectCity = [[UILabel alloc] init];
    _ym_selectCity.text = @"选择城市";
    _ym_selectCity.font = [UIFont fontWithName:@"HelVetica-Bold" size:16];
    _ym_selectCity.textColor = [UIColor blackColor];
    [_ym_selectCity sizeToFit];
    _ym_selectCity.ym_centerX = _ym_navView.ym_centerX;
    _ym_selectCity.ym_centerY = _ym_navView.ym_centerY + 10;
    [_ym_navView addSubview:_ym_selectCity];
    [self.view addSubview:_ym_navView];
}

-(void)closeBtnClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)ym_setCityGroups{
    
    if (self.getGroupBlock) {
        _ym_ctiyGroups = self.getGroupBlock().mutableCopy;
        
    }else{
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"YMCitySelect.bundle/cityGroups.plist" ofType:nil];
        NSArray *tempArray = [NSArray arrayWithContentsOfFile:path];
        _ym_ctiyGroups = [NSMutableArray arrayWithCapacity:tempArray.count];
        [tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            YMCityGroupsModel *cityGroupModel = [[YMCityGroupsModel alloc] init];
//            [cityGroupModel setValuesForKeysWithDictionary:obj];
            cityGroupModel.title = [obj objectForKey:@"title"];
            
            
            NSArray *array = [obj objectForKey:@"cities"];
            NSMutableArray *cities = [NSMutableArray array];
            for (NSDictionary *info in array ) {
                
                YMCityModel *city = [[YMCityModel alloc] init];;
                if([info isKindOfClass:[NSDictionary class]]){
                    [city setValuesForKeysWithDictionary:info];
                    
                }else if([info isKindOfClass:[NSString class]]){
                    city.name = (NSString*)info;
                    
                }
                
                [cities addObject:city];
            }
            cityGroupModel.cities = cities;
            
            [_ym_ctiyGroups addObject:cityGroupModel];
            
        }];
        
    }
    
}
-(void)ym_setCityNames{
    [self setUpCityNames];
    if (self.ym_cityNames.count) {
        YMCityGroupsModel *ymcityGroupsModel = [[YMCityGroupsModel alloc] init];
        ymcityGroupsModel.title = @"最近";
        ymcityGroupsModel.cities = self.ym_cityNames;
        
        YMCityModel *lastCity = ymcityGroupsModel.cities[0];
        _ym_selectCity.text = [NSString stringWithFormat:@"当前城市-%@",lastCity.name ];
        [_ym_selectCity sizeToFit];
        _ym_selectCity.ym_centerX = _ym_navView.ym_centerX;
        
        for (YMCityGroupsModel *tempModel in _ym_ctiyGroups) {
            if ([tempModel.title isEqualToString: ymcityGroupsModel.title]) {
                tempModel.cities = ymcityGroupsModel.cities;
                return;
            }
        }
        if (_ym_locationcityArry) {
            [_ym_ctiyGroups insertObject:ymcityGroupsModel atIndex:1];
        }else{
            [_ym_ctiyGroups insertObject:ymcityGroupsModel atIndex:0];
        }
    }
}

-(void)ym_setTableView{
    _ym_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_ym_searchBar.frame), self.view.ym_width, self.view.ym_height - CGRectGetMaxY(_ym_searchBar.frame))];
    _ym_tableView.delegate = self;
    _ym_tableView.dataSource = self;
    _ym_tableView.tintColor = [UIColor blackColor];
    [_ym_tableView registerClass:[YMTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
    [self.view addSubview:_ym_tableView];
    
    
    if (self.sectionIndexColor) {
        _ym_tableView.sectionIndexColor = self.sectionIndexColor ;
    }
    
    
    if([_ym_tableView respondsToSelector:@selector(setSectionIndexColor:)]) {
        _ym_tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        _ym_tableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
         
        
    }
}

-(void)ym_setLocationManager{
    _ym_locationManager = [CLLocationManager new];
    if ([_ym_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [_ym_locationManager requestWhenInUseAuthorization];
    }
    _ym_locationManager.delegate = self;
    [_ym_locationManager startUpdatingLocation];
}

-(void)ym_setcationCityName{
    YMCityGroupsModel *ymcityGroupsModel = [[YMCityGroupsModel alloc] init];
    ymcityGroupsModel.title = @"定位";
    _ym_locationcityArry = [NSMutableArray array];
    [_ym_locationcityArry addObject:[YMCityModel cityWithName:@"正在定位中..."]];
    ymcityGroupsModel.cities = _ym_locationcityArry;
    [_ym_ctiyGroups insertObject:ymcityGroupsModel atIndex:0];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    if (_ym_cover) {
        _ym_cover.alpha = 0;
    }
    [self ym_setCover];
    [UIView animateWithDuration:0.5 animations:^{
        _ym_navView.ym_y = -64;
        _ym_searchBar.ym_y = 0;
        _ym_tableView.ym_y = 64;
        _ym_tableView.ym_height = self.view.ym_height - 64;
        _ym_cover.frame = _ym_tableView.frame;
        [_ym_searchBar setShowsCancelButton:YES animated:YES];
        
    } completion:^(BOOL finished) {
        _ym_navView.hidden = YES;
    }];
}

-(void)ym_setCover{
    if (!_ym_cover) {
        _ym_cover = [[UIButton alloc] init];
        _ym_cover.backgroundColor = [UIColor blackColor];
        [_ym_cover addTarget:self action:@selector(ym_coverClick) forControlEvents:UIControlEventTouchUpInside];
        _ym_cover.frame = _ym_tableView.frame;
        [self.view addSubview:_ym_cover];
    }
    _ym_cover.hidden = NO;
    _ym_cover.alpha = 0.5;
}

-(void)ym_coverClick{
    [self ym_cancelBtnClick];
}

#pragma mark searchBar取消按钮调用
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = nil;
    self.ym_citySearch.view.hidden = YES;
    
    
    [self ym_cancelBtnClick];
    
}

-(void)ym_cancelBtnClick{
    _ym_navView.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        _ym_cover.hidden = YES;
        _ym_navView.ym_y = 0;
        _ym_searchBar.ym_y = 44;
        [_ym_searchBar setShowsCancelButton:NO animated:YES];
        _ym_tableView.ym_y = CGRectGetMaxY(_ym_searchBar.frame);
        _ym_tableView.ym_height = self.view.ym_height - _ym_tableView.ym_y;
        _ym_cover.frame = _ym_tableView.frame;
    }completion:^(BOOL finished) {
        _ym_cover.hidden = YES;
    }];
    [_ym_searchBar resignFirstResponder];
}

#pragma mark searchBar编辑的时候调用
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length) {
        self.ym_citySearch.view.hidden = NO;
        self.ym_citySearch.ym_searchText = searchText;
    } else {
        self.ym_citySearch.view.hidden = YES;
    }
}

#pragma mark - UITableView的数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _ym_ctiyGroups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    YMCityGroupsModel *cityGroupModel = _ym_ctiyGroups[section];
    if (cityGroupModel.title.length > 1) {
        return 1;
    }
    return cityGroupModel.cities.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"ym_cell";
    YMCityGroupsModel *cityGroupModel = _ym_ctiyGroups[indexPath.section];
    UITableViewCell *cell;
    if (cityGroupModel.title.length  > 1) {
        YMTableViewCell *ym_cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        ym_cell.citys = cityGroupModel.cities;
        ym_cell.ym_cellHeight = [self ym_setcellHeightForRowAtIndexPath:indexPath];
        ym_cell.ym_cellDelegate = self;
        return ym_cell;
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        }
        
        YMCityModel *city = cityGroupModel.cities[indexPath.row];;
        cell.textLabel.text = city.name;
        
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    YMCityGroupsModel *model = _ym_ctiyGroups[section];
    return model.title;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return [_ym_ctiyGroups valueForKeyPath:@"title"];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *ym_view = [[UIView alloc] init];
    
    if( self.tableSectionBackColor ){
        ym_view.backgroundColor = self.tableSectionBackColor;
        
    }else{
        ym_view.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0];
        
    }
    UILabel *ym_label = [[UILabel alloc] init];
    ym_label.textAlignment = NSTextAlignmentLeft;
    if( self.tableSectionTextColor ){
         ym_label.textColor =self.tableSectionTextColor;

    }else{
        ym_label.textColor = [UIColor blackColor];

    }
    
    ym_label.font = [UIFont systemFontOfSize:16];
    YMCityGroupsModel *cityGroupModel = _ym_ctiyGroups[section];
    NSString *ym_title = cityGroupModel.title;
    if ([cityGroupModel.title isEqualToString:@"热门"]) {
        ym_title = @"中国热门城市";
    }
    if ([cityGroupModel.title isEqualToString:@"最近"]) {
        ym_title = @"最近选择过的城市";
    }
    if ([cityGroupModel.title isEqualToString:@"定位"]) {
        ym_title = @"定位的城市";
    }
    ym_label.text = ym_title;
    [ym_label sizeToFit];
    ym_label.ym_x = 10;
    ym_label.ym_y = 5;
    [ym_view addSubview:ym_label];
    return ym_view;
}

#pragma mark - 选中cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YMCityGroupsModel *model = _ym_ctiyGroups[indexPath.section];
    YMCityModel *cityObj =  model.cities[indexPath.row];
    [self ym_setSelectCity:cityObj];
}

#pragma mark YMTableViewCell自定义的代理方法
-(void)ymcollectionView:(UICollectionView *)collectionView didSelectItemAtCity:(YMCityModel *)city
{
    
    [self ym_setSelectCity:city];
}

#pragma mark 搜索城市的结果返回
-(void)ym_setSearchCityResult:(NSNotification *)noti{
    YMCityModel *city = noti.userInfo[@"ym_searchCityResultKey"];
    [self ym_setSelectCity:city];
}

#pragma mark 保存最近城市逻辑判断
-(void)ym_setSelectCity:(YMCityModel *)city
{
    if ([self.ymDelegate respondsToSelector:@selector(ym_ymCitySelectCity:)]) {
        [self.ymDelegate ym_ymCitySelectCity:city];
    }
    NSMutableArray *tempCitys = [NSMutableArray array];
    for (YMCityModel *tempCity  in self.ym_cityNames) {
        if ([tempCity.name isEqualToString:city.name]) {
            [tempCitys addObject:tempCity];
        }
    }
    
    
    [self.ym_cityNames removeObjectsInArray:tempCitys];
    if (self.ym_cityNames.count == 3) {
        [self.ym_cityNames removeLastObject];
    }
    [self.ym_cityNames insertObject:city atIndex:0];
    [self addSaveCityNames];
    if (!_ym_citySearch) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark - UITableView的代理方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self ym_setcellHeightForRowAtIndexPath:indexPath];
}

-(CGFloat)ym_setcellHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat ym_height = 44;
    YMCityGroupsModel *cityGroupModel = _ym_ctiyGroups[indexPath.section];
   CGFloat ym_w = ([UIScreen mainScreen].bounds.size.width - 72) / 3;
    CGFloat ym_h = ym_w / 3;
    if (cityGroupModel.title.length > 1) {
        NSInteger count = cityGroupModel.cities.count;
            ym_height = (count / 3 + (count % 3 == 0?0:1)) * (ym_h + 15) + 15;
    }
    return ym_height;
}

#pragma mark - 保存最近城市到偏好设置
-(void)addSaveCityNames{
    [_ym_userDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:_ym_cityNames] forKey:@"ym_cityNames"];
    [_ym_userDefaults synchronize];
    [self ym_setCityNames];
    [_ym_tableView reloadData];
}

#pragma mark 获取最近城市
-(void)setUpCityNames{
    if (!_ym_userDefaults) {
        _ym_userDefaults = [NSUserDefaults standardUserDefaults];
    }
    self.ym_cityNames = [[NSKeyedUnarchiver unarchiveObjectWithData:[_ym_userDefaults objectForKey:@"ym_cityNames"]] mutableCopy];
}

#pragma mark 城市定位
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *ym_location =[locations firstObject];
    [_ym_locationManager stopUpdatingLocation];
    CLGeocoder *geocoder = [CLGeocoder new];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:ym_location.coordinate.latitude longitude:ym_location.coordinate.longitude];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count == 0 || error) {
            _ym_locationcityArry[0] = [YMCityModel cityWithName:@"定位失败，请点击重试"];
        }
        else{
            CLPlacemark *placemark = placemarks.lastObject;
            if (placemark.locality) {
                NSString * cityName = [placemark.locality substringWithRange:NSMakeRange(0, [placemark.locality length] - 1)];
                _ym_locationcityArry[0] = cityName;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ym_locationReloadData" object:nil];
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ym_locationReloadData" object:nil];
    }];

}

@end
