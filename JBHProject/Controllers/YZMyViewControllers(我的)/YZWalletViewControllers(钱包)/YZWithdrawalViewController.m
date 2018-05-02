//
//  YZWithdrawalViewController.m
//  JBHProject
//
//  Created by zyz on 2017/5/6.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "YZWithdrawalViewController.h"
#import "YZBankListViewController.h"
#import "YZPromptViewController.h"

@interface YZWithdrawalViewController () <UITextFieldDelegate, YZBankListViewControllerDelegate>

@property (nonatomic, strong) UITextField *bank;
@property (nonatomic, strong) UITextField *money;

@property (nonatomic, strong) NSString *BankID;
@property (nonatomic, strong) UIImageView *NickNameImage;

@end

@implementation YZWithdrawalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = BackGround_Color;
    
    // 设置导航栏
    [self customPushViewControllerNavBarTitle:@"提现" backGroundImageName:nil];
    
    // 添加控件
    [self EditPage];
    
    [self customerGesturePop];
    
    
}

#pragma mark - Private Method 右划返回上一个页面
- (void)customerGesturePop {
    UISwipeGestureRecognizer *swipeGestuer2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleOtherSwipeGesture)];
    swipeGestuer2.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGestuer2];
}

- (void) handleOtherSwipeGesture {
    
    [self.bank resignFirstResponder];
    [self.money resignFirstResponder];
    [super goBack];
//    [self.navigationController popViewControllerAnimated:YES];
}

- (void)goBack {
    
    [self.bank resignFirstResponder];
    [self.money resignFirstResponder];
    [super goBack];
//    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 添加控件
- (void)EditPage {
    
    // 背景视图
    UIView *BaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H-64)];
    BaView.backgroundColor = BackGround_Color;
    
    // 银行卡
    UIButton *NickNameView = [UIButton buttonWithType:UIButtonTypeCustom];
    NickNameView.frame = CGRectMake(0, 20*YZAdapter, Screen_W, 60*YZAdapter);
    [NickNameView setBackgroundImage:[UIImage imageNamed:@"backGroundImg"] forState:(UIControlStateHighlighted)];
    NickNameView.backgroundColor = WhiteColor;
    
    self.NickNameImage = [[UIImageView alloc] initWithFrame:CGRectMake(25*YZAdapter, 15*YZAdapter, 30*YZAdapter, 30*YZAdapter)];
    self.NickNameImage.image = [UIImage imageNamed:@"YZBankImage"];
    [NickNameView addSubview:self.NickNameImage];
    
    self.bank = [[UITextField alloc] initWithFrame:CGRectMake(90*YZAdapter, 0*YZAdapter, 205*YZAdapter, 60*YZAdapter)];
    self.bank.placeholder = @"选择提现银行卡";
    self.bank.font = FONT(16);
    [self.bank addTarget:self action:@selector(handleTapGesture:) forControlEvents:UIControlEventTouchDown];
    self.bank.textAlignment = NSTextAlignmentLeft;
    self.bank.textColor = MainFont_Color;
    [NickNameView addSubview:self.bank];
    
    
    UIButton *BankBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [BankBtn  setExclusiveTouch :YES];
    BankBtn.frame = CGRectMake(Screen_W - 26*YZAdapter, 18*YZAdapter, 12*YZAdapter, 24*YZAdapter);
    [BankBtn setImage:[UIImage imageNamed:@"YZFH"] forState:UIControlStateNormal];
    [NickNameView addSubview:BankBtn];
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    [NickNameView addGestureRecognizer:tapGesture];
    [BaView addSubview:NickNameView];
    
    
    // 金额
    UIView *NameView = [[UIView alloc] initWithFrame:CGRectMake(0, 100*YZAdapter, Screen_W, 60*YZAdapter)];
    NameView.backgroundColor = WhiteColor;
    
    UIImageView *NameImage = [[UIImageView alloc] initWithFrame:CGRectMake(25*YZAdapter, 15*YZAdapter, 30*YZAdapter, 30*YZAdapter)];
    NameImage.image = [UIImage imageNamed:@"YZMoney"];
    [NameView addSubview:NameImage];
    
