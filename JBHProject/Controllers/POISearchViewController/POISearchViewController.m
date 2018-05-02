//
//  POISearchViewController.m
//  JBHProject
//
//  Created by 李俊恒 on 2017/4/14.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "POISearchViewController.h"
#import "POISearchTableViewCell.h"
#import "POISearchModel.h"
#define POICELLID @"CellID"
@interface POISearchViewController ()<MAMapViewDelegate,AMapLocationManagerDelegate,AMapSearchDelegate,UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property(nonatomic,strong)MAMapView * mapView;// 地图
@property(nonatomic,strong)AMapSearchAPI * search;// 地图搜索API类
@property(nonatomic,copy)CLLocation * currentLocation;// 当前位置
@property(nonatomic,copy)MAPointAnnotation * destinationPoint;// 选中的位置MAPointAnnotation
@property(nonatomic,strong)MAPointAnnotation *pointAnnotation;// 当前位置的大头针
@property(nonatomic,copy)NSString * currentLocationStr;// 当前所在商户
@property(nonatomic,copy)NSString * currentAddressStr;// 当前位置的具体地址

@property(nonatomic,strong)UITableView * mapTableView;// 订单详情展示
@property(nonatomic,strong)NSMutableArray * mapDataSources;// 列表数据
@property(nonatomic,assign)BOOL isSelectecd;

//搜索
@property(nonatomic,strong)UISearchBar * searchBar;
@property(nonatomic,copy)NSString * searchInputText;// 搜索框的文字
@property(nonatomic,strong)NSMutableArray * inputSeacrchDatasources;// 搜索后的数据列表

@property(nonatomic,strong)UIView * bacKGroundView;// 灰色背景
@property(assign,nonatomic) NSIndexPath *selIndex;//单选，当前选中的行

@property(nonatomic,strong)UIImageView * pointImageView;// 大头针图片

@property(nonatomic,strong)UIButton * locationButton;
@property(nonatomic,strong)UIButton * saveButton;
@end

@implementation POISearchViewController
#pragma mark ------- lifecircle
//- (void)dealloc
//{
////    移除监听
////    [self.mapTableView removeObserver:self forKeyPath:@"contentOffset" context:nil];
//}
- (instancetype)init
{
    if (self = [super init]) {
        _isSelectedCell = NO;
        _currentLocation = [[CLLocation alloc]init];
        _destinationPoint = [[MAPointAnnotation alloc]init];
        _mapDataSources = [NSMutableArray array];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.tabBarController.tabBar.hidden = YES;
//    self.tabBarController.tabBar.translucent = YES;

}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    self.tabBarController.tabBar.hidden = NO;
//    self.tabBarController.tabBar.translucent = NO;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self customPushViewControllerNavBarTitle:@"设置常驻地址" backGroundImageName:nil];
    _isSelectecd = NO;
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self.mapView addSubview:self.pointImageView];

    [self.view addSubview:self.mapView];
    
    [self.view addSubview:self.locationButton];
    [self.view addSubview:self.mapTableView];
    [self.view addSubview:self.bacKGroundView];
    self.bacKGroundView.hidden = YES;
    [self.view addSubview:self.searchBar];
    [self customerGesturePop];
    [self addNavigationBarRightButton];
    
//#pragma mark =========监听tableVIew的偏移量
//    [self.mapTableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - Private Method 右划返回上一个页面
- (void)customerGesturePop {
    UISwipeGestureRecognizer *swipeGestuer2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleOtherSwipeGesture)];
    swipeGestuer2.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGestuer2];
}

