//
//  YZCancelInvestigateController.m
//  JBHProject
//
//  Created by zyz on 2017/11/7.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "YZCancelInvestigateController.h"
#import "YZCancelInvCell.h"
#import "YZPlaceholderTextView.h"
#import "YZHomePageResquest.h"

@interface YZCancelInvestigateController ()<UITableViewDataSource,UITableViewDelegate, UITextViewDelegate>{
    UITableView *table;
    NSMutableArray *dataArray;
    NSMutableDictionary *dic;
}
@property (nonatomic, strong) YZPlaceholderTextView *YZPlaceholderView;  // 其他情况说明填写视图
@property(nonatomic,strong) NSIndexPath *lastPath;
@property(nonatomic,strong) YZCancelInvCell *cell;
@property(nonatomic,strong) NSString *CancelID;
@end

@implementation YZCancelInvestigateController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BackGround_Color;
    // 设置导航栏
    [self customPushViewControllerNavBarTitle:@"取消勘查" backGroundImageName:nil];

    [self WALLET_LOGRequest];
    
//    NSArray *arrAndDict = @[
//                            @{@"indexTitle": @"抢错单了",@"isCollect": @"0"},
//                            @{@"indexTitle": @"时间太紧",@"isCollect": @"0"},
//                            @{@"indexTitle": @"出现交通意外",@"isCollect": @"0"},
//                            @{@"indexTitle": @"路况出现问题",@"isCollect": @"0"},
//                            @{@"indexTitle": @"其他原因",@"isCollect": @"0"}
//                            ];
//    dataArray = [[NSMutableArray alloc] initWithArray:arrAndDict];
    
    dataArray =  [[NSMutableArray alloc] initWithCapacity:0];
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H)];
    table.backgroundColor = [UIColor clearColor];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.delegate = self;
    table.dataSource = self;
    
    table.tableHeaderView = [self topView];

    table.showsVerticalScrollIndicator = NO;
    table.separatorStyle = UITableViewCellSelectionStyleNone;
    
    [self.view addSubview:table];
    // 添加提交按钮
    [self boomView];
    //收起键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    //监听键盘出现和消失
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    //注册通知 接受推送数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UserInfoNotification:) name:@"CancelInv" object:nil];
    
    // 右划返回上一个页面
    [self customerGesturePop];
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


// 底部提交按钮
- (void)boomView {
    
    UIView *PView = [[UIView alloc] initWithFrame:CGRectMake(0, Screen_H-69*YZAdapter-64, Screen_W, 1*YZAdapter)];
    PView.backgroundColor = LightLine_Color;
    [self.view addSubview:PView];
    
    UIView *PhoneView = [[UIView alloc] initWithFrame:CGRectMake(0, Screen_H-68*YZAdapter-64, Screen_W, 68*YZAdapter)];
    PhoneView.backgroundColor = BackGround_Color;
    
    
    UIButton *ExitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [ExitBtn  setExclusiveTouch :YES];
    ExitBtn.tintColor = [UIColor whiteColor];
    ExitBtn.frame = CGRectMake(14*YZAdapter, 14*YZAdapter, Screen_W-28*YZAdapter, 42*YZAdapter);
    [ExitBtn setTitle:@"确认提交" forState:UIControlStateNormal];
    // 高亮状态
    [ExitBtn setBackgroundImage:[UIImage imageNamed:@"backGroundImg"] forState:(UIControlStateHighlighted)];
    [ExitBtn setTitleColor:TimeMainFont_Color forState:(UIControlStateHighlighted)];

    ExitBtn.layer.cornerRadius = 2.0*YZAdapter;
    ExitBtn.backgroundColor = YZEssentialColor;
    [ExitBtn addTarget:self action:@selector(handdleExitBtn) forControlEvents:UIControlEventTouchUpInside];
    ExitBtn.titleLabel.font = FONT(15);
    [PhoneView addSubview:ExitBtn];
    [self.view addSubview:PhoneView];
}

// 点击提交按钮
- (void) handdleExitBtn {
    
    if (![YZUtil isBlankString:self.CancelID]) {
        if ([self.CancelID isEqualToString:@"其他原因"] && [YZUtil isBlankString:self.YZPlaceholderView.text]) {
            [MBProgressHUD showAutoMessage:@"请输入取消勘查的原因"];
        }else {
            YZAlertViewController * CancelalertVC = [[YZAlertViewController alloc] initWithConfirmAction:^(NSString *inputText) {
                
            } andCancelAction:^{
            }];
            CancelalertVC.RealID = @"CancelInv";
            [self presentViewController:CancelalertVC animated:YES completion:nil];
        }
    }else {
        [MBProgressHUD showAutoMessage:@"至少选1项"];
    }
}