//    UIView *NameBackView = [[UILabel alloc] initWithFrame:CGRectMake(88*YZAdapter, 10*YZAdapter, 2*YZAdapter, 40*YZAdapter)];
//    NameBackView.backgroundColor = MainLine_Color;
//    [NameView addSubview:NameBackView];
    
    self.money = [[UITextField alloc] initWithFrame:CGRectMake(90*YZAdapter, 0*YZAdapter, 280*YZAdapter, 60*YZAdapter)];
    self.money.font = FONT(16);
    self.money.placeholder = @"请输入金额";
    self.money.textAlignment = NSTextAlignmentLeft;
    self.money.textColor = MainFont_Color;
    self.money.delegate = self;
    self.money.keyboardType = UIKeyboardTypeDecimalPad;
    [NameView addSubview:self.money];
    
    [BaView addSubview:NameView];
    
    // 可用余额
    UILabel *GenderLabel = [[UILabel alloc] initWithFrame:CGRectMake(13*YZAdapter, 165*YZAdapter, 300*YZAdapter, 17*YZAdapter)];
    GenderLabel.text = [NSString stringWithFormat:@"可用余额 %@元", self.YZMoney];
    GenderLabel.textColor = TimeFont_Color;
    GenderLabel.font = FONT(12);
    [BaView addSubview:GenderLabel];
    
    // 预计2个工作日到账
    UILabel *Gender = [[UILabel alloc] initWithFrame:CGRectMake(0, 245*YZAdapter, Screen_W, 17*YZAdapter)];
    Gender.font = FONT(12);
    Gender.text = @"预计2个工作日到账";
    Gender.textAlignment = NSTextAlignmentCenter;
    Gender.textColor = TimeFont_Color;
    [BaView addSubview:Gender];
    
    // 提现
    UIView *BornDateView = [[UIView alloc] initWithFrame:CGRectMake(0, 185*YZAdapter, Screen_W, 45*YZAdapter)];
    BornDateView.backgroundColor = BackGround_Color;
    
    UIButton *ExitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [ExitBtn  setExclusiveTouch :YES];
    ExitBtn.frame = CGRectMake(14*YZAdapter, 10*YZAdapter, Screen_W-28*YZAdapter, 42*YZAdapter);
    [ExitBtn setTitle:@"提  现" forState:UIControlStateNormal];
    ExitBtn.tintColor = [UIColor whiteColor];
    ExitBtn.layer.cornerRadius = 2.0*YZAdapter;
    // 高亮状态
    [ExitBtn setBackgroundImage:[UIImage imageNamed:@"backGroundImg"] forState:(UIControlStateHighlighted)];
    [ExitBtn setTitleColor:TimeMainFont_Color forState:(UIControlStateHighlighted)];
    // 正常状态
//    [ExitBtn setImage:[UIImage imageNamed:@"green-1"] forState:UIControlStateNormal];
    //    ExitBtn.layer.cornerRadius = 5;
    //    ExitBtn.layer.masksToBounds = YES;
    ExitBtn.backgroundColor = YZEssentialColor;
    [ExitBtn addTarget:self action:@selector(handdleExitBtn) forControlEvents:UIControlEventTouchUpInside];
    ExitBtn.titleLabel.font = FONT(15);
    
    [BornDateView addSubview:ExitBtn];
    [BaView addSubview:BornDateView];
    
    [self.view addSubview:BaView];
    
}

// 选择银行卡
- (void)handleTapGesture:(UIButton *)sender {
    YZBankListViewController *YZBankListController = [YZBankListViewController new];
    YZBankListController.delegate = self;
    YZBankListController.BankListID = @"提现";
    YZBankListController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:YZBankListController animated:YES];
}

- (void)bankImage:(NSString *)image bankLabel:(NSString *)label bankNumn:(NSString *)bankNum bank:(NSString *)bank {
    
    self.bank.text = [NSString stringWithFormat:@"%@ 尾号%@", label, [[bankNum noWhiteSpaceString] substringFromIndex:[bankNum noWhiteSpaceString].length-4]];
    self.BankID = bank;
    
    if ([label isEqualToString:@"邮储银行"]) {
        self.NickNameImage.image = [UIImage imageNamed:@"youzheng"];
    }else if ([label isEqualToString:@"民生银行"]) {
        self.NickNameImage.image = [UIImage imageNamed:@"minsheng_s"];
    }else if ([label isEqualToString:@"平安银行"]) {
        self.NickNameImage.image = [UIImage imageNamed:@"pingan_s"];
    }else if ([label isEqualToString:@"中国银行"]) {
        self.NickNameImage.image = [UIImage imageNamed:@"zhongguo"];
    }else if ([label isEqualToString:@"建设银行"]) {
        self.NickNameImage.image = [UIImage imageNamed:@"jianshe"];
    }else if ([label isEqualToString:@"光大银行"]) {
        self.NickNameImage.image = [UIImage imageNamed:@"guangda_s"];
    }else if ([label isEqualToString:@"华夏银行"]) {
        self.NickNameImage.image = [UIImage imageNamed:@"huaxia"];
    }else if ([label isEqualToString:@"浦发银行"]) {
        self.NickNameImage.image = [UIImage imageNamed:@"pufa"];
    }else if ([label isEqualToString:@"农业银行"]) {
        self.NickNameImage.image = [UIImage imageNamed:@"nongye"];
    }else if ([label isEqualToString:@"工商银行"]) {
        self.NickNameImage.image = [UIImage imageNamed:@"gongshang_s"];
    }else if ([label isEqualToString:@"北京银行"]) {
        self.NickNameImage.image = [UIImage imageNamed:@"beijing"];
    }else if ([label isEqualToString:@"兴业银行"]) {
        self.NickNameImage.image = [UIImage imageNamed:@"xingye"];
    }else if ([label isEqualToString:@"交通银行"]) {
        self.NickNameImage.image = [UIImage imageNamed:@"jiaotong"];
    }else if ([label isEqualToString:@"上海银行"]) {
        self.NickNameImage.image = [UIImage imageNamed:@"shanghai"];
    }else if ([label isEqualToString:@"中信银行"]) {
        self.NickNameImage.image = [UIImage imageNamed:@"zhongxin"];
    }else if ([label isEqualToString:@"广发银行"]) {
        self.NickNameImage.image = [UIImage imageNamed:@"guangfa"];
    }else if ([label isEqualToString:@"招商银行"]) {
        self.NickNameImage.image = [UIImage imageNamed:@"zhaoshang"];
    }

}


