//
//  YZChangePasswordViewController.m
//  JBHProject
//
//  Created by zyz on 2017/5/15.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "YZChangePasswordViewController.h"

@interface YZChangePasswordViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *OldPassWord;
@property (nonatomic, strong) UITextField *NewPassWord;
@property (nonatomic, strong) UITextField *NewTooPassWord;


@end

@implementation YZChangePasswordViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = BackGround_Color;
    
    // 设置导航栏
    [self customPushViewControllerNavBarTitle:@"修改密码" backGroundImageName:nil];
    
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
        
    [self.OldPassWord resignFirstResponder];
    [self.NewPassWord resignFirstResponder];
    [self.NewTooPassWord resignFirstResponder];
    [super goBack];
//    [self.navigationController popViewControllerAnimated:YES];
}

- (void)goBack {
    
    [self.OldPassWord resignFirstResponder];
    [self.NewPassWord resignFirstResponder];
    [self.NewTooPassWord resignFirstResponder];
    [super goBack];
//    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 添加控件
- (void)EditPage {
    
    UIView *NameView = [[
                         UIView alloc] initWithFrame:CGRectMake(0, 20*YZAdapter, Screen_W, 45*YZAdapter)];
    NameView.backgroundColor = WhiteColor;
    
    UILabel *NameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15*YZAdapter, 0, 100*YZAdapter, 45*YZAdapter)];
    NameLabel.text = @"原密码";
    NameLabel.font = FONT(16);
    [NameView addSubview:NameLabel];
    
    self.OldPassWord = [[UITextField alloc] initWithFrame:CGRectMake(Screen_W-215*YZAdapter, 0, 200*YZAdapter, 45*YZAdapter)];
    self.OldPassWord.placeholder = @"请输入旧密码";
    self.OldPassWord.font = FONT(16);
    self.OldPassWord.delegate = self;
    self.OldPassWord.textAlignment = NSTextAlignmentRight;
    self.OldPassWord.textColor = MainFont_Color;
    self.OldPassWord.secureTextEntry = YES;
    [NameView addSubview:self.OldPassWord];

    [self.view addSubview:NameView];
    
    
    UIView *IdentityView = [[UIView alloc] initWithFrame:CGRectMake(0, 45*YZAdapter+40*YZAdapter, Screen_W, 45*YZAdapter)];
    IdentityView.backgroundColor = WhiteColor;
    
    UILabel *IdentityLabel = [[UILabel alloc] initWithFrame:CGRectMake(15*YZAdapter, 0, 100*YZAdapter, 45*YZAdapter)];
    IdentityLabel.text = @"新密码";
    IdentityLabel.font = FONT(16);
    [IdentityView addSubview:IdentityLabel];
    
    self.NewPassWord = [[UITextField alloc] initWithFrame:CGRectMake(Screen_W-215*YZAdapter, 0, 200*YZAdapter, 45*YZAdapter)];
    self.NewPassWord.placeholder = @"请输入新密码";
    self.NewPassWord.font = FONT(16);
    self.NewPassWord.delegate = self;
    self.NewPassWord.textAlignment = NSTextAlignmentRight;
    self.NewPassWord.textColor = MainFont_Color;
    self.NewPassWord.secureTextEntry = YES;
//    [self.NewPassWord setKeyboardType:UIKeyboardTypeTwitter];
    [IdentityView addSubview:self.NewPassWord];
    
    [self.view addSubview:IdentityView];
    
    UIView *TooView = [[UIView alloc] initWithFrame:CGRectMake(0, 91*YZAdapter+40*YZAdapter, Screen_W, 45*YZAdapter)];
    TooView.backgroundColor = WhiteColor;
    
    UILabel *TooLabel = [[UILabel alloc] initWithFrame:CGRectMake(15*YZAdapter, 0, 100*YZAdapter, 45*YZAdapter)];
    TooLabel.text = @"重新输入";
    TooLabel.font = FONT(16);
    [TooView addSubview:TooLabel];
    
    self.NewTooPassWord = [[UITextField alloc] initWithFrame:CGRectMake(Screen_W-215*YZAdapter, 0, 200*YZAdapter, 45*YZAdapter)];
    self.NewTooPassWord.placeholder = @"再输入一遍";
    self.NewTooPassWord.font = FONT(16);
    self.NewTooPassWord.delegate = self;
    self.NewTooPassWord.textAlignment = NSTextAlignmentRight;
    self.NewTooPassWord.textColor = MainFont_Color;
    self.NewTooPassWord.secureTextEntry = YES;
    [TooView addSubview:self.NewTooPassWord];
