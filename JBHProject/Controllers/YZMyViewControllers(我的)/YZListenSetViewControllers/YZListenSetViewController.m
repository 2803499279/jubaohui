//
//  YZListenSetViewController.m
//  JBHProject
//
//  Created by zyz on 2017/4/12.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "YZListenSetViewController.h"
#import "XHDatePickerView.h"
#import "NSDate+Extension.h"
#import "JHDataPackViewTableViewCell.h"
#import "POISearchViewController.h"
#import "HomeNetWorking.h"
@interface YZListenSetViewController ()<UITableViewDelegate,UITableViewDataSource,POISearchViewControllerDelegate>

@property(nonatomic, strong) UISwitch *OpenSwitch;
@property(nonatomic,strong)UISwitch * mySwitch;
@property(nonatomic,strong)UIView * sectionViewTop;
@property(nonatomic,strong)UIView * sectionViewCenter;
@property(nonatomic,strong)UIView * sectionViewBootm;
@property(nonatomic,strong)UITableView * tableView;// 显示时间的tableView
@property(nonatomic,strong)NSMutableArray * dataSources;// 时间源数据
@property(nonatomic,strong)NSMutableArray * tableCellArray;// 记录有几个时间
@property(nonatomic,strong)UILabel * messageLabel;
@property(nonatomic,strong)UIButton * saveButton;// 保存按钮
@property(nonatomic,strong)UIView * bottomView;//底部白色按钮
@property(nonatomic,copy)NSString * requestPoint;
@property(nonatomic,copy)NSString * requestAddress;
@end

@implementation YZListenSetViewController
- (instancetype)init
{
    if (self = [super init]) {
        _requestPoint = @"";
        _requestAddress = @"";
        _tableCellArray = [NSMutableArray array];
        _dataSources = [NSMutableArray array];
        // 默认时间
//        [_dataSources addObject:@[@"00:00",@"00:00"]];
//        [_dataSources addObject:@[@"00:00",@"00:00"]];
//        [_dataSources addObject:@[@"00:00",@"00:00"]];
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
    _isSaveButton = NO;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.messageLabel];
    self.messageLabel.hidden = YES;
    [self.view addSubview:self.bottomView];
    [self customPushViewControllerNavBarTitle:@"听单设置" backGroundImageName:nil];
    // 添加控件
    [self NetRequestUserInfo];
    [self getdata];
    
    [self customerGesturePop];
}