- (void) handleOtherSwipeGesture {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark ------- init
- (void)addNavigationBarRightButton
{
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:self.saveButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (UIButton *)saveButton
{
    if (_saveButton == nil) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveButton setFrame:CGRectMake(0, 0, 50*Size_ratio, 30*Size_ratio)];
//        [_saveButton setBackgroundImage:[UIImage imageNamed:@"信息"] forState:0];
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
//        _saveButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        _saveButton.titleLabel.font = [UIFont systemFontOfSize:15*YZAdapter];
        [_saveButton setTitleColor:YZEssentialColor forState:UIControlStateNormal];
        [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_saveButton addTarget:self action:@selector(rightSaveBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
}

- (UIButton *)locationButton
{
    if (_locationButton == nil) {
        _locationButton = [[UIButton alloc]initWithFrame:CGRectMake(Screen_W-60*Size_ratio, self.mapView.frame.size.height-60*Size_ratio, 39*Size_ratio, 39*Size_ratio)];
        _locationButton.layer.cornerRadius = 19*Size_ratio;
        _locationButton.layer.masksToBounds = YES;
        _locationButton.backgroundColor = [UIColor whiteColor];
        [_locationButton setBackgroundImage:[UIImage imageNamed:@"punctuation"] forState:UIControlStateNormal];
        [_locationButton addTarget:self action:@selector(locationButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _locationButton;
}
- (UIView *)bacKGroundView
{
    if (_bacKGroundView == nil) {
        _bacKGroundView = [[UIView alloc]initWithFrame:CGRectMake(0,0, Screen_W, Screen_H-64)];
        _bacKGroundView.backgroundColor = [UIColor blackColor];
        _bacKGroundView.alpha = 0.5;
    }
    return _bacKGroundView;
}
- (UISearchBar *)searchBar {
    if (_searchBar == nil) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,0, Screen_W,50*Size_ratio)];
        _searchBar.placeholder = @"搜索地点";
        _searchBar.tintColor = YZEssentialColor;
        _searchBar.delegate = self;
        _searchBar.barStyle = UIBarStyleDefault;
            }
    return _searchBar;
}
- (UIImageView *)pointImageView
{
    if (_pointImageView == nil) {
        _pointImageView = [[UIImageView alloc]initWithFrame:CGRectMake(Screen_W*0.5-24*Size_ratio, (Screen_H*0.5 - 64*Size_ratio)*0.5-44*Size_ratio, 48*Size_ratio, 48*Size_ratio)];
        _pointImageView.image = [UIImage imageNamed:@"探针"];
    }
    return _pointImageView;
}
- (MAMapView *)mapView
{
    if (_mapView == nil) {
        [AMapServices sharedServices].enableHTTPS = YES;
        _mapView = [[MAMapView alloc]initWithFrame:CGRectMake(0, 50*Size_ratio, Screen_W, Screen_H*0.5)];
        _mapView.mapType = MAMapTypeStandard;
        _mapView.desiredAccuracy = kCLLocationAccuracyBest;
        _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_mapView setZoomLevel:(15.6f) animated:YES];
        _mapView.customizeUserLocationAccuracyCircleRepresentation = YES;
        _mapView.centerCoordinate = self.mapView.userLocation.coordinate;
        _mapView.pausesLocationUpdatesAutomatically = NO;
        _mapView.showsUserLocation = YES;
        _mapView.delegate = self;
        _mapView.userTrackingMode = MAUserTrackingModeFollow;
        _mapView.showsScale = YES;
        self.mapView.scaleOrigin = CGPointMake(10*Size_ratio, Screen_H*0.5-40);
        _mapView.rotateEnabled = NO;
        _mapView.showsCompass = NO;
        _isLocated = NO;
    }
    return _mapView;
}
- (AMapSearchAPI *)search
{
    if (_search == nil) {
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
        
    }
    return _search;
}
- (UITableView *)mapTableView
{
    if (_mapTableView == nil) {
        _mapTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Screen_H*0.5, Screen_W, Screen_H*0.5-64)];
        _mapTableView.delegate = self;
        _mapTableView.dataSource = self;
#pragma mark ------------ 上滑
        _recoginzerUp = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
        [_recoginzerUp setDirection:(UISwipeGestureRecognizerDirectionUp)];
        _recoginzerUp.delegate = self;
        [_mapTableView addGestureRecognizer:_recoginzerUp];
#pragma mark ------------- 下滑
        _recoginzerDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
        [_recoginzerDown setDirection:(UISwipeGestureRecognizerDirectionDown)];
        _recoginzerDown.delegate = self;

        [_mapTableView addGestureRecognizer:_recoginzerDown];
//        [_mapTableView registerClass:[POISearchTableViewCell class] forCellReuseIdentifier:POICELLID];
    }
    return _mapTableView;
}
#pragma mark --------- Action
- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    
    if(recognizer.direction == UISwipeGestureRecognizerDirectionDown) {
        DLog(@"swipe down");
        if (self.mapTableView.frame.origin.y == Screen_H*0.25) {
        [UIView animateWithDuration:0.5 animations:^{
            self.mapTableView.frame = CGRectMake(0, Screen_H*0.5, Screen_W, Screen_H*0.5-64);
            self.mapView.frame = CGRectMake(0, 50*Size_ratio, Screen_W, Screen_H*0.5);
            self.locationButton.frame = CGRectMake(Screen_W-60*Size_ratio, self.mapView.frame.size.height-45*Size_ratio, 39*Size_ratio, 39*Size_ratio);
            self.pointImageView.frame = CGRectMake(Screen_W*0.5-24*Size_ratio, (Screen_H*0.5 - 80*Size_ratio)*0.5, 48*Size_ratio, 48*Size_ratio);
            self.mapView.scaleOrigin = CGPointMake(10*Size_ratio, self.mapTableView.frame.origin.y-75);

        }];
        }
    }
    if(recognizer.direction == UISwipeGestureRecognizerDirectionUp) {
        DLog(@"swipe up");
        if (self.mapTableView.frame.origin.y==Screen_H*0.5) {
        [UIView animateWithDuration:0.5 animations:^{
            self.mapTableView.frame = CGRectMake(0*Size_ratio, Screen_H*0.25, Screen_W, Screen_H*0.75);
            self.mapView.frame = CGRectMake(0, 100*Size_ratio-Screen_H*0.25, Screen_W, Screen_H*0.5);

            self.locationButton.frame = CGRectMake(Screen_W-60*Size_ratio, Screen_H*0.25-45*Size_ratio, 39*Size_ratio, 39*Size_ratio);
            self.pointImageView.frame = CGRectMake(Screen_W*0.5-24*Size_ratio, (Screen_H*0.5-80*Size_ratio)*0.5, 48*Size_ratio, 48*Size_ratio);
            self.mapView.scaleOrigin = CGPointMake(10*Size_ratio,Screen_H*0.35-15);

        }];
        }
    }
}
// 解决tableView和手势的冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer.view isKindOfClass:[UITableView class]]) {
        return YES;
    }
    return NO;
}