//    [self.NewTooPassWord setKeyboardType:UIKeyboardTypeTwitter];
    
    [self.view addSubview:TooView];
    
    
    UIView *PView = [[UIView alloc] initWithFrame:CGRectMake(0, 532*YZAdapter, Screen_W, 1*YZAdapter)];
    PView.backgroundColor = LightLine_Color;
    [self.view addSubview:PView];
    
    UIView *PhoneView = [[UIView alloc] initWithFrame:CGRectMake(0, 533*YZAdapter, Screen_W, 68*YZAdapter)];
    PhoneView.backgroundColor = WhiteColor;
    
    
    UIButton *ExitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    ExitBtn.frame = CGRectMake(14*YZAdapter, 14*YZAdapter, Screen_W-28*YZAdapter, 42*YZAdapter);
    [ExitBtn setTitle:@"确认修改" forState:UIControlStateNormal];
    // 高亮状态
    [ExitBtn setBackgroundImage:[UIImage imageNamed:@"backGroundImg"] forState:(UIControlStateHighlighted)];
    [ExitBtn setTitleColor:TimeMainFont_Color forState:(UIControlStateHighlighted)];
    // 正常状态
    //    [ExitBtn setImage:[UIImage imageNamed:@"green-1"] forState:UIControlStateNormal];
    ExitBtn.tintColor = [UIColor whiteColor];
    ExitBtn.layer.cornerRadius = 2.0*YZAdapter;
    ExitBtn.backgroundColor = YZEssentialColor;
    [ExitBtn addTarget:self action:@selector(handdleExitBtn) forControlEvents:UIControlEventTouchUpInside];
    ExitBtn.titleLabel.font = FONT(15);
    [PhoneView addSubview:ExitBtn];
    [self.view addSubview:PhoneView];
    
    
//    UIView *PhoneView = [[UIView alloc] initWithFrame:CGRectMake(0, 532*YZAdapter, Screen_W, 42*YZAdapter)];
//    PhoneView.backgroundColor = BackGround_Color;
//    
//    UIButton *ExitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [ExitBtn  setExclusiveTouch :YES];
//    ExitBtn.frame = CGRectMake(10*YZAdapter, 0, Screen_W-20*YZAdapter, 42*YZAdapter);
//    [ExitBtn setTitle:@"确认修改" forState:UIControlStateNormal];
//    ExitBtn.layer.cornerRadius = 2.0*YZAdapter;
//    ExitBtn.layer.masksToBounds = YES;
//    // 高亮状态
//    [ExitBtn setBackgroundImage:[UIImage imageNamed:@"backGroundImg"] forState:(UIControlStateHighlighted)];
//    // 正常状态
////    [ExitBtn setImage:[UIImage imageNamed:@"green-1"] forState:UIControlStateNormal];
//    ExitBtn.tintColor = [UIColor whiteColor];
//    
//    ExitBtn.backgroundColor = NewGreenButton_Color;
//    [ExitBtn addTarget:self action:@selector(handdleExitBtn) forControlEvents:UIControlEventTouchUpInside];
//    ExitBtn.titleLabel.font = FONT(16);
//    
//    [PhoneView addSubview:ExitBtn];
//    
//    [self.view addSubview:PhoneView];
    
}

