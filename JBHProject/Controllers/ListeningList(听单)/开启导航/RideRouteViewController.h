//
//  RideRouteViewController.h
//  JBHProject
//
//  Created by 李俊恒 on 2017/4/20.
//  Copyright © 2017年 聚宝汇. All rights reserved.
//

#import "BaseViewController.h"

@interface RideRouteViewController : BaseViewController
@property (nonatomic, strong) AMapNaviPoint *startPoint;
@property (nonatomic, strong) AMapNaviPoint *endPoint;
@property(nonatomic,strong)AMapNaviRideManager * rideManager;
@end