#pragma mark - Private Method 右划返回上一个页面
- (void)customerGesturePop {
    UISwipeGestureRecognizer *swipeGestuer2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleOtherSwipeGesture)];
    swipeGestuer2.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGestuer2];
}
- (void) handleOtherSwipeGesture {
    if ([self.RealName isEqualToString:@"实名认证"]) {
        // 返回根视图控制器
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else {
//        [self.navigationController popViewControllerAnimated:YES];
        [super goBack];
    }

}

- (void)goBack {
    if ([self.RealName isEqualToString:@"实名认证"]) {
        // 返回根视图控制器
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else {
//        [self.navigationController popViewControllerAnimated:YES];
        [super goBack];
    }
}

#pragma mark --------------- Action
- (void)sectionBtnClick:(UIButton *)sender
{
    if (sender.tag-1000 == 2) {
        POISearchViewController * vc = [[POISearchViewController alloc]init];
        vc.delegate = self;
        vc.locationPointStr = _requestPoint;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if(sender.tag-1000 == 1){
    if (self.tableCellArray.count < 3) {
        [self.tableCellArray addObject:@"添加一个新的时间组"];
        [_dataSources addObject:@[@"00:00",@"00:00"]];
        [self.tableView reloadData];
        }else if(self.tableCellArray.count==3)
        {
            self.messageLabel.hidden = NO;
        self.messageLabel.text = @"不好意思达到上限了";
            [self hidenMessage];
        }
    }
}
- (void)handleOpenSwitch:(UISwitch *)sender {
    // on 获取switch控件的当前状态
    switch ((int)sender.on) {
        case YES:
            
            DLog(@"开了");
            break;
        case NO:
            DLog(@"关了");
            break;
        default:
            break;
    }
}

- (void)dissMisMessageLabel
{
     [self NetRequestUserInfo];
}
- (void)showMessLabel{
    
     [UIView animateWithDuration:0.2 animations:^{
         
         self.messageLabel.hidden = 1;
         
     }];

}
- (void)hidenMessage
{
[self performSelector:@selector(dissMisMessageLabel) withObject:nil afterDelay:1.0];
}
- (void)showWaringMessLabel
{
    [self performSelector:@selector(showMessLabel) withObject:nil afterDelay:1.0];

}
- (void)saveBtnClick:(UIButton *)sender
{
    DLog(@"保存信息");
    _isSaveButton = YES;
    HomeNetWorking * manager = [HomeNetWorking sharedInstance];
    NSString * url = @"user/setting";
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[@"power"] = [NSString stringWithFormat:@"%d",self.OpenSwitch.on];
    dict[@"acc_power"] = [NSString stringWithFormat:@"%d",self.mySwitch.on];
//    NSMutableArray * array = [NSMutableArray array];
//    if (self.tableCellArray.count == 0) {
//        dict[@"time"] = @[];
//    }else{
//    for (int i = 0; i <self.tableCellArray.count; i++) {
//        NSString * str = [NSString stringWithFormat:@"%@,%@",[self.dataSources[i] objectAtIndex:0],[self.dataSources[i] objectAtIndex:1]];
//        [array addObject:str];
//    }
//    DLog(@"%@",array[0]);
////    dict[@"time"] = array;
//        
//    }
//    if (_requestPoint.length == 0||[_requestPoint isEqualToString:@"NIL"]) {
//         dict[@"point"] = [NSString stringWithFormat:@"%f %f",self.searchModel.selectedLocation.longitude,self.searchModel.selectedLocation.latitude];
//    }else
    if (_requestPoint == nil) {
        [MBProgressHUD showAutoMessage:@"请设置常住地址"];
    }
    dict[@"time"] = @[@"00:00,24:00"];
    dict[@"point"] = _requestPoint;
 
    dict[@"address"] = _requestAddress;
    
    [manager requestListenSetTaskPOSTWithURl:url Dictionary:dict Succes:^(id responsData) {
        DLog(@"请求成功");
        NSString * code = responsData[@"code"];
        if ([code integerValue] == 0) {
//        self.messageLabel.hidden = NO;
//        self.messageLabel.text = @"保存成功";
            LKRightBubble(@"保存设置成功", 2);
            [self NetRequestUserInfo];

//            [self dissMisMessageLabel];
//            [self performSelector:@selector(dissMisMessageLabel) withObject:nil afterDelay:2.f];
//        [self hidenMessage];
       
        // 更新之后 重新请求初始化数据进行保存
       
            
        }else if ([code integerValue] == 900102) {
            [MBProgressHUD showAutoMessage:@"登录信息失效"];
//            LKShowBubbleInfoWithTime([YZBubbleInfo StartBubbleTitle:@"登录信息失效" BubbleImage:@"YZPromptSubmit"], 1);
            
            YZLoginViewController * vc = [[YZLoginViewController alloc]init];
            YZUserInfoModel *model = [[YZUserInfoManager sharedManager] currentUserInfo];
            vc.AlertPhone = model.Usre_Phone;
            
            [[YZUserInfoManager sharedManager] didLoginOut];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([code integerValue] == 104001) {
            [MBProgressHUD showAutoMessage:@"听单状态无效"];
        }else if ([code integerValue] == 104004) {
            [MBProgressHUD showAutoMessage:@"常驻地址无效"];
        }else if ([code integerValue] == 104005) {
            [MBProgressHUD showAutoMessage:@"常驻地址无效"];
        }

    } failed:^(NSError *error) {
        DLog(@"请求失败");
    }];
}

#pragma mark ------------------- init
- (JHCustomPickView *)pickView
{
    if (_pickView == nil) {
        _pickView = [[JHCustomPickView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H-64)];
    }
    return _pickView;
}
- (UIView *)bottomView
{
    if (_bottomView == nil) {
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 539*YZAdapter, Screen_W, 68*YZAdapter)];
    _bottomView.backgroundColor = [UIColor whiteColor];
        
    [_bottomView addSubview:self.saveButton];
    }
    return _bottomView;

}
- (UIButton *)saveButton
{
    
    if (_saveButton == nil) {
        _saveButton = [[UIButton alloc]initWithFrame:CGRectMake(14*YZAdapter, 14*YZAdapter, Screen_W-28*YZAdapter, 42*YZAdapter)];
        _saveButton.backgroundColor = YZEssentialColor;
//        _saveButton.layer.cornerRadius = 5;
//        _saveButton.layer.masksToBounds = YES;
        [_saveButton setTitle:@"保存设置" forState:0];
        [_saveButton setTitleColor:YZEssentialColor forState:UIControlStateHighlighted];
        _saveButton.titleLabel.font = FONT(16);
        [_saveButton setBackgroundImage:[UIImage imageNamed:@"backGroundImg.png"] forState:UIControlStateHighlighted];
        [_saveButton addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
}
- (UILabel *)messageLabel
{
    if (_messageLabel == nil) {
        _messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(Screen_W/3*0.5, Screen_H - 200*YZAdapter, Screen_W*2/3, 40*YZAdapter)];
        _messageLabel.backgroundColor = [UIColor jhNavigationColor];
        _messageLabel.textColor = [UIColor whiteColor];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.layer.cornerRadius = 20*YZAdapter;
        _messageLabel.layer.masksToBounds = YES;
    }
    return _messageLabel;
}
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H-64) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[JHDataPackViewTableViewCell class] forCellReuseIdentifier:@"cellID"];
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}
- (UIView *)sectionViewTop
{
    if (_sectionViewTop ==nil) {
        _sectionViewTop = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 70*YZAdapter)];
        _sectionViewTop.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 20*YZAdapter,Screen_W, 50*YZAdapter)];
        bgView.backgroundColor = [UIColor whiteColor];
        UIImageView * iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(12*YZAdapter, 15*YZAdapter, 20*YZAdapter, 20*YZAdapter)];
        iconImage.image = [UIImage imageNamed:@"开启听单"];
