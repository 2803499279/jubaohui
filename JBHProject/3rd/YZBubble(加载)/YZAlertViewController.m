//
//  YZAlertViewController.m
//  JBHProject
//
//  Created by zyz on 2017/5/4.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "YZAlertViewController.h"

#define ScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define OnePixel     (1./[UIScreen mainScreen].scale)
#define animateTime  0.35f
#define UIColorFromHEX(hexValue, alphaValue) \
[UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 \
green:((float)((hexValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(hexValue & 0x0000FF))/255.0 \
alpha:alphaValue]

@interface YZAlertViewController ()

@property (nonatomic, assign) BOOL notifiKeyboardHide;

@property (nonatomic, strong) UILabel * inputTextField;  //输入框
@property (nonatomic, strong) UIView * operateView; //操作视图
@property (nonatomic, strong) UIImageView * inputImage;  //输入框
@property (nonatomic, strong) UILabel * reloadImageBtn;

@property (nonatomic, copy) ClickBlock confirmBlock;
@property (nonatomic, copy) CancelBlock cancelBlock;
@property (nonatomic, strong) NSString *cancel; // 是否发送取消通知的标志


@end

@implementation YZAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromHEX(0x000000, 0.5);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //必须在这里，否则动画无效
    [self showAlertView];
}

- (instancetype)initWithConfirmAction:(ClickBlock)confirmBlock andCancelAction:(CancelBlock)cancelBlcok
{
    if (self = [super init]) {
        self.confirmBlock = confirmBlock;
        self.cancelBlock = cancelBlcok;
        
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }
    return self;
}


#pragma mark - 创建UI
- (void)showAlertView
{
    _notifiKeyboardHide = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    /**
     *  操作区背景
     */
    _operateView = [[UIView alloc] init];
    _operateView.center = CGPointMake(ScreenWidth/2., ScreenHeight/2.);
    _operateView.bounds = CGRectMake(0, 0, 264*YZAdapter, 200*YZAdapter);
    _operateView.backgroundColor = [UIColor whiteColor];
    _operateView.layer.cornerRadius = 6;
    _operateView.clipsToBounds = YES;
    [self.view addSubview:_operateView];
    [self shakeToShow:_operateView];
    
    
    if ([self.RealID isEqualToString:@"实名认证"]) {
        /**
         *  按钮
         */
        UIButton * cancelBtn = [self createButtonWithFrame:CGRectMake(17*YZAdapter, 125*YZAdapter, 100*YZAdapter, 45*YZAdapter) title:@"暂不认证" andAction:@selector(cancelAction:)];
        [cancelBtn  setExclusiveTouch :YES];
        [cancelBtn setBackgroundImage:[UIImage imageNamed:@"backGroundImg"] forState:(UIControlStateHighlighted)];
        [cancelBtn setTitleColor:TimeMainFont_Color forState:(UIControlStateHighlighted)];
        cancelBtn.backgroundColor = MainLine_Color;
        
        
        UIButton * confirmBtn = [self createButtonWithFrame:CGRectMake(147*YZAdapter, 125*YZAdapter, 100*YZAdapter, 45*YZAdapter) title:@"前往认证" andAction:@selector(confirmAction:)];
        [confirmBtn  setExclusiveTouch :YES];
        [confirmBtn setBackgroundImage:[UIImage imageNamed:@"backGroundImg"] forState:(UIControlStateHighlighted)];
        [confirmBtn setTitleColor:TimeMainFont_Color forState:(UIControlStateHighlighted)];
        confirmBtn.backgroundColor = YZEssentialColor;
        
        
        /**
         *  提示语句
         */
        _reloadImageBtn = [[UILabel alloc] initWithFrame:CGRectMake(0, 80*YZAdapter, 264*YZAdapter, 16*YZAdapter)];
        _reloadImageBtn.text = @"您未实名认证, 是否前往实名认证";
        _reloadImageBtn.font = FONT(14);
        _reloadImageBtn.numberOfLines = 0;
        _reloadImageBtn.textAlignment = NSTextAlignmentCenter;
        _reloadImageBtn.textColor = TimeFont_Color;
        [_operateView addSubview:_reloadImageBtn];
        
        
        _inputImage = [[UIImageView alloc] initWithFrame:CGRectMake(85*YZAdapter, 30*YZAdapter, 21*YZAdapter, 21*YZAdapter)];
        _inputImage.image = [UIImage imageNamed:@"YZNewGreenImage"];
        [_operateView addSubview:_inputImage];
        
        /**
         *  标题
         */
        _inputTextField = [[UILabel alloc] initWithFrame:CGRectMake(0*YZAdapter, 31*YZAdapter, 264*YZAdapter, 21*YZAdapter)];
        _inputTextField.text = @"提示";
        _inputTextField.font = FONTS(20);
        _inputTextField.textAlignment = NSTextAlignmentCenter;
        _inputTextField.textColor = MainFont_Color;
        [_operateView addSubview:_inputTextField];

    }else if ([self.RealID isEqualToString:@"order"]){
        /**
         *  按钮
         */
        UIButton * cancelBtn = [self createButtonWithFrame:CGRectMake(17*YZAdapter, 125*YZAdapter, 100*YZAdapter, 45*YZAdapter) title:@"狠心离开" andAction:@selector(cancelAction:)];
        [cancelBtn  setExclusiveTouch :YES];
        [cancelBtn setBackgroundImage:[UIImage imageNamed:@"backGroundImg"] forState:(UIControlStateHighlighted)];
        [cancelBtn setTitleColor:TimeMainFont_Color forState:(UIControlStateHighlighted)];
        cancelBtn.backgroundColor = MainLine_Color;
        
        
        UIButton * confirmBtn = [self createButtonWithFrame:CGRectMake(147*YZAdapter, 125*YZAdapter, 100*YZAdapter, 45*YZAdapter) title:@"继续填写" andAction:@selector(confirmAction:)];
        [confirmBtn  setExclusiveTouch :YES];
        [confirmBtn setBackgroundImage:[UIImage imageNamed:@"backGroundImg"] forState:(UIControlStateHighlighted)];
        [confirmBtn setTitleColor:TimeMainFont_Color forState:(UIControlStateHighlighted)];
        confirmBtn.backgroundColor = YZEssentialColor;
        
        
        /**
         *  提示语句
         */
        _reloadImageBtn = [[UILabel alloc] initWithFrame:CGRectMake(0, 80*YZAdapter, 264*YZAdapter, 16*YZAdapter)];
        _reloadImageBtn.text = @"退出当前页面的编辑";
        _reloadImageBtn.font = FONT(14);
        _reloadImageBtn.numberOfLines = 0;
        _reloadImageBtn.textAlignment = NSTextAlignmentCenter;
        _reloadImageBtn.textColor = TimeFont_Color;
        [_operateView addSubview:_reloadImageBtn];
        
        
        _inputImage = [[UIImageView alloc] initWithFrame:CGRectMake(85*YZAdapter, 30*YZAdapter, 21*YZAdapter, 21*YZAdapter)];
        _inputImage.image = [UIImage imageNamed:@"YZNewGreenImage"];
        [_operateView addSubview:_inputImage];
        
        /**
         *  标题
         */
        _inputTextField = [[UILabel alloc] initWithFrame:CGRectMake(0, 31*YZAdapter, 264*YZAdapter, 21*YZAdapter)];
        _inputTextField.text = @"提示";
        _inputTextField.font = FONTS(20);
        _inputTextField.textAlignment = NSTextAlignmentCenter;
        _inputTextField.textColor = MainFont_Color;
        [_operateView addSubview:_inputTextField];

    }else if ([self.RealID isEqualToString:@"real"]){
        /**
         *  按钮
         */
        UIButton * cancelBtn = [self createButtonWithFrame:CGRectMake(17*YZAdapter, 125*YZAdapter, 100*YZAdapter, 45*YZAdapter) title:@"确认" andAction:@selector(cancelAction:)];
        [cancelBtn  setExclusiveTouch :YES];
        [cancelBtn setBackgroundImage:[UIImage imageNamed:@"backGroundImg"] forState:(UIControlStateHighlighted)];
        [cancelBtn setTitleColor:TimeMainFont_Color forState:(UIControlStateHighlighted)];
        cancelBtn.backgroundColor = YZEssentialColor;
        
        
        UIButton * confirmBtn = [self createButtonWithFrame:CGRectMake(147*YZAdapter, 125*YZAdapter, 100*YZAdapter, 45*YZAdapter) title:@"取消" andAction:@selector(confirmAction:)];
        [confirmBtn  setExclusiveTouch :YES];
        [confirmBtn setBackgroundImage:[UIImage imageNamed:@"backGroundImg"] forState:(UIControlStateHighlighted)];
        [confirmBtn setTitleColor:TimeMainFont_Color forState:(UIControlStateHighlighted)];
        confirmBtn.backgroundColor = MainLine_Color;
        
        
        /**
         *  提示语句
         */
        _reloadImageBtn = [[UILabel alloc] initWithFrame:CGRectMake(0, 80*YZAdapter, 264*YZAdapter, 16*YZAdapter)];
        _reloadImageBtn.text = @"您还未实名认证, 是否离开";
        _reloadImageBtn.font = FONT(14);
        _reloadImageBtn.numberOfLines = 0;
        _reloadImageBtn.textAlignment = NSTextAlignmentCenter;
        _reloadImageBtn.textColor = TimeFont_Color;
        [_operateView addSubview:_reloadImageBtn];
        
        
        _inputImage = [[UIImageView alloc] initWithFrame:CGRectMake(85*YZAdapter, 30*YZAdapter, 21*YZAdapter, 21*YZAdapter)];
        _inputImage.image = [UIImage imageNamed:@"YZNewGreenImage"];
        [_operateView addSubview:_inputImage];
        
        /**
         *  标题
         */
        _inputTextField = [[UILabel alloc] initWithFrame:CGRectMake(0, 31*YZAdapter, 264*YZAdapter, 21*YZAdapter)];
        _inputTextField.text = @"提示";
        _inputTextField.font = FONTS(20);
        _inputTextField.textAlignment = NSTextAlignmentCenter;
        _inputTextField.textColor = MainFont_Color;
        [_operateView addSubview:_inputTextField];
        
    }else if ([self.RealID isEqualToString:@"新版本"]){
        /**
         *  按钮
         */
        UIButton * cancelBtn = [self createButtonWithFrame:CGRectMake(17*YZAdapter, 125*YZAdapter, 100*YZAdapter, 45*YZAdapter) title:@"暂不更新" andAction:@selector(cancelAction:)];
        [cancelBtn  setExclusiveTouch :YES];
        [cancelBtn setBackgroundImage:[UIImage imageNamed:@"backGroundImg"] forState:(UIControlStateHighlighted)];
        [cancelBtn setTitleColor:TimeMainFont_Color forState:(UIControlStateHighlighted)];
        cancelBtn.backgroundColor = MainLine_Color;
        
        
        UIButton * confirmBtn = [self createButtonWithFrame:CGRectMake(147*YZAdapter, 125*YZAdapter, 100*YZAdapter, 45*YZAdapter) title:@"立即更新" andAction:@selector(confirmAction:)];
        [confirmBtn  setExclusiveTouch :YES];
        [confirmBtn setBackgroundImage:[UIImage imageNamed:@"backGroundImg"] forState:(UIControlStateHighlighted)];
        [confirmBtn setTitleColor:TimeMainFont_Color forState:(UIControlStateHighlighted)];
        confirmBtn.backgroundColor = YZEssentialColor;
        
        /**
         *  提示语句
         */
        _reloadImageBtn = [[UILabel alloc] initWithFrame:CGRectMake(0, 80*YZAdapter, 264*YZAdapter, 16*YZAdapter)];
        _reloadImageBtn.text = [NSString stringWithFormat:@"有新版本%@可以更新当前版本%@", self.NewVersion, self.OldVersion];
        _reloadImageBtn.font = FONT(14);
        _reloadImageBtn.numberOfLines = 0;
        _reloadImageBtn.textAlignment = NSTextAlignmentCenter;
        _reloadImageBtn.textColor = TimeFont_Color;
        [_operateView addSubview:_reloadImageBtn];
        
        
        _inputImage = [[UIImageView alloc] initWithFrame:CGRectMake(85*YZAdapter, 30*YZAdapter, 21*YZAdapter, 21*YZAdapter)];
        _inputImage.image = [UIImage imageNamed:@"YZNewGreenImage"];
        [_operateView addSubview:_inputImage];
        
        /**
         *  标题
         */
        _inputTextField = [[UILabel alloc] initWithFrame:CGRectMake(0, 31*YZAdapter, 264*YZAdapter, 21*YZAdapter)];
        _inputTextField.text = @"提示";
        _inputTextField.font = FONTS(20);
        _inputTextField.textAlignment = NSTextAlignmentCenter;
        _inputTextField.textColor = MainFont_Color;
        [_operateView addSubview:_inputTextField];
        
    }else if ([self.RealID isEqualToString:@"退出登录"]){
        /**
         *  按钮
         */
        UIButton * cancelBtn = [self createButtonWithFrame:CGRectMake(17*YZAdapter, 125*YZAdapter, 100*YZAdapter, 45*YZAdapter) title:@"取消" andAction:@selector(cancelAction:)];
        [cancelBtn  setExclusiveTouch :YES];
        [cancelBtn setTitleColor:TimeFont_Color forState:UIControlStateNormal];
        [cancelBtn setBackgroundImage:[UIImage imageNamed:@"backGroundImg"] forState:(UIControlStateHighlighted)];
        [cancelBtn setTitleColor:TimeMainFont_Color forState:(UIControlStateHighlighted)];
        cancelBtn.backgroundColor = WhiteColor;
        //边框宽度
        [cancelBtn.layer setBorderWidth:1.0];
        cancelBtn.layer.borderColor=LightLine_Color.CGColor;
        
        
        
        UIButton * confirmBtn = [self createButtonWithFrame:CGRectMake(147*YZAdapter, 125*YZAdapter, 100*YZAdapter, 45*YZAdapter) title:@"确认" andAction:@selector(confirmAction:)];
        [confirmBtn  setExclusiveTouch :YES];
        [confirmBtn setBackgroundImage:[UIImage imageNamed:@"backGroundImg"] forState:(UIControlStateHighlighted)];
        [confirmBtn setTitleColor:TimeMainFont_Color forState:(UIControlStateHighlighted)];
        confirmBtn.backgroundColor = YZEssentialColor;
        
        /**
         *  提示语句
         */
        _reloadImageBtn = [[UILabel alloc] initWithFrame:CGRectMake(0, 80*YZAdapter, 264*YZAdapter, 16*YZAdapter)];
        _reloadImageBtn.text = [NSString stringWithFormat:@"退出登录后将无法接单"];
        _reloadImageBtn.font = FONT(15);
        _reloadImageBtn.numberOfLines = 0;
        _reloadImageBtn.textAlignment = NSTextAlignmentCenter;
        _reloadImageBtn.textColor = TimeFont_Color;
        [_operateView addSubview:_reloadImageBtn];
        
        
//        _inputImage = [[UIImageView alloc] initWithFrame:CGRectMake(85*YZAdapter, 30*YZAdapter, 21*YZAdapter, 21*YZAdapter)];
//        _inputImage.image = [UIImage imageNamed:@"YellowImage"];
//        [_operateView addSubview:_inputImage];
        
        /**
         *  标题
         */
        _inputTextField = [[UILabel alloc] initWithFrame:CGRectMake(0, 31*YZAdapter, 264*YZAdapter, 21*YZAdapter)];
        _inputTextField.text = @"确认退出登录 ?";
        _inputTextField.font = FONTS(17);
        _inputTextField.textAlignment = NSTextAlignmentCenter;
        _inputTextField.textColor = MainFont_Color;
        [_operateView addSubview:_inputTextField];
        
    }else if ([self.RealID isEqualToString:@"删除银行卡"]){
        /**
         *  按钮
         */
        UIButton * cancelBtn = [self createButtonWithFrame:CGRectMake(17*YZAdapter, 125*YZAdapter, 100*YZAdapter, 45*YZAdapter) title:@"取消" andAction:@selector(cancelAction:)];
        [cancelBtn  setExclusiveTouch :YES];
        [cancelBtn setBackgroundImage:[UIImage imageNamed:@"backGroundImg"] forState:(UIControlStateHighlighted)];
        [cancelBtn setTitleColor:TimeMainFont_Color forState:(UIControlStateHighlighted)];
        cancelBtn.backgroundColor = MainLine_Color;
        
        
        UIButton * confirmBtn = [self createButtonWithFrame:CGRectMake(147*YZAdapter, 125*YZAdapter, 100*YZAdapter, 45*YZAdapter) title:@"确认" andAction:@selector(confirmAction:)];
        [confirmBtn  setExclusiveTouch :YES];
        [confirmBtn setBackgroundImage:[UIImage imageNamed:@"backGroundImg"] forState:(UIControlStateHighlighted)];
        [confirmBtn setTitleColor:TimeMainFont_Color forState:(UIControlStateHighlighted)];
        confirmBtn.backgroundColor = YZEssentialColor;
        
        /**
         *  提示语句
         */
        _reloadImageBtn = [[UILabel alloc] initWithFrame:CGRectMake(0, 80*YZAdapter, 264*YZAdapter, 16*YZAdapter)];
        _reloadImageBtn.text = [NSString stringWithFormat:@"是否删除选中的银行卡"];
        _reloadImageBtn.font = FONT(14);
        _reloadImageBtn.numberOfLines = 0;
        _reloadImageBtn.textAlignment = NSTextAlignmentCenter;
        _reloadImageBtn.textColor = TimeFont_Color;
        [_operateView addSubview:_reloadImageBtn];
        
        
        _inputImage = [[UIImageView alloc] initWithFrame:CGRectMake(85*YZAdapter, 30*YZAdapter, 21*YZAdapter, 21*YZAdapter)];
        _inputImage.image = [UIImage imageNamed:@"YZNewGreenImage"];
        [_operateView addSubview:_inputImage];
        
        /**
         *  标题
         */
        _inputTextField = [[UILabel alloc] initWithFrame:CGRectMake(0, 31*YZAdapter, 264*YZAdapter, 21*YZAdapter)];
        _inputTextField.text = @"提示";
        _inputTextField.font = FONTS(20);
        _inputTextField.textAlignment = NSTextAlignmentCenter;
        _inputTextField.textColor = MainFont_Color;
        [_operateView addSubview:_inputTextField];
        
    }else if ([self.RealID isEqualToString:@"CancelInv"]){
        /**
         *  按钮
         */
        UIButton * cancelBtn = [self createButtonWithFrame:CGRectMake(17*YZAdapter, 125*YZAdapter, 100*YZAdapter, 45*YZAdapter) title:@"取消" andAction:@selector(cancelAction:)];
        [cancelBtn  setExclusiveTouch :YES];
        [cancelBtn setBackgroundImage:[UIImage imageNamed:@"backGroundImg"] forState:(UIControlStateHighlighted)];
        [cancelBtn setTitleColor:TimeMainFont_Color forState:(UIControlStateHighlighted)];
        cancelBtn.backgroundColor = MainLine_Color;
        
        
        UIButton * confirmBtn = [self createButtonWithFrame:CGRectMake(147*YZAdapter, 125*YZAdapter, 100*YZAdapter, 45*YZAdapter) title:@"确认" andAction:@selector(confirmAction:)];
        [confirmBtn  setExclusiveTouch :YES];
        [confirmBtn setBackgroundImage:[UIImage imageNamed:@"backGroundImg"] forState:(UIControlStateHighlighted)];
        [confirmBtn setTitleColor:TimeMainFont_Color forState:(UIControlStateHighlighted)];
        confirmBtn.backgroundColor = YZEssentialColor;
        
        /**
         *  提示语句
         */
        _reloadImageBtn = [[UILabel alloc] initWithFrame:CGRectMake(0, 45*YZAdapter, 264*YZAdapter, 50*YZAdapter)];
        _reloadImageBtn.text = [NSString stringWithFormat:@"因个人原因取消订单,\n 会影响您的服务分, 确认取消 ?"];
        _reloadImageBtn.font = FONT(14);
        _reloadImageBtn.numberOfLines = 0;
        _reloadImageBtn.textAlignment = NSTextAlignmentCenter;
        _reloadImageBtn.textColor = TimeFont_Color;
        [_operateView addSubview:_reloadImageBtn];
    }
}

#pragma mark - 移除视图
- (void)removeAlertView
{
    if ([_inputTextField isFirstResponder]) {
        [_inputTextField resignFirstResponder];
    }
    
    [UIView animateWithDuration:0.15 animations:^{
        _operateView.alpha = 0;
        _operateView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    } completion:^(BOOL finished) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        if (_notifiKeyboardHide) {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        if (![self.cancel isEqualToString:@"cancel"]) {
            //创建通知
            NSNotification *UserInfoNotification =[NSNotification notificationWithName:@"CancelInv" object:nil userInfo:nil];
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:UserInfoNotification];
        }
    }];
}


#pragma mark - 创建按钮
- (UIButton *)createButtonWithFrame:(CGRect)frame title:(NSString *)title andAction:(SEL)action
{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setTitleColor:WhiteColor forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = FONT(15);
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [_operateView addSubview:btn];
    
    return btn;
}
- (void)confirmAction:(UIButton *)sender
{
    if (self.confirmBlock) {
        self.confirmBlock(_inputTextField.text);
    }
    
    [self removeAlertView];
}
- (void)cancelAction:(UIButton *)sender
{
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    self.cancel = @"cancel";
    [self removeAlertView];
}


#pragma mark - 颜色转换为图片
- (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)aSize
{
    CGRect rect = CGRectMake(0.0f, 0.0f, aSize.width, aSize.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


#pragma mark - 弹性震颤动画
- (void)shakeToShow:(UIView *)aView
{
    CAKeyframeAnimation * popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.35;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05f, 1.05f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.0f, @0.5f, @0.75f, @0.8f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [aView.layer addAnimation:popAnimation forKey:nil];
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
    // Pass the selected object to the new view controller.
}
*/

@end