- (void)rightSaveBarButtonClick:(UIButton *)sender
{
    if (_selIndex!=nil) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(POISearchViewcellSenderInfo:)]) {
            [self.delegate POISearchViewcellSenderInfo:_selectedModel];
        }
        [self goBack];
    }
}
- (void)locationButtonClick:(UIButton*)sender
{
 [self.mapView setCenterCoordinate:_currentLocation.coordinate];
//self.mapView.showsUserLocation = YES;
[self searchPOIRoundlocation:_currentLocation.coordinate];// 发起POIS搜索

}
- (void)searchBarAddressWithSearchText{
    
    AMapInputTipsSearchRequest *tips = [[AMapInputTipsSearchRequest alloc] init];
    tips.keywords = self.searchInputText;
    [self.search AMapInputTipsSearch:tips];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.searchBar resignFirstResponder];
    _isSelectecd  = NO;
}

// POI周边检索
- (void)searchPOIRoundlocation:(CLLocationCoordinate2D )location
{
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location                    = [AMapGeoPoint locationWithLatitude:location.latitude longitude:location.longitude];
    request.keywords                    = @"";
    request.sortrule                    = 0;
    request.requireExtension            = YES;
    request.radius                      = 1000;
    request.page                        = 0;
    request.offset                      = 50;
//    request.types                       = @"050000|060000|070000|080000|090000|100000|110000|120000|130000|140000|150000|160000|170000";
    request.types = @"汽车维修|摩托车服务|餐饮服务|购物服务|生活服务|体育休闲服务|医疗保健服务|汽车服务|汽车销售|住宿服务|商务住宅|政府机构及社会团体|科教文化服务|金融保险服务|公司企业";
    [self.search AMapPOIAroundSearch:request];
//    住宅区：120300
//    学校：141200
//    楼宇：120200
//    商场：060111
    AMapReGeocodeSearchRequest * request1 = [[AMapReGeocodeSearchRequest alloc]init];
    request.location = [AMapGeoPoint locationWithLatitude:location.latitude
                                                longitude:location.longitude];
    [self.search AMapReGoecodeSearch:request1];
}
// 反向地理编码
- (void)reGeoActionWith
{
    if (_destinationPoint) {
        AMapReGeocodeSearchRequest * request = [[AMapReGeocodeSearchRequest alloc]init];
        request.location = [AMapGeoPoint locationWithLatitude:_destinationPoint.coordinate.latitude
                                                    longitude:_destinationPoint.coordinate.longitude];
        [self.search AMapReGoecodeSearch:request];
    }
    
    
}