#pragma mark - 点击确认修改按钮
- (void)handdleExitBtn {
    
    [self.OldPassWord resignFirstResponder];
    [self.NewPassWord resignFirstResponder];
    [self.NewTooPassWord resignFirstResponder];
    
    if (![YZUtil isBlankString:self.OldPassWord.text] && ![YZUtil isBlankString:self.NewPassWord.text] && ![YZUtil isBlankString:self.NewTooPassWord.text]) {
        
        if (self.OldPassWord.text.length >= 6 && self.NewPassWord.text.length >= 6  && self.NewTooPassWord.text.length >= 6 ) {
            if ([self.NewPassWord.text isEqualToString:self.NewTooPassWord.text]) {
                YZALLService *USER_NEWPASSWORDRequest = [YZALLService zwb_requestWithUrl:USER_NEWPASSWORD isPost:YES];
                
                LKWaitBubble(@"修改中...");
                
                USER_NEWPASSWORDRequest.oldpassword = self.OldPassWord.text;
                USER_NEWPASSWORDRequest.newpassword = self.NewPassWord.text;
                
                [USER_NEWPASSWORDRequest zwb_sendRequestWithCompletion:^(id responseObject, BOOL success, NSString *message) {
                    DLog(@"%@", message);
                    if (success) {
                        DLog(@"return success:%@", responseObject);
                        NSString * code = responseObject[@"code"];
                        
                        if ([code integerValue] == 0) {
                            // 关闭进度加载页面
                            LKRightBubble(@"修改成功", 1);
                            [self.OldPassWord resignFirstResponder];
                            [self.NewPassWord resignFirstResponder];
                            [self.NewTooPassWord resignFirstResponder];
//                            [self.navigationController popViewControllerAnimated:YES];
                            [super goBack];
                            
                        }else if ([code integerValue] == 114001){
                            LKHideBubble();
                            [MBProgressHUD showAutoMessage:@"原密码不正确"];
                        }else if ([code integerValue] == 900102) {
                            LKHideBubble();
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
                        LKHideBubble();
                        [MBProgressHUD showAutoMessage:@"修改失败, 请检查您的网络连接"];
                    }
                } failure:^(NSError *error) {
                    DLog(@"error == %@", error);
                    LKHideBubble();
                    [MBProgressHUD showAutoMessage:@"修改失败, 请检查您的网络连接"];
                }];
            }else {
                LKHideBubble();
                [MBProgressHUD showAutoMessage:@"确认密码与新密码不统一"];
            }
        }else if (self.OldPassWord.text.length < 6) {
            [MBProgressHUD showAutoMessage:@"请填写最低6位原密码"];
        }else if (self.NewPassWord.text.length < 6){
            [MBProgressHUD showAutoMessage:@"请填写最低6位新密码"];
        }else if (self.NewTooPassWord.text.length < 6){
            [MBProgressHUD showAutoMessage:@"请填写最低6位确认密码"];
        }
        
    }else if ([YZUtil isBlankString:self.OldPassWord.text]) {
        [MBProgressHUD showAutoMessage:@"请填写原密码"];
        [self.OldPassWord becomeFirstResponder];
    }else if ([YZUtil isBlankString:self.NewPassWord.text]) {
        [MBProgressHUD showAutoMessage:@"请填写新密码"];
        [self.NewPassWord becomeFirstResponder];
        
    }else if ([YZUtil isBlankString:self.NewTooPassWord.text]) {
        [MBProgressHUD showAutoMessage:@"请填写确认密码"];
        [self.NewTooPassWord becomeFirstResponder];
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.OldPassWord resignFirstResponder];
    [self.NewPassWord resignFirstResponder];
    [self.NewTooPassWord resignFirstResponder];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    NSCharacterSet *cs;
//    if(textField == self.NewPassWord) {
        cs = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        if(!basicTest)  {
            return NO;
        }
//    }
    return YES;
}

//- (void)textFieldDidEndEditing:(UITextField *)textField {
//    if (textField.text.length < 6) {
//        [MBProgressHUD showAutoMessage:@"请填写最低6位密码"];
//        if(textField == self.NewPassWord) {
//            [self.NewPassWord becomeFirstResponder];
//        }else if(textField == self.OldPassWord) {
//            [self.OldPassWord becomeFirstResponder];
//        }else if(textField == self.NewTooPassWord) {
//            [self.NewTooPassWord becomeFirstResponder];
//        }
//        
//    }
//    
//}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

