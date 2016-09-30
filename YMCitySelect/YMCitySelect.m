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
///最近
@property (nonatomic,strong) NSMutableArray *ym_cityNames;
@property (nonatomic,strong) YMCitySearch *ym_citySearch;

@end

@implementation YMCitySelect{
    YMSearchBar *_ym_searchBar;
    UITableView *_ym_tableView;
    UIButton *_ym_cover;
   // UILabel *_ym_selectCity;
//    UIView *_ym_navView;
    
    ///分组城市
    NSMutableArray *_ym_ctiyGroups;
    ///全部城市,
    NSMutableArray *_ym_allCtiys;
    
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

-(NSMutableArray *)ym_allCtiys{
    if (!_ym_allCtiys) {
        NSArray *group = _ym_ctiyGroups;
        
        _ym_allCtiys = [NSMutableArray array];
        for (YMCityGroupsModel *groupObj in group) {
            if (groupObj.cities == _ym_locationcityArry) {
                
            }else if ([groupObj.title isEqualToString:@"热门"]) {
                
            }
            else if ([groupObj.title isEqualToString:@"最近"]) {
                
            }
            else{
                [_ym_allCtiys addObjectsFromArray:groupObj.cities];
                
            }
            
        }
        
    }
    return _ym_allCtiys;
}

-(YMCitySearch *)ym_citySearch{
    if (!_ym_citySearch) {
                YMCitySearch *ym_citySearchCtrl = [YMCitySearch new];
                ym_citySearchCtrl.ym_cityArray = [self ym_allCtiys];

                [self addChildViewController:ym_citySearchCtrl];
                [self.view addSubview:ym_citySearchCtrl.view];
                ym_citySearchCtrl.view.frame = CGRectMake(0, 64, self.view.ym_width, self.view.ym_height - 64);
                _ym_citySearch = ym_citySearchCtrl;
        //约束
        {
            
            UIView *view =  _ym_citySearch.view;
            
            [self.view addSubview:view];
            
            
            view.translatesAutoresizingMaskIntoConstraints = NO;
            //        self.view .translatesAutoresizingMaskIntoConstraints = NO;
            
            
           
            
            
            NSLayoutConstraint *leftC =
            [NSLayoutConstraint constraintWithItem:view
                                         attribute:NSLayoutAttributeLeft
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:self.view
                                         attribute:NSLayoutAttributeLeft
                                        multiplier:1
                                          constant:0];
            NSLayoutConstraint *rightC =
            [NSLayoutConstraint constraintWithItem:view
                                         attribute:NSLayoutAttributeRight
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:self.view
                                         attribute:NSLayoutAttributeRight
                                        multiplier:1
                                          constant:0];
            
            
            
            NSLayoutConstraint *topC =
            [NSLayoutConstraint constraintWithItem:view
                                         attribute:NSLayoutAttributeTop
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:_ym_searchBar
                                         attribute:NSLayoutAttributeBottom
                                        multiplier:1
                                          constant:0];
            
            
            NSLayoutConstraint *bottomC =
            [NSLayoutConstraint constraintWithItem:view
                                         attribute:NSLayoutAttributeBottom
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:self.view
                                         attribute:NSLayoutAttributeBottom
                                        multiplier:1
                                          constant:0];
            
            
            bottomC.active = YES;
            topC.active = YES;
            leftC.active = YES;
            rightC.active = YES;
            
            
            ///约束
            [self.view addConstraints:@[ topC,leftC,rightC,bottomC ]];
            
            
            
            
        }
        
            }
    
            return _ym_citySearch;
    
}

-(instancetype)initWithDelegate:(id)targe{
    self = [super init];
    if (self) {
        self.ymDelegate = targe;
        self.textColor = [UIColor blackColor];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self ym_setNavView];
    [self ym_setSearchBar];
    [self ym_setTableView];

    [self ym_setCityGroups];
    [self ym_setCityNames];

    [self ym_setLocationManager];
    [self ym_setcationCityName];
    
    [self addConstraint];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ym_setLocationManager) name:@"ym_updateLocation" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ym_setSearchCityResult:) name:@"ym_searchCityResult" object:nil];
}