//        iconImage.layer.cornerRadius = 8*YZAdapter;
//        iconImage.layer.masksToBounds = YES;
//        iconImage.backgroundColor = [UIColor jhSureGreen];
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(40*YZAdapter, 0,100*YZAdapter, 50*YZAdapter)];
        label.text = @"开启接单";
        label.textColor = MainFont_Color;
        label.font = FONT(16);

        [bgView addSubview:iconImage];
        [bgView addSubview:label];
        [_sectionViewTop addSubview:bgView];
        [_sectionViewTop addSubview:self.OpenSwitch];

    }
    return _sectionViewTop;
}
- (UIView *)sectionViewCenter
{
    if (_sectionViewCenter ==nil) {
        _sectionViewCenter = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 55*YZAdapter)];
        _sectionViewCenter.backgroundColor = [UIColor whiteColor];
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(40*YZAdapter, 8*YZAdapter,Screen_W, 15*YZAdapter)];
        label.text = @"开启精准模式";
        label.textColor = MainFont_Color;
        label.font = FONT(16);

        UILabel * desLabel = [[UILabel alloc]initWithFrame:CGRectMake(40*YZAdapter, 33*YZAdapter,Screen_W, 15*YZAdapter)];
        desLabel.text = @"根据位置为您进行优先派单";
        desLabel.textColor = [UIColor grayColor];
        desLabel.font = FONT(14);
        
        UIImageView * iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(12*YZAdapter, 15*YZAdapter, 20*YZAdapter, 20*YZAdapter)];
//        iconImage.layer.cornerRadius = 8*YZAdapter;
//        iconImage.layer.masksToBounds = YES;
//        iconImage.backgroundColor = [UIColor jhSureGreen];
        iconImage.image = [UIImage imageNamed:@"开启精准模式"];
        
//        UIButton * addButton = [[UIButton alloc]initWithFrame:CGRectMake(Screen_W - 50*YZAdapter, 13*YZAdapter, 25*YZAdapter, 25*YZAdapter)];
//        addButton.tag = 1001;
//        [addButton setImage:[UIImage imageNamed:@"添加"] forState:UIControlStateNormal];
//        [addButton addTarget:self action:@selector(sectionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_sectionViewCenter addSubview:label];
        [_sectionViewCenter addSubview:desLabel];
        [_sectionViewCenter addSubview:self.mySwitch];
        [_sectionViewCenter addSubview:iconImage];