#pragma mark ---------MAMapViewDelegate
- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
        MACoordinateRegion  region;
        CLLocationCoordinate2D centerCoordinate = mapView.region.center;
        region.center= centerCoordinate;
    
    if (_pointAnnotation != nil) {
        // 清理
        [self.mapView removeAnnotation:_pointAnnotation];
        _pointAnnotation = nil;
    }
    _pointAnnotation = [[MAPointAnnotation alloc] init];

    _pointAnnotation.coordinate = region.center;
//    [self.mapView addAnnotation:_pointAnnotation];
    if(!_isSelectedCell){
    [self searchPOIRoundlocation:_pointAnnotation.coordinate];
    }
    AMapReGeocodeSearchRequest * request = [[AMapReGeocodeSearchRequest alloc]init];
    request.location = [AMapGeoPoint locationWithLatitude:_pointAnnotation.coordinate.latitude
                                                longitude:_pointAnnotation.coordinate.longitude];
    [self.search AMapReGoecodeSearch:request];
    _isSelectedCell = NO;
}
// 位置改变会调用此函数
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    /*
     * 第一次进入基于定位位置开启POI搜索
     */
    if(!updatingLocation)
        return ;
    
    if (userLocation.location.horizontalAccuracy < 0)
    {
        return ;
    }
    // only the first locate used.
    if (!self.isLocated)
    {
        self.isLocated = YES;
        if (self.locationPointStr.length!=0&&![self.locationPointStr isEqualToString:@"NIL"]){
            NSArray * pointArray = [self.locationPointStr componentsSeparatedByString:@" "];
            CLLocationCoordinate2D coordinated;
            coordinated.latitude = [pointArray[1] doubleValue];
            coordinated.longitude = [pointArray[0] doubleValue];
            [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(coordinated.latitude,coordinated.longitude)];
//            self.mapView.showsUserLocation = NO;
            [self searchPOIRoundlocation:coordinated];// 发起POIS搜索
            _currentLocation = [userLocation.location copy];

        }else{
        [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude)];
            _currentLocation = [userLocation.location copy];
//            self.mapView.showsUserLocation = YES;
            [self searchPOIRoundlocation:_currentLocation.coordinate];// 发起POIS搜索
            self.mapView.userTrackingMode = MAUserTrackingModeNone;
        }

    }
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
//
////    if ([annotation isKindOfClass:[MAPointAnnotation class]])
////    {
////        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
////        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
////        if (annotationView == nil)
////        {
////            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
////        }
////        annotationView.canShowCallout= NO;       //设置气泡可以弹出，默认为NO
////        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
////        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
//////        annotationView.pinColor = MAPinAnnotationColorGreen;
////        annotationView.animatesDrop = NO;
////        annotationView.image = self.pointImageView.image;
////        return nil;
////    }
    return nil;
}

