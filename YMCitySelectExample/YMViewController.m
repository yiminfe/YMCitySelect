//
//  YMViewController.m
//  YMCitySelect
//
//  Created by mac on 16/4/23.
//  Copyright © 2016年 YiMin. All rights reserved.
//

#import "YMViewController.h"
#import "YMCitySelect.h"
#import "UIView+ym_extension.h"

@interface YMViewController ()<YMCitySelectDelegate>

@end

@implementation YMViewController{
    UILabel *_cityLabel;
}

///测试旧工程 对 autolay 的约束效果,无效,求 bug
-(void)addConstraint
{
    {
        //        return;
        //        UIView *view =  _ym_searchBar;
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(20, 300, 200, 200)];
        view.backgroundColor = [UIColor redColor];
        
        [self.view addSubview:view];
        
        
        view.translatesAutoresizingMaskIntoConstraints = NO;
        self.view .translatesAutoresizingMaskIntoConstraints = NO;
        
        
        
        
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
                                      constant:-50];
        
        
        NSLayoutConstraint *leftC =
        [NSLayoutConstraint constraintWithItem:view
                                     attribute:NSLayoutAttributeLeft
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.view
                                     attribute:NSLayoutAttributeLeft
                                    multiplier:1
                                      constant:50];
        NSLayoutConstraint *rightC =
        [NSLayoutConstraint constraintWithItem:view
                                     attribute:NSLayoutAttributeRight
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.view
                                     attribute:NSLayoutAttributeRight
                                    multiplier:1
                                      constant:50];
        
        
        
        NSLayoutConstraint *topC =
        [NSLayoutConstraint constraintWithItem:view
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.view
                                     attribute:NSLayoutAttributeTop
                                    multiplier:1
                                      constant:100];
        
        
        
        [self.view addConstraints:@[ leftC,widthC,topC,heightC ]];
        [NSLayoutConstraint activateConstraints:@[ leftC,widthC,topC,heightC ]];
        
        //        heightC.active = YES;
        //        topC.active = YES;
        //        leftC.active = YES;
        //        rightC.active = YES;
        //        widthC.active = YES;
        
        
        return;
        ///约束失败
        //
        
        //        [NSLayoutConstraint activateConstraints:@[ leftC,rightC ,widthC ]];
        
        
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addConstraint];
    
    self.title = @"选择城市";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *cityBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 94, 100, 30)];
    cityBtn.ym_centerX = self.view.ym_centerX;
    [cityBtn setTitle:@"请选择城市" forState:UIControlStateNormal];
    [cityBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cityBtn.backgroundColor = [UIColor grayColor];
    [cityBtn addTarget:self action:@selector(cityBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cityBtn];
    _cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 100, 30)];
    _cityLabel.ym_centerX = self.view.ym_centerX;
    _cityLabel.text = @"北京";
    _cityLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_cityLabel];
    
    UIButton *clearBtn = [[UIButton alloc] init];
    [clearBtn setTitle:@"清理缓存" forState:UIControlStateNormal];
    [clearBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [clearBtn sizeToFit];
    clearBtn.center = self.view.center;
    [self.view addSubview:clearBtn];
    [clearBtn addTarget:self action:@selector(clearBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
}

-(void)cityBtnClick:(UIButton *)btn{
    YMCitySelect *cityVC =  [[YMCitySelect alloc] initWithDelegate:self];
    {
        //手动传入
        NSMutableArray *cityGroupArray = [NSMutableArray array ];
        
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"YMCitySelect.bundle/cityGroups.plist" ofType:nil];
        NSArray *tempArray = [NSArray arrayWithContentsOfFile:path];
        
        
        //手动传入
        NSMutableArray *cityArray = [NSMutableArray arrayWithCapacity:tempArray.count];
        NSMutableArray *_ym_ctiyGroups = [NSMutableArray arrayWithCapacity:tempArray.count];
        
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
        
        cityVC.getGroupBlock = ^NSArray*(void){
            return _ym_ctiyGroups;
            
        };

        
        
    }
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:cityVC] animated:YES completion:nil];
}

-(void)clearBtnClick{
    NSUserDefaults *clear = [NSUserDefaults standardUserDefaults];
    [clear removeObjectForKey:@"ym_cityNames_new"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)ym_ymCitySelectCity:(YMCityModel *)city {
    _cityLabel.text = city.name;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