//        [_sectionViewCenter addSubview:addButton];

    }
    return _sectionViewCenter;
}
- (UIView *)sectionViewBootm
{
    if (_sectionViewBootm ==nil) {
        _sectionViewBootm = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 50*YZAdapter)];
        _sectionViewBootm.backgroundColor = [UIColor whiteColor];
        
        UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 20*YZAdapter,Screen_W, 50*YZAdapter)];
        bgView.backgroundColor = [UIColor whiteColor];
        
        UIImageView * iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(12*YZAdapter, 15*YZAdapter, 20*YZAdapter, 20*YZAdapter)];
//        iconImage.layer.cornerRadius = 8*YZAdapter;
//        iconImage.layer.masksToBounds = YES;
//        iconImage.backgroundColor = [UIColor jhSureGreen];
        iconImage.image = [UIImage imageNamed:@"常驻地址"];
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(40*YZAdapter, 0,120*YZAdapter, 50*YZAdapter)];
        label.text = @"常驻地址";
        label.font = FONT(16);
        label.textColor = MainFont_Color;
        label.textAlignment = NSTextAlignmentLeft;
        UIButton * addButton = [[UIButton alloc]initWithFrame:CGRectMake(110*YZAdapter, 5*YZAdapter, Screen_W-120*YZAdapter, 40*YZAdapter)];
        [addButton setTitle:@"请选择" forState:0];
//        addButton.backgroundColor = [UIColor redColor];
        addButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        addButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20*YZAdapter);
        addButton.tag = 1002;
        [addButton setTitleColor:TimeFont_Color forState:0];
        addButton.titleLabel.font = FONT(14);
//        addButton.titleLabel.numberOfLines = 0;
        addButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        addButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        addButton.titleLabel.numberOfLines = 0;
        [addButton addTarget:self action:@selector(sectionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(addButton.frame.size.width+100*YZAdapter, 17*YZAdapter, 12*YZAdapter, 17*YZAdapter)];
        imageView.image = [UIImage imageNamed:@"fh"];
        
        [_sectionViewBootm addSubview:label];
        [_sectionViewBootm addSubview:addButton];
        [_sectionViewBootm addSubview:imageView];
        [_sectionViewBootm addSubview:iconImage];
    }
    return _sectionViewBootm;
}
- (UISwitch *)OpenSwitch
{
    if (_OpenSwitch == nil) {
        _OpenSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(Screen_W - 65*YZAdapter, 20*YZAdapter+8*YZAdapter, 40*YZAdapter, 12*YZAdapter)];
        //    // 配置控件内部的颜色
        _OpenSwitch.onTintColor = YZEssentialColor;
        // 给开关控件关联事件
        [_OpenSwitch addTarget:self action:@selector(handleOpenSwitch:) forControlEvents:(UIControlEventValueChanged)];

    }
    return _OpenSwitch;
}
- (UISwitch *)mySwitch
{
    if (_mySwitch == nil) {
        _mySwitch = [[UISwitch alloc]initWithFrame:CGRectMake(Screen_W - 65*YZAdapter , 12*YZAdapter, 45*YZAdapter, 20*YZAdapter)];
        //    // 配置控件内部的颜色
        _mySwitch.onTintColor = YZEssentialColor;
        // 给开关控件关联事件
        [_mySwitch addTarget:self action:@selector(handleOpenSwitch:) forControlEvents:(UIControlEventValueChanged)];
        
    }
    return _mySwitch;
}

#pragma mark -------------- UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (section == 1) {
//        return self.tableCellArray.count;
//    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 1) {
//
//    JHDataPackViewTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
//    if (cell == nil) {
//        cell = [[JHDataPackViewTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
//    }
//    NSArray * array = self.dataSources[indexPath.row];
//    cell.statrTimeLabel.text = [NSString stringWithFormat:@"从：%@",array[0]];
//    cell.endTimeLabel.text = [NSString stringWithFormat:@"到：%@",array[1]];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    self.tableView.separatorInset = UIEdgeInsetsZero;
//    cell.layoutMargins = UIEdgeInsetsZero;
//    return cell;
//    }
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
   
    switch (section) {
        case 0:
            return self.sectionViewTop;
            break;
        case 1:
            return self.sectionViewCenter;
//            return self.sectionViewBootm;
            break;
        case 2:
            return self.sectionViewBootm;
            break;
        default:
            break;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
//    if (section == 0) {
//        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, -10*YZAdapter, Screen_W, 10*YZAdapter)];
//        label.text = @"   听单偏好设置";
//        label.font = FONT(12);
//        label.textColor = TimeFont_Color;
//        label.backgroundColor = [UIColor groupTableViewBackgroundColor];
//        return label;
//    }else if (section == 1){
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 10*YZAdapter)];
        view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        return view;