#pragma mark - 提现
- (void) handdleExitBtn {
    
    [self.bank resignFirstResponder];
    [self.money resignFirstResponder];
    
    if (![YZUtil isBlankString:self.bank.text] && ![YZUtil isBlankString:self.money.text]) {
        
        if ([self.money.text floatValue] >= 1) {
            YZALLService *WALLET_EXTRACTRequest = [YZALLService zwb_requestWithUrl:WALLET_EXTRACT isPost:YES];
            
            WALLET_EXTRACTRequest.id = self.BankID;
            WALLET_EXTRACTRequest.money = self.money.text;
            
            [WALLET_EXTRACTRequest zwb_sendRequestWithCompletion:^(id responseObject, BOOL success, NSString *message) {
                DLog(@"%@", message);
                if (success) {
                    DLog(@"return success:%@", responseObject);
                    NSString * code = responseObject[@"code"];
                    
                    if ([code integerValue] == 0) {
                        // 提示框
                        YZPromptViewController * YZPromptController = [[YZPromptViewController alloc] initWithConfirmAction:^(NSString *inputText) {
                            DLog(@"输入内容：%@", inputText);
                            
//                            [self.navigationController popViewControllerAnimated:YES];
                            [super goBack];
                        }];
                        YZPromptController.IDStr = @"提现成功, 预计两个工作日到账";
                        [self presentViewController:YZPromptController animated:YES completion:nil];
                        
                    }else if ([code integerValue] == 215001) {
                        [MBProgressHUD showAutoMessage:@"ID无效"];
                    }else if ([code integerValue] == 215002) {
                        [MBProgressHUD showAutoMessage:@"金额无效"];
                    }else if ([code integerValue] == 215003) {
                        [MBProgressHUD showAutoMessage:@"银行卡号不存在"];
                    }else if ([code integerValue] == 215004) {
                        [MBProgressHUD showAutoMessage:@"余额不足"];
                    }else if ([code integerValue] == 215005) {
                        [MBProgressHUD showAutoMessage:@"提现失败，请重试"];
                    }else if ([code integerValue] == 215006) {
                        [MBProgressHUD showAutoMessage:@"提现失败，账户异常，请与客服联系"];
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
                    [MBProgressHUD showAutoMessage:@"提现失败, 请检查您的网络连接"];
                }
            } failure:^(NSError *error) {
                DLog(@"error == %@", error);
                [MBProgressHUD showAutoMessage:@"提现失败, 请检查您的网络连接"];
            }];

        }else {
            [MBProgressHUD showAutoMessage:@"提现金额不能低于1元"];
        }
    }else {
        [MBProgressHUD showAutoMessage:@"银行卡和金额不能为空"];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.bank resignFirstResponder];
    [self.money resignFirstResponder];
    
}



// UITextField 限制用户输入小数点后位数的方法
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    
//    NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
//    [futureString  insertString:string atIndex:range.location];
//    
//    NSInteger flag=0;
//    const NSInteger limited = 2;
//    for (NSInteger i = futureString.length-1; i>=0; i--) {
//        
//        if ([futureString characterAtIndex:i] == '.') {
//            
//            if (flag > limited) {
//                return NO;
//            }
//            
//            break;
//        }
//        flag++;
//    }
//    
//    
//    return YES;
//}




- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //string就是此时输入的那个字符textField就是此时正在输入的那个输入框返回YES就是可以改变输入框的值NO相反
//    NSString * toBeString = [textField.text     stringByReplacingCharactersInRange:range withString:string];
    // 判断是否输入内容，或者用户点击的是键盘的删除按钮
    if (![string isEqualToString:@""]) {
        if ([textField isEqual:self.money]) {
            // 小数点在字符串中的位置 第一个数字从0位置开始
            NSInteger dotLocation = [textField.text rangeOfString:@"."].location;
            if (dotLocation == NSNotFound && range.location != 0) {
                //没有小数点,最大数值
//                if (range.location >= 9){
//                    DLog(@"单笔金额不能超过亿位");
//                    if ([string isEqualToString:@"."] && range.location == 9) {
//                        return YES;
//                    }
//                    return NO;
//                }
            }
            //判断输入多个小数点,禁止输入多个小数点
            if (dotLocation != NSNotFound){
                if ([string isEqualToString:@"."])return NO;
            }
            //判断小数点后最多两位
            if (dotLocation != NSNotFound && range.location > dotLocation + 2) { return NO; }
            //判断总长度
            if (textField.text.length > 11) {
                return NO;
            }
        }
    }
    return YES;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.tabBarController.tabBar.hidden = YES;

    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    self.tabBarController.tabBar.hidden = NO;
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the s elected object to the new view controller.
}
*/

@end

