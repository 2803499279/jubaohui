//
//  YZNetRequestUrl.h
//  JBHProject
//
//  Created by zyz on 2017/4/19.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#ifndef YZNetRequestUrl_h
#define YZNetRequestUrl_h

/** 聚保汇*/
//#define ZIP @"https://api-nat.juins.com/v1" // 保险1站项目内网地址
//#define ZWIP @"https://api-nat.juins.com" // 保险1站项目H5内网地址
//#define YZIP @"api-nat.juins.com" // DNS解析使用

//#define ZIP @"https://api.juins.com/v1" // 保险1站项目内网地址
//#define ZWIP @"https://api.juins.com" // 保险1站项目H5内网地址
//#define YZIP @"api.juins.com" // DNS解析使用


// 迅赔
//#define ZIP @"http://192.168.10.176/v1" // 保险1站项目内网地址
//#define ZWIP @"http://192.168.10.176" // 保险1站项目H5内网地址
//#define YZIP @"192.168.10.176" // DNS解析使用

#define ZIP @"https://api.xunpei.net/v1" // 保险1站项目内网地址
#define ZWIP @"https://api.xunpei.net" // 保险1站项目H5内网地址
#define YZIP @"api.xunpei.net" // DNS解析使用


/**********************接口定义************************/
/** 登录 **/
#define USER_LOGIN_URL [NSString stringWithFormat:@"%@/user/login", ZIP]
/** 初始信息 **/
#define USER_START_URL [NSString stringWithFormat:@"%@/user/start", ZIP]
/** 进行中的任务[201] **/
#define TASK_INPROCESS_URL [NSString stringWithFormat:@"%@/task/inProcess", ZIP]
/** 照片上传[202] **/
#define TASK_UPLOAD_URL [NSString stringWithFormat:@"%@/task/upload", ZIP]
/** 照片识别信息[203] **/
#define TASK_PICTOINFO_URL [NSString stringWithFormat:@"%@/task/picToInfo", ZIP]
/** 提交审核[204] **/
#define TASK_SUBMIT_URL [NSString stringWithFormat:@"%@/task/submit", ZIP]
/** 查询审核状态[205] **/
#define TASK_STATUS_URL [NSString stringWithFormat:@"%@/task/status", ZIP]
/** 更新当前位置[206] **/
#define LOCATION_RENEW_URL [NSString stringWithFormat:@"%@/location/renew", ZIP]
/** 抢单[207] **/
#define TASK_GRAB_URL [NSString stringWithFormat:@"%@/task/grab", ZIP]
/** 已完成的派单[102] **/
#define TASK_FINISHED_URL [NSString stringWithFormat:@"%@/task/finished", ZIP]

/** 钱包信息[211] wallet/info **/
#define WALLET_INFO [NSString stringWithFormat:@"%@/wallet/info", ZIP]
/** 钱包记录[212] wallet/log **/
#define WALLET_LOG [NSString stringWithFormat:@"%@/wallet/log", ZIP]
/** 实名认证[105] user/realnameVerify **/
#define USER_REALNAMEVERIFY [NSString stringWithFormat:@"%@/user/realnameVerify", ZIP]

/** 钱包提现[215] wallet/extract **/
#define WALLET_EXTRACT [NSString stringWithFormat:@"%@/wallet/extract", ZIP]
/** 添加银行卡[213] wallet/addCard **/
#define WALLET_ADDCARD [NSString stringWithFormat:@"%@/wallet/addCard", ZIP]
/** 删除银行卡[214] wallet/delCard **/
#define WALLET_DELCARD [NSString stringWithFormat:@"%@/wallet/delCard", ZIP]
/** 银行卡列表[216] wallet/cardList **/
#define WALLET_CARDLIST [NSString stringWithFormat:@"%@/wallet/cardList", ZIP]

/** 修改新密码 114 user/newpassword **/
#define USER_NEWPASSWORD [NSString stringWithFormat:@"%@/user/newpassword", ZIP]
/** 拉取新消息通知 209 msg/notice **/
#define MSG_NOTICE [NSString stringWithFormat:@"%@/msg/notice", ZIP]


/** 注册 /register/agreement **/
#define REGISTER [NSString stringWithFormat:@"%@/register", ZWIP]
/** 忘记密码 /register/agreement **/
#define FORGETPASSWORD [NSString stringWithFormat:@"%@/forgetpassword", ZWIP]
/** 登录协议 /register/agreement **/
#define REGISTER_AGREEMENT [NSString stringWithFormat:@"%@/register/agreement", ZWIP]
/** 用户指南 /help **/
#define HELP [NSString stringWithFormat:@"%@/help", ZWIP]
/** 速堪课堂 /article/ **/
#define ARTICLE [NSString stringWithFormat:@"%@/article/", ZWIP]

/**  上传头像 106 user/face **/
#define USER_FACE [NSString stringWithFormat:@"%@/user/face", ZIP]

/**  新的首页的接口106 user/face **/
#define Main_Start [NSString stringWithFormat:@"%@/main/start", ZIP]

/**  甩单理由 218 task/cause **/
#define Task_Cause [NSString stringWithFormat:@"%@/task/cause", ZIP]

/**  甩单理由 219 task/cancel **/
#define Task_Cancel [NSString stringWithFormat:@"%@/task/cancel", ZIP]


/**********************迅赔接口定义************************/

/**  首页文章类型  article/type **/
#define SY_ARTICLE_TYPE [NSString stringWithFormat:@"%@/article/type", ZIP]
/**  首页文章列表  article/lists **/
#define SY_ARTICLE_LISTS [NSString stringWithFormat:@"%@/article/lists", ZIP]
/**  正在处理的订单  task/unsolved **/
#define TD_CXKC_TASK_UNSOLVED [NSString stringWithFormat:@"%@/task/unsolved", ZIP]












#endif /* YZNetRequestUrl_h */