//    }
//    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 1) {
////        return 50*YZAdapter;
//    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 65*YZAdapter;
    }
    else if(section == 1) {
        return 55*YZAdapter;
    }else {
        return 50*YZAdapter;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 20*YZAdapter;
    }
    else if(section == 1){
        return 20*YZAdapter;
    }
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 1) {
//
//        JHDataPackViewTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
//        self.pickView = [[JHCustomPickView alloc]initWithFrame:[UIScreen mainScreen].bounds];
//        self.pickView.controller = self;
//        
//        [self.view addSubview:self.pickView];
//        WeakSelf(self);
//        self.pickView.timeInfo = ^(NSMutableArray *timeArray){
//            
//            NSString * starStr = [timeArray[0] stringByReplacingOccurrencesOfString:@":" withString:@""];
//            NSString * endStr = [timeArray[1] stringByReplacingOccurrencesOfString:@":" withString:@""];
//            NSInteger path = [endStr integerValue]-[starStr integerValue];
//            if (path>0) {
//                cell.statrTimeLabel.text = [NSString stringWithFormat:@"   从：%@",timeArray[0]];
//                cell.endTimeLabel.text = [NSString stringWithFormat:@"到：%@",timeArray[1]];
//                [weakSelf.dataSources replaceObjectAtIndex:indexPath.row withObject:timeArray];
//                [weakSelf.pickView removeFromSuperview];
//            }else{
//                [weakSelf.pickView removeFromSuperview];
//                
//                weakSelf.messageLabel.text = @"结束时间小于开始时间";
//                [weakSelf showMessLabel];
//                [weakSelf hidenMessage];
//            }
//
//        };
//    }
    
}
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    UITableViewRowAction * myDeleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        // 删除操作
        [self.dataSources removeObjectAtIndex:indexPath.row];
        [self.tableCellArray removeObjectAtIndex:indexPath.row];
//        [self.dataSources replaceObjectAtIndex:indexPath.row withObject:@[@"00:00",@"00:00"]];
        [self.tableView reloadData];
    }];
    myDeleteRowAction.backgroundColor = LJHColor(215, 101, 100);
    
    return @[myDeleteRowAction];
}

#pragma mark--------------------POISearchViewControllerDelegate
- (void)POISearchViewcellSenderInfo:(POISearchModel *)model
{
    self.searchModel = model;
    UIButton * button = [self.sectionViewBootm viewWithTag:1002];
    [button setTitle:model.poiAddress forState:0];
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    button.titleLabel.numberOfLines = 0;
    _requestAddress = self.searchModel.poiAddress;
    _requestPoint = [NSString stringWithFormat:@"%f %f",self.searchModel.selectedLocation.longitude,self.searchModel.selectedLocation.latitude];
//    self.sectionViewBootm.size.height = []

}
#pragma mark ----------- Networking
- (HomeNetWorking *)manager
{
    if (_manager == nil) {
        _manager = [HomeNetWorking sharedInstance];
    }
    return _manager;
}
- (void)getdata{
    NSString *dicStartPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"startdic.txt"];
    NSDictionary *readDic = [NSDictionary dictionaryWithContentsOfFile:dicStartPath];
    HomeHeaderModel * model = [HomeHeaderModel HomeHeaderModelWith:readDic];
    UIButton * button = [self.sectionViewBootm viewWithTag:1002];
    [button setTitle:model.address forState:UIControlStateNormal];
    self.OpenSwitch.on = [model.power integerValue];
    self.mySwitch.on = [model.accPower integerValue];