// 添加头部视图
- (UIView *)topView{
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, Screen_W, 50*YZAdapter);
    view.backgroundColor = [UIColor clearColor];

    UILabel *typeLabel = [[UILabel alloc] init];
    typeLabel.frame = CGRectMake(25*YZAdapter, 0, 300*YZAdapter, 45*YZAdapter);
    typeLabel.backgroundColor = [UIColor clearColor];
    typeLabel.font = FONT(15);
    typeLabel.text = @"取消原因";
    typeLabel.textColor = MainFont_Color;
    [view addSubview:typeLabel];
    
    return view;
}

// 添加底部视图
- (UIView *)getBottomView{
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, Screen_W, 100*YZAdapter);
    view.backgroundColor = [UIColor clearColor];
    
    UILabel *typeLabel = [[UILabel alloc] init];
    typeLabel.frame = CGRectMake(0, 0, Screen_W, 20*YZAdapter);
    typeLabel.backgroundColor = [UIColor clearColor];
    [view addSubview:typeLabel];
    
    UIView *Backview = [[UIView alloc] init];
    Backview.frame = CGRectMake(0, 20*YZAdapter, Screen_W, 80*YZAdapter);
    Backview.backgroundColor = [UIColor whiteColor];
    [view addSubview:Backview];
    
    self.YZPlaceholderView = [[YZPlaceholderTextView alloc] initWithFrame:CGRectMake(25*YZAdapter, 20*YZAdapter, Screen_W-50*YZAdapter, 80*YZAdapter)];
    self.YZPlaceholderView.backgroundColor = WhiteColor;
    _YZPlaceholderView.placeholder = @"请输入取消勘查的原因";
    _YZPlaceholderView.returnKeyType = UIReturnKeyNext;
    self.YZPlaceholderView.delegate = self;
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
    [view addSubview:self.YZPlaceholderView];

    return view;
}

