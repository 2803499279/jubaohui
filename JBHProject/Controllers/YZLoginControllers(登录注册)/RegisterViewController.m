//
//  RegisterViewController.m
//  JBHProject
//
//  Created by 李俊恒 on 2017/4/24.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "RegisterViewController.h"
#import "YZViewJavaScriptBridge.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"

#import <JavaScriptCore/JavaScriptCore.h>

@interface RegisterViewController () <NJKWebViewProgressDelegate, UIWebViewDelegate, ViewJavaScriptBridgeDelegate, NSURLConnectionDelegate>
{
    UIActivityIndicatorView *activityView;
}

@property (strong, nonatomic) YZViewJavaScriptBridge *bridge;

@property(nonatomic,strong)UIWebView * WebView;
@property (nonatomic, strong)NJKWebViewProgress *progressProxy;
@property (nonatomic, strong)NJKWebViewProgressView *progressView;

@property (nonatomic, strong) UIView *BackView;
@property (nonatomic, strong) NSString *IDRequest;

@property (nonatomic, strong) AFNetworkReachabilityManager *manager;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self webviewRequest];
}

// webview页面加载
- (void) webviewRequest {
    LKWaitBubble(@"加载中...");
    
    self.view.backgroundColor = BackGround_Color;
    
    //注册网络请求拦截
    [NSURLProtocol registerClass:[YZRichURLProtocol class]];
    
    [self customPushViewControllerNavBarTitle:@"注册速勘员" backGroundImageName:nil];
    [self.view addSubview:self.WebView];
    [self loadWebViewHtml];
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    self.WebView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    CGFloat progressBarHeight = 2.f;
    
    if ([self.IDRequest isEqualToString:@"刷新"]) {
        CGRect barFrame = CGRectMake(0, 0, Screen_W, progressBarHeight);
        _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    }else {
        CGRect barFrame = CGRectMake(0, 64, Screen_W, progressBarHeight);
        _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    }
    
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:self.progressView];
    
    [self customerGesturePop];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (UIWebView *)WebView
{
    if (_WebView == nil) {
        _WebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H)];
        _WebView.backgroundColor = WhiteColor;
    }
    return _WebView;
}