//    NSUInteger count = model.time.count;
//    if (![model.point isEqualToString:@"0 0"]) {
//    if ([model.point isEqualToString:@"暂无数据"]) {
//        _requestPoint = @"";
//    }else{
//        _requestPoint = model.point;
//    }
//    }
    _requestAddress = model.address;
//    for (int index = 0; index < count ; index++) {
//        [self.tableCellArray addObject:@"添加一个新的时间组"];
//    }
//    for (int index = 0; index < count; index++) {
//        //            [self.dataSources replaceObjectAtIndex:index withObject:model.time[index]];
//        [self.dataSources insertObject:model.time[index] atIndex:index];
//    }
    [self.tableView reloadData];
//}else if ([code integerValue] == 900102) {
//    [MBProgressHUD showAutoMessage:@"登录信息失效"];
//    //            LKShowBubbleInfoWithTime([YZBubbleInfo StartBubbleTitle:@"登录信息失效" BubbleImage:@"YZPromptSubmit"], 1);
//    
//    [[YZUserInfoManager sharedManager] didLoginOut];
//    YZLoginViewController * vc = [[YZLoginViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
//}
}
- (void)NetRequestUserInfo
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    
    NSString * url = @"user/start";
    [self.manager requestUserInfoPOSTWithURl:url Dictionary:dict Succes:^(id responsData) {
        NSString * code = responsData[@"code"];
        if ([code integerValue] == 0){
            
        // 将重新拉取的初始化数据存储到数据库中
        // 创建要写入字典的对象
        NSString *dicStartPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"startdic.txt"];
        
        NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:responsData];
        
        NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:mDict[@"data"]];
        NSMutableDictionary *settingDic = [NSMutableDictionary dictionaryWithDictionary:dataDic[@"setting"]];
        
        [settingDic setObject:@"" forKey:@"time"];
        [dataDic setObject:settingDic forKey:@"setting"];
        [mDict setObject:dataDic forKey:@"data"];
        
        NSDictionary *StartDic = mDict;
            
        // 写入
        BOOL isSuc = [StartDic writeToFile:dicStartPath atomically:YES];
        DLog(@"%@", isSuc ? @"写入成功" : @"写入失败");
            
            
        DLog(@"获取用户初始信息---------------------------");
        HomeHeaderModel * model = [HomeHeaderModel HomeHeaderModelWith:responsData];
        UIButton * button = [self.sectionViewBootm viewWithTag:1002];
        [button setTitle:model.address forState:UIControlStateNormal];
//        self.OpenSwitch.on = [model.power integerValue];
//        NSUInteger count = model.time.count;
        if ([model.point isEqualToString:@"暂无数据"]) {
            _requestPoint = @"";
        }else{
        _requestPoint = model.point;
        }
        _requestAddress = model.address;
//        for (int index = 0; index < count ; index++) {
//            [self.tableCellArray addObject:@"添加一个新的时间组"];
//        }
//        for (int index = 0; index < count; index++) {
////            [self.dataSources replaceObjectAtIndex:index withObject:model.time[index]];
//            [self.dataSources insertObject:model.time[index] atIndex:index];
//        }
        DLog(@"初始化信息%@",responsData);
            if (_isSaveButton) {
            [UIView animateWithDuration:0.2 animations:^{
//                self.messageLabel.alpha = 0;
//                UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:[[ListeningList alloc] init]];
//                self.frostedViewController.contentViewController = navigationController;
                            [self goBack];
            }];
  }
//        [self.tableView reloadData];
        }else if ([code integerValue] == 900102) {
            [MBProgressHUD showAutoMessage:@"登录信息失效"];
//            LKShowBubbleInfoWithTime([YZBubbleInfo StartBubbleTitle:@"登录信息失效" BubbleImage:@"YZPromptSubmit"], 1);
            
            YZLoginViewController * vc = [[YZLoginViewController alloc]init];
            YZUserInfoModel *model = [[YZUserInfoManager sharedManager] currentUserInfo];
            vc.AlertPhone = model.Usre_Phone;
            
            [[YZUserInfoManager sharedManager] didLoginOut];
            vc.hidesBottomBarWhenPushed = YES;

            [self.navigationController pushViewController:vc animated:YES];
        }
    } failed:^(NSError *error) {
        DLog(@"---------------");
        DLog(@"%@",error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