#pragma mark - UITextViewDelegate键盘管理和字数限制
- (void)textViewDidChange:(UITextView *)textView {
    
    NSInteger number = [textView.text length];
    if (number > 200) {
        [self.YZPlaceholderView resignFirstResponder];
        textView.text = [textView.text substringToIndex:200];
        number = 200;
        [MBProgressHUD showAutoMessage:@"超过字数限制"];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.YZPlaceholderView resignFirstResponder];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.YZPlaceholderView resignFirstResponder];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45*YZAdapter;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"YZCancelInvCell";
    
    _cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!_cell) {
        _cell = [[YZCancelInvCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSInteger row = [indexPath row];
    NSInteger oldRow = [_lastPath row];
    
    if (row == oldRow && _lastPath!=nil) {
        self.cell.favBtn.image = [UIImage imageNamed:@"NewAgree"];
    }else{
        self.cell.favBtn.image = [UIImage imageNamed:@"NewNoAgree"];
    }

    NSDictionary *dict = dataArray[indexPath.row];
    _cell.dict = dict;
    [_cell updateDataWith:dataArray[indexPath.row]];
    return _cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger newRow = [indexPath row];
    NSInteger oldRow = (self.lastPath !=nil)?[self.lastPath row]:-1;
    if (newRow != oldRow) {
        self.cell = [tableView cellForRowAtIndexPath:indexPath];
        self.cell.favBtn.image = [UIImage imageNamed:@"NewAgree"];
        self.cell = [tableView cellForRowAtIndexPath:self.lastPath];
        self.cell.favBtn.image = [UIImage imageNamed:@"NewNoAgree"];
        self.lastPath = indexPath;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.CancelID = dataArray[indexPath.row][@"title"];
    
    if ([self.CancelID isEqualToString:@"其他原因"]) {
        table.tableFooterView = [self getBottomView];
    }else{
        table.tableFooterView.hidden = YES;
    }
}


/**
 *  取消输入
 */
- (void)viewTapped{
    [self.view endEditing:YES];
}
#pragma mark 键盘出现
-(void)keyboardWillShow:(NSNotification *)note
{
    self.view.frame = CGRectMake(0, 0-30*YZAdapter, Screen_W,Screen_H);
}
#pragma mark 键盘消失
-(void)keyboardWillHide:(NSNotification *)note
{
    self.view.frame = CGRectMake(0, 64, Screen_W, Screen_H-64);
}

#pragma mark - 接受确认按钮点击通知, 进行数据请求
-(void)UserInfoNotification:(NSNotification *)note{
    [self cancelRequest];
}

-(UITableViewCell *)findTableViewCell:(UIView *)v

{
    UIView *tableViewCell = [v superview];
    while (![tableViewCell isKindOfClass:[UITableViewCell class]]) {
        tableViewCell = [tableViewCell superview];
        if([tableViewCell isKindOfClass:[UITableViewCell class]])
            break;
    }
    if ([tableViewCell isKindOfClass:[UITableViewCell class]]) {
        return (UITableViewCell *)tableViewCell;
    }
    return nil;
}


#pragma mark - 数据请求首页数据
- (void)WALLET_LOGRequest {
    
    YZHomePageResquest *YZHP_Resquest = [YZHomePageResquest zwb_requestWithUrl:Task_Cause isPost:YES];
    
    [YZHP_Resquest zwb_sendRequestWithCompletion:^(id responseObject, BOOL success, NSString *message) {
        DLog(@"%@", message);
        if (success) {
            
            [dataArray removeAllObjects];
            
            DLog(@"return sruccess:%@", responseObject);
            NSString * code = responseObject[@"code"];
            if ([code integerValue] == 0) {
                
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:responseObject[@"data"]];
                dataArray = [[NSMutableArray alloc] initWithArray:dic[@"cause"]];
                [dataArray addObject:@{@"id": @"cause_99",@"title": @"其他原因"}];
                [table reloadData];
                
            }else if ([code integerValue] == 900102) {
                [MBProgressHUD showAutoMessage:@"登录信息失效"];
                
                YZLoginViewController * vc = [[YZLoginViewController alloc]init];
                YZUserInfoModel *model = [[YZUserInfoManager sharedManager] currentUserInfo];
                vc.AlertPhone = model.Usre_Phone;
                
                [[YZUserInfoManager sharedManager] didLoginOut];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        } else {
            DLog(@"return failure");
            [MBProgressHUD showAutoMessage:@"请求失败, 请检查您的网络连接"];
        }
    } failure:^(NSError *error) {
        DLog(@"error == %@", error);
        [MBProgressHUD showAutoMessage:@"请求失败, 请检查您的网络连接"];
    }];
}


#pragma mark - 取消提交数据
- (void)cancelRequest {
    
    YZHomePageResquest *YZHP_Resquest = [YZHomePageResquest zwb_requestWithUrl:Task_Cancel isPost:YES];
    
    YZHP_Resquest.tid = self.tid;
    YZHP_Resquest.reason = self.CancelID;
    
    [YZHP_Resquest zwb_sendRequestWithCompletion:^(id responseObject, BOOL success, NSString *message) {
        DLog(@"%@", message);
        if (success) {
            
            DLog(@"return sruccess:%@", responseObject);
            NSString * code = responseObject[@"code"];
            
            if ([code integerValue] == 0) {

                // 从数据库删除退单状态的订单
                [[YZDataBase shareDataBase] deleteOneMovieByOrderID:self.tid];
                
                YZPromptViewController * YZPromptController = [[YZPromptViewController alloc] initWithConfirmAction:^(NSString *inputText) {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }];
                YZPromptController.IDStr = @"CancelInvYES";
                [self presentViewController:YZPromptController animated:YES completion:nil];
                
            }else if ([code integerValue] == 900102) {
                [MBProgressHUD showAutoMessage:@"登录信息失效"];
                
                YZLoginViewController * vc = [[YZLoginViewController alloc]init];
                YZUserInfoModel *model = [[YZUserInfoManager sharedManager] currentUserInfo];
                vc.AlertPhone = model.Usre_Phone;
                
                [[YZUserInfoManager sharedManager] didLoginOut];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        } else {
            DLog(@"return failure");
            [MBProgressHUD showAutoMessage:@"请求失败, 请检查您的网络连接"];
        }
    } failure:^(NSError *error) {
        DLog(@"error == %@", error);
        [MBProgressHUD showAutoMessage:@"请求失败, 请检查您的网络连接"];
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