-(void)ym_setSearchBar{
    _ym_searchBar = [[YMSearchBar alloc] initWithFrame:CGRectMake(0, 44, self.view.ym_width, 64)];
    _ym_searchBar.placeholder = @"请输入城市名/拼音/首字母拼音";
    _ym_searchBar.delegate = self;
    
    [self.view addSubview:_ym_searchBar];

    
    
}

-(void)ym_setNavView{
  
    
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    if (self.closeBtnImage) {
        [closeBtn setImage:self.closeBtnImage forState:UIControlStateNormal];
//        [closeBtn setImage:self.closeBtnImage forState:UIControlStateHighlighted];
        
    }else{
        [closeBtn setImage:[[UIImage imageNamed:@"YMCitySelect.bundle/btn_navigation_close_hl"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [closeBtn setImage:[[UIImage imageNamed:@"YMCitySelect.bundle/btn_navigation_close"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateHighlighted];
        
    }
    
    if (self.closeBtnAct && self.closeBtnOwner ) {
        [closeBtn addTarget:self.closeBtnOwner action:self.closeBtnAct forControlEvents:UIControlEventTouchUpInside];

    }else{
        [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];

    }
    
    
    [closeBtn sizeToFit];
    closeBtn.ym_x = 5;
    
    
//    closeBtn.backgroundColor = [UIColor redColor];
    
    
    
    self.navigationItem.title  = @"选择城市";
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithCustomView:closeBtn];
    
    
    self.navigationController.navigationBar.translucent = NO;
    
    
    
}

-(void)closeBtnClick{
    if (self.navigationController) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];

    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    
    
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
        self.navigationItem.title  = [NSString stringWithFormat:@"当前城市-%@",lastCity.name ];
        
        
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
-(void)addConstraint
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //search
    {
 
        UIView *view =  _ym_searchBar;
    
        [self.view addSubview:view];
        
        
        view.translatesAutoresizingMaskIntoConstraints = NO;
//        self.view .translatesAutoresizingMaskIntoConstraints = NO;
       
        
        NSLayoutConstraint *heightC =
        [NSLayoutConstraint constraintWithItem:view
                                     attribute:NSLayoutAttributeHeight
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:nil
                                     attribute:NSLayoutAttributeNotAnAttribute
                                    multiplier:1
                                      constant:44];
        NSLayoutConstraint *widthC =
        [NSLayoutConstraint constraintWithItem:view
                                     attribute:NSLayoutAttributeWidth
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.view
                                     attribute:NSLayoutAttributeWidth
                                    multiplier:1
                                      constant:0];

        
        NSLayoutConstraint *leftC =
        [NSLayoutConstraint constraintWithItem:view
                                     attribute:NSLayoutAttributeLeft
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.view
                                     attribute:NSLayoutAttributeLeft
                                    multiplier:1
                                      constant:0];
        NSLayoutConstraint *rightC =
        [NSLayoutConstraint constraintWithItem:view
                                     attribute:NSLayoutAttributeRight
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.view
                                     attribute:NSLayoutAttributeRight
                                    multiplier:1
                                      constant:0];
        
        
        
        NSLayoutConstraint *topC =
        [NSLayoutConstraint constraintWithItem:view
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.view
                                     attribute:NSLayoutAttributeTop
                                    multiplier:1
                                      constant:0];
        
        
        
        
        heightC.active = YES;
        topC.active = YES;
        leftC.active = YES;
        rightC.active = YES;
        widthC.active = YES;
        
        
        ///约束
        [self.view addConstraints:@[ topC,leftC,rightC ]];
        
    
     

    }
    //TABLE
    {
        
        UIView *view =  _ym_tableView;
        
        [self.view addSubview:view];
        
        
        view.translatesAutoresizingMaskIntoConstraints = NO;
        //        self.view .translatesAutoresizingMaskIntoConstraints = NO;
        
        
      
        
        
        NSLayoutConstraint *leftC =
        [NSLayoutConstraint constraintWithItem:view
                                     attribute:NSLayoutAttributeLeft
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.view
                                     attribute:NSLayoutAttributeLeft
                                    multiplier:1
                                      constant:0];
        NSLayoutConstraint *rightC =
        [NSLayoutConstraint constraintWithItem:view
                                     attribute:NSLayoutAttributeRight
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.view
                                     attribute:NSLayoutAttributeRight
                                    multiplier:1
                                      constant:0];
        
        
        
        NSLayoutConstraint *topC =
        [NSLayoutConstraint constraintWithItem:view
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:_ym_searchBar
                                     attribute:NSLayoutAttributeBottom
                                    multiplier:1
                                      constant:0];
        
        
        
        NSLayoutConstraint *bottomC =
        [NSLayoutConstraint constraintWithItem:view
                                     attribute:NSLayoutAttributeBottom
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.view
                                     attribute:NSLayoutAttributeBottom
                                    multiplier:1
                                      constant:0];
        leftC.active = YES;
        rightC.active = YES;
        
        topC.active = YES;
        bottomC.active = YES;
        
        
        ///约束
        [self.view addConstraints:@[ topC,leftC,rightC,bottomC ]];
        
        
        
        
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
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSString *string = nil;
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
        {
            string = @"用户还未决定授权";
            break;
        }
        case kCLAuthorizationStatusRestricted:
        {
            string =@"访问受限";
            break;
        }
        case kCLAuthorizationStatusDenied:
        {
            // 类方法，判断是否开启定位服务
            if ([CLLocationManager locationServicesEnabled]) {
                string =@"定位服务开启，被拒绝" ;
            } else {
                string =@"定位服务关闭，不可用";
            }
            break;
        }
        case kCLAuthorizationStatusAuthorizedAlways:
        {
            NSLog(@"获得前后台授权");
            break;
        }
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        {
            NSLog(@"获得前台授权");
            break;
        }
        default:
            break;
    }
    
    if (string ) {
        
        _ym_locationcityArry[0] = [YMCityModel cityWithName:[NSString stringWithFormat:@"定位失败:%@",string]];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ym_locationReloadData" object:nil];
        
    }
    
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
    //    _ym_navView.ym_y = -64;
//        _ym_searchBar.ym_y = 0;
//        _ym_tableView.ym_y = 64;
//        _ym_tableView.ym_height = self.view.ym_height - 64;
        _ym_cover.frame = _ym_tableView.frame;
        [_ym_searchBar setShowsCancelButton:YES animated:YES];
        
    } completion:^(BOOL finished) {
//        _ym_navView.hidden = YES;
    }];
}

-(void)ym_setCover{
    if (!_ym_cover) {
        _ym_cover = [[UIButton alloc] init];
        _ym_cover.backgroundColor = [UIColor blackColor];
        [_ym_cover addTarget:self action:@selector(ym_coverClick) forControlEvents:UIControlEventTouchUpInside];
        _ym_cover.frame = _ym_tableView.frame;
        [self.view addSubview:_ym_cover];
        
        {
            //约束
            {
                
                UIView *view =  _ym_cover;
                
                [self.view addSubview:view];
                
                
                view.translatesAutoresizingMaskIntoConstraints = NO;
                //        self.view .translatesAutoresizingMaskIntoConstraints = NO;
                
                
                
                
                
                NSLayoutConstraint *leftC =
                [NSLayoutConstraint constraintWithItem:view
                                             attribute:NSLayoutAttributeLeft
                                             relatedBy:NSLayoutRelationEqual
                                                toItem:self.view
                                             attribute:NSLayoutAttributeLeft
                                            multiplier:1
                                              constant:0];
                NSLayoutConstraint *rightC =
                [NSLayoutConstraint constraintWithItem:view
                                             attribute:NSLayoutAttributeRight
                                             relatedBy:NSLayoutRelationEqual
                                                toItem:self.view
                                             attribute:NSLayoutAttributeRight
                                            multiplier:1
                                              constant:0];
                
                
                
                NSLayoutConstraint *topC =
                [NSLayoutConstraint constraintWithItem:view
                                             attribute:NSLayoutAttributeTop
                                             relatedBy:NSLayoutRelationEqual
                                                toItem:_ym_searchBar
                                             attribute:NSLayoutAttributeBottom
                                            multiplier:1
                                              constant:0];
                
                
                NSLayoutConstraint *bottomC =
                [NSLayoutConstraint constraintWithItem:view
                                             attribute:NSLayoutAttributeBottom
                                             relatedBy:NSLayoutRelationEqual
                                                toItem:self.view
                                             attribute:NSLayoutAttributeBottom
                                            multiplier:1
                                              constant:0];
                
                
                bottomC.active = YES;
                topC.active = YES;
                leftC.active = YES;
                rightC.active = YES;
                
                
                ///约束
                [self.view addConstraints:@[ topC,leftC,rightC,bottomC ]];
                
                
                
                
            }
        }
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
    
    NSLog(@"----%@",NSStringFromSelector(_cmd));
    
    
    [self ym_cancelBtnClick];

    
    _ym_citySearch.view.hidden = YES;
    
    _ym_searchBar.text = nil;
    
    
}

-(void)ym_cancelBtnClick{
    
//    [UIView animateWithDuration:0.5 animations:^{
//        _ym_cover.hidden = YES;
//        [_ym_searchBar setShowsCancelButton:NO animated:YES];
//        _ym_cover.frame = _ym_tableView.frame;
//    }completion:^(BOOL finished) {
//        _ym_cover.hidden = YES;
//    }];
    
    
    _ym_cover.hidden = YES;
    [_ym_searchBar setShowsCancelButton:NO animated:YES];
    
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
        
        ym_cell.textColor = self.textColor;
       
        return ym_cell;
        
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
            cell.textLabel.textColor = self.textColor;
            
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
    
    ///LOCATION
    if ([_ym_locationcityArry containsObject:city]) {
        ///find out
        YMCityModel *orgCity = nil;
        for (YMCityModel *city0 in [self ym_allCtiys]) {
            if ([city0.name isEqualToString:city.name]) {
                orgCity = city0 ;
                break;
            }
        }
        
        ///找到的城市对象
        if(orgCity){
            [self ym_setSelectCity:orgCity];
            
        }else{
            _ym_searchBar.text = city.name;
            [_ym_searchBar becomeFirstResponder];
            
        }
       
        
    }else{
        
        ///
        [self ym_setSelectCity:city];
        
    }
    
    
    
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
   CGFloat ym_w = ([[UIApplication sharedApplication] keyWindow].bounds.size.width - 72) / 3;
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
    
    NSData *data = [_ym_userDefaults objectForKey:@"ym_cityNames"];
    ///兼容之前的 strign
    if(data && ![data isKindOfClass:[NSArray class]]){
        self.ym_cityNames = [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];

    }else{
            [_ym_userDefaults removeObjectForKey:@"ym_cityNames"];
    }
    
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
                
                YMCityModel *cityModel = [YMCityModel cityWithName:cityName];
                
                _ym_locationcityArry[0] = cityModel;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ym_locationReloadData" object:nil];
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ym_locationReloadData" object:nil];
    }];

}
#pragma mark 旋转
- (BOOL)shouldAutorotate {
    return  YES;
}

//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    return self.topViewController.supportedInterfaceOrientations;
//}
//
//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return self.topViewController.preferredStatusBarStyle;
//}

@end