- (void)goBack
{
    if ([self.WebView canGoBack]) {
        [self.WebView goBack];
    }else{
         [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)loadWebViewHtml{
    NSURL * url = [NSURL URLWithString:REGISTER];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
    
    [self.WebView loadRequest:request];
    
//    [self.WebView stringByEvaluatingJavaScriptFromString:@"(function (doc, win) {var docEl = doc.documentElement,resizeEvt = 'orientationchange' in window ? 'orientationchange' : 'resize',recalc = function () {var clientWidth = docEl.clientWidth; if (!clientWidth) return;docEl.style.fontSize = 100 * (clientWidth / 320) + 'px'; };if (!doc.addEventListener) return; win.addEventListener(resizeEvt, recalc, false);doc.addEventListener('DOMContentLoaded', recalc, false);})(document, window);"];
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



-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress {
    [_progressView setProgress:progress animated:YES];
}

//加载网页动画
- (void)webViewDidStartLoad:(UIWebView *)webView{

    [self requestTaskSt];
//    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    activityView.backgroundColor = LightFont_Color;
//    activityView.color = MainFont_Color;
//    activityView.frame = CGRectMake((Screen_W-80*YZAdapter)/2, (Screen_H-80*YZAdapter)/2, 80*YZAdapter, 80*YZAdapter);
//    [self.view addSubview:activityView];
//    [activityView startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    LKHideBubble();
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //获取当前页面的title
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
//    NSLog(@"%@", title);
    
    if (![YZUtil isBlankString:title]) {
        self.naviTitle = title;
    }    
    [_manager stopMonitoring];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    //去除长按后出现的文本选取框
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];  
    NSString *absolutePath = request.URL.absoluteString;
    
    NSString *scheme = @"rrcc://";
    
    if ([absolutePath hasPrefix:scheme]) {
        NSString *subPath = [absolutePath substringFromIndex:scheme.length];
        NSString *methodName = [subPath stringByReplacingOccurrencesOfString:@"_" withString:@":"];
        SEL sel = NSSelectorFromString(methodName);
        
        if ([self respondsToSelector:sel]) {
            [self performSelector:sel];
        }
        YZLoginViewController * vc = [[YZLoginViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    };
    
    JSContext *context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    context[@"startLoginAction"] = ^() {
        NSArray *args = [JSContext currentArguments];
        for (id obj in args) {
            DLog(@"%@",obj);
        }
        NSString *Phone = [args[0] toString];
        NSString *Password = [args[1] toString];
        
        
        if (![YZUtil isBlankString:Phone] && ![YZUtil isBlankString:Password] && [YZUtil isMobileNumber:Phone]) {
            LKWaitBubble(@"正在登录");
            YZALLService *LoginRequest = [YZALLService zwb_requestWithUrl:USER_LOGIN_URL isPost:YES];
            
            LoginRequest.telphone = [Phone noWhiteSpaceString];
            LoginRequest.password = [Password noWhiteSpaceString];
            LoginRequest.deviceid = [[UIDevice currentDevice].identifierForVendor UUIDString];
            
//            WeakSelf(self);
            
            [LoginRequest zwb_sendRequestWithCompletion:^(id responseObject, BOOL success, NSString *message) {
                DLog(@"%@", message);
                                
                if (success) {
                    DLog(@"return success:%@", responseObject);
                    NSString * code = responseObject[@"code"];
                    if ([code integerValue] == 0) {
                        
//                        [MBProgressHUD hideHUDForView:nil];
                        
                        NSDictionary *customer = responseObject[@"data"];
                        NSMutableDictionary *mResponse = [NSMutableDictionary dictionary];
                        NSArray *keyValue = [customer allKeys];
                        for (NSInteger i = 0; i < keyValue.count; i++) {
                            NSString *key = keyValue[i];
                            if (kObjectIsEmpty(customer[key]))
                                [mResponse setObject:@"" forKey:key];
                            else
                                [mResponse setObject:customer[key] forKey:key];
                        }
                        
                        [mResponse setObject:Phone forKey:@"Usre_Phone"];
                        
                        [[YZUserInfoManager sharedManager] didLoginInWithUserInfo:mResponse];
                        
                        [JPUSHService setTags:nil alias:mResponse[@"pushid"] fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias){
                            DLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags, iAlias);
                        }];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"isRegisterSuccess" object:@"忘记密码登录"];
                        
                        LKRightBubble(@"登录成功", 1);
                        
                    }else if ([code integerValue] == 101002 || [code integerValue] == 101001) {
                        LKHideBubble();
                        [MBProgressHUD showMessage:@"账号或密码错误" ToView:nil RemainTime:1];
                        //                    [MBProgressHUD showAutoMessage:@"账号或密码错误"];
                        //                    LKShowBubbleInfoWithTime([YZBubbleInfo StartBubbleTitle:@"账号或密码错误" BubbleImage:@"YZPromptSubmit"], 1);
                    }
                } else {
                    DLog(@"return failure");
                    LKHideBubble();
                    [MBProgressHUD showAutoMessage:@"登录失败, 请检查您的网络连接"];
                    //                LKShowBubbleInfoWithTime([YZBubbleInfo StartBubbleTitle:@"登录失败, 请检查您的网络连接" BubbleImage:@"YZPromptSubmit"], 1);
                }
            } failure:^(NSError *error) {
                DLog(@"error == %@", error);
                LKHideBubble();
                [MBProgressHUD showAutoMessage:@"登录失败, 请检查您的网络连接"];
                //            LKShowBubbleInfoWithTime([YZBubbleInfo StartBubbleTitle:@"登录失败, 请检查您的网络连接" BubbleImage:@"YZPromptSubmit"], 1);
            }];
            
        } else {
//            LKHideBubble();
            [MBProgressHUD showAutoMessage:@"注册失败"];
            //        LKShowBubbleInfoWithTime([YZBubbleInfo StartBubbleTitle:@"账号或密码错误" BubbleImage:@"YZPromptSubmit"], 1);
        }

        
        
    };
    return YES;
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(nonnull NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(nonnull NSURLAuthenticationChallenge *)challenge {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    }
}

// 定时器中执行的方法
- (void)requestTaskSt {
    
    //1.获得网络监控的管理者
    _manager = [AFNetworkReachabilityManager sharedManager];
    //2.设置网络状态改变后的处理
    [_manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        //当网络状态改变后，会调用这个方法
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:{
                // 未知网络状态
                LKHideBubble();
                [MBProgressHUD showAutoMessage:@"网络未连接"];
                
                [self addBackView];
                
            }
                break;
            case AFNetworkReachabilityStatusNotReachable:
            {
                // 没有网络
                LKHideBubble();
                [MBProgressHUD showAutoMessage:@"网络未连接"];
                [self addBackView];
                
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                //当前为3G/4G网络
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                //当前网络为WIFI环境
                
            }
                break;
            default:
                break;
        }
        
    }];
    //3 开始监测
    [_manager startMonitoring];
    
}

- (void) addBackView {
    self.BackView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.BackView.backgroundColor = YZColor(247, 247, 247);
    
    UIImageView *BackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(87*YZAdapter, 85*YZAdapter, 201*YZAdapter, 137*YZAdapter)];
    BackImageView.image = [UIImage imageNamed:@"YZRquestError"];
    [self.BackView addSubview:BackImageView];
    
    UILabel *BigLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 248*YZAdapter, Screen_W, 20*YZAdapter)];
    BigLabel.text = @"网络连接异常";
    BigLabel.font = FONT(18);
    BigLabel.textColor = MainFont_Color;
    BigLabel.textAlignment = NSTextAlignmentCenter;
    [self.BackView addSubview:BigLabel];
    
    UILabel *XLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 284*YZAdapter, Screen_W, 13)];
    XLabel.font = FONT(12);
    XLabel.textAlignment = NSTextAlignmentCenter;
    XLabel.textColor = TimeFont_Color;
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:@"请您检查网络或点击页面刷新"];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:GreenButton_Color
     
                          range:NSMakeRange(11, 2)];
    
    [AttributedStr addAttribute:NSUnderlineStyleAttributeName
     
                          value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]
     
                          range:NSMakeRange(11, 2)];
    
    XLabel.attributedText = AttributedStr;
    
    
    [self.BackView addSubview:XLabel];
    
    UITapGestureRecognizer *BackGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    BackGesture.numberOfTapsRequired = 1;
    BackGesture.numberOfTouchesRequired = 1;
    [self.BackView addGestureRecognizer:BackGesture];
    
    [self.view addSubview:self.BackView];
}




- (void)handleTapGesture:(UIButton *)sender {
    self.IDRequest = @"刷新";
    
    [self webviewRequest];    
    
    [self.BackView removeFromSuperview];
    
}


- (void)viewWillDisappear:(BOOL)animated {
    //取消注册网络请求拦截
    [NSURLProtocol unregisterClass:[YZRichURLProtocol class]];
}



@end