#pragma mark ------AMapSearchDelegate
// 发起的POI搜索请求代理
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response{
    if (response.pois.count == 0){
        return;
    }
    if (!_isSelectedCell) {
        [_mapDataSources removeAllObjects];
    }
    _mapDataSources = [POISearchModel poiSearchModelWith:response];
//    POISearchModel * model = [POISearchModel poiModelWith:self.currentLocationStr address:self.currentAddressStr];
//    [_mapDataSources insertObject:model atIndex:0];
//    [self.mapTableView reloadData];
//    _selIndex = nil;
    [self.mapTableView reloadData];
}
- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response
{
    //解析response获取提示词，具体解析见 Demo
    if (_isSelectecd) {
    self.inputSeacrchDatasources = [POISearchModel poiInputModelWith:response];
    _bacKGroundView.hidden = YES;
    self.mapTableView.frame = CGRectMake(0, 20 + 50*Size_ratio, Screen_W, Screen_H - 50*Size_ratio - 20);
        _selIndex = nil;
    self.view.backgroundColor = [UIColor jhNavigationColor];
    [self.mapTableView reloadData];
    }
    DLog(@"解析demo");
//    DLog(@"尼玛");
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    DLog(@"Request:%@,error:%@",request,error);
    
}

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    
//    DLog(@"respone:%@",response);
    self.currentLocationStr = response.regeocode.addressComponent.city;
    self.currentAddressStr = response.regeocode.formattedAddress;
    NSString * title = response.regeocode.addressComponent.city;
    if (title.length == 0) {
        title = response.regeocode.addressComponent.province;
    }
    _destinationPoint.title = title;
    _destinationPoint.subtitle = response.regeocode.formattedAddress;
}
// 正向地理编码
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
{
    if (response.geocodes.count == 0)
    {
        return;
    }
    DLog(@"%@",response.geocodes);
    CLLocationCoordinate2D coordinate ;
    coordinate.latitude = [response.geocodes firstObject].location.latitude;
    coordinate.longitude = [response.geocodes firstObject].location.longitude;
    self.mapView.centerCoordinate = coordinate;
    
    //解析response获取地理信息，具体解析见 Demo
}
#pragma mark ----------- UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isSelectecd) {
        return self.inputSeacrchDatasources.count;
    }
    return _mapDataSources.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    POISearchTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:POICELLID];
//            if (cell == nil) {
//                cell = [[POISearchTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:POICELLID];
//            }
    static NSString * cellID = @"cellId";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        
    }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_selIndex == indexPath) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    POISearchModel * model;
    if (_isSelectecd) {
        model = self.inputSeacrchDatasources[indexPath.row];
    }else
    {
    model  = _mapDataSources[indexPath.row];
    }
    
    cell.textLabel.text = model.poiName;
    cell.detailTextLabel.text = model.poiAddress;
            return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 44*Size_ratio;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //之前选中的，取消选择
    UITableViewCell *celled = [tableView cellForRowAtIndexPath:_selIndex];
    celled.accessoryType = UITableViewCellAccessoryNone;
    //记录当前选中的位置索引
    _selIndex = indexPath;
    //当前选择的打勾
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
// 进行反地理编码插入大头针
    POISearchModel * model ;
    CLLocationCoordinate2D coordinate ;

    if (_isSelectecd) {
        model = self.inputSeacrchDatasources[indexPath.row];
        [UIView animateWithDuration:0.25 animations:^{
            self.navigationController.navigationBar.hidden = NO;
            self.mapTableView.frame = CGRectMake(0, Screen_H*0.5, Screen_W, Screen_H*0.5);
            
            self.mapView.frame = CGRectMake(0, 64+50*Size_ratio, Screen_W, Screen_H*0.5 - 64);
            
            self.searchBar.frame = CGRectMake(0, 64, Screen_W, 50*Size_ratio);
            self.searchBar.showsCancelButton  = NO;
            
            _bacKGroundView.hidden = YES;
            self.view.backgroundColor = [UIColor clearColor];
            
        }];
        [self.searchBar resignFirstResponder];
        _isSelectecd = NO;
        coordinate.latitude = model.selectedLocation.latitude;
        coordinate.longitude = model.selectedLocation.longitude;

    }
    else
    {
        // 点击选取位置
        _isSelectedCell = YES;
        model = self.mapDataSources[indexPath.row];
//        if (indexPath.row!=0) {
            coordinate.latitude = model.selectedLocation.latitude;
            coordinate.longitude = model.selectedLocation.longitude;
//        }else{
//            coordinate.latitude = _pointAnnotation.coordinate.latitude;
//            coordinate.longitude = _pointAnnotation.coordinate.longitude;
//        }
        
    }
