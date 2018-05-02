//
//  YZHomePageOneModel.h
//  JBHProject
//
//  Created by zyz on 2017/8/23.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "YZBaseModel.h"

@interface YZHomePageOneModel : YZBaseModel

@property (nonatomic, copy) NSString *task_count; // 已完成派单
@property (nonatomic, copy) NSString *task_allreward; // 本月收入
@property (nonatomic, copy) NSString *task_rate; // 好评率
@property (nonatomic, copy) NSString *service_tel; // 客服电话

@end