#pragma mark --------- 地理编码
//    AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
//    geo.address = model.poiAddress;
//    geo.city = model.poiName;
//    [self.search AMapGeocodeSearch:geo];
    
    _pointAnnotation.coordinate = coordinate;
    [self.mapView addAnnotation:_pointAnnotation];
     self.mapView.centerCoordinate = coordinate;
    _selectedModel = model;
    
}
#pragma mark --------- cellTopHeaderViewDelegate
- (void)CellTopHeaderViewButton:(UIButton *)sender
{
    _isSelectecd = !_isSelectecd;
    if(_isSelectecd) {
        [UIView animateWithDuration:0.6 animations:^{
            self.mapTableView.frame = CGRectMake(0, Screen_H - 50*Size_ratio - 80*Size_ratio, Screen_W, Screen_H*0.5 - 80*Size_ratio);
            self.mapView.frame = CGRectMake(0, 64, Screen_W, Screen_H - 64*Size_ratio);
        }];
    }else {
        [UIView animateWithDuration:0.5 animations:^{
            self.mapTableView.frame = CGRectMake(10*Size_ratio, Screen_H*0.5, Screen_W-20*Size_ratio, Screen_H*0.5);
            
            self.mapView.frame = CGRectMake(0, 64+50*Size_ratio, Screen_W, Screen_H*0.5 - 64);
        }];
        
    }
    
}
#pragma mark ----------- UISearchControllerDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    self.view.backgroundColor = [UIColor clearColor];
    self.searchBar.text = @"";
    [UIView animateWithDuration:0.25 animations:^{
                [self.navigationController.navigationBar setTranslucent:YES];

        self.navigationController.navigationBar.hidden = YES;
        self.mapView.frame = CGRectMake(0, 50*Size_ratio, Screen_W, Screen_H*0.5-64);
        self.mapTableView.frame = CGRectMake(0, Screen_H*0.5, Screen_W, Screen_H*0.5-64);
        self.searchBar.frame = CGRectMake(0,20, Screen_W, 50*Size_ratio);
        self.searchBar.showsCancelButton  = YES;
        // 修改cancel为取消
        for(UIView *view in  [[[_searchBar subviews] objectAtIndex:0] subviews]) {
            if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
                UIButton * cancel =(UIButton *)view;
                [cancel setTitle:@"取消" forState:UIControlStateNormal];
            }
        }

        self.bacKGroundView.hidden = NO;

    }];
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    [UIView animateWithDuration:0.25 animations:^{
        self.navigationController.navigationBar.hidden = NO;
        self.mapTableView.frame = CGRectMake(0, Screen_H*0.5, Screen_W, Screen_H*0.5-64);
        
        self.mapView.frame = CGRectMake(0, 50*Size_ratio, Screen_W, Screen_H*0.5);

        self.searchBar.frame = CGRectMake(0, 0, Screen_W, 50*Size_ratio);
               _bacKGroundView.hidden = YES;
        self.searchBar.showsCancelButton  = NO;
        [self.navigationController.navigationBar setTranslucent:NO];
    }];
    return YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.searchBar.text = @"";
    [UIView animateWithDuration:0.25 animations:^{
        self.navigationController.navigationBar.hidden = NO;
        self.mapTableView.frame = CGRectMake(0, Screen_H*0.5, Screen_W, Screen_H*0.5-64);
        
//        self.mapView.frame = CGRectMake(0, 50*Size_ratio, Screen_W, Screen_H*0.5);
        
        self.searchBar.frame = CGRectMake(0, 0, Screen_W, 50*Size_ratio);
        self.searchBar.showsCancelButton  = NO;
        [self.navigationController.navigationBar setTranslucent:NO];
        _bacKGroundView.hidden = YES;
    }];
    [self.searchBar resignFirstResponder];
    _isSelectecd = NO;
    
}
//   编辑文字改变的回调
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    _isSelectecd = YES;
    self.searchInputText = searchText;

    [self searchBarAddressWithSearchText];
}
//搜索结果按钮点击的回调
- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar
{
    _isSelectecd = NO;
    [self searchBarAddressWithSearchText];
searchBar.text = @"";
    [self.searchBar resignFirstResponder];

}

@end