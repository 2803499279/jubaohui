//
//  LeftBarModel.m
//  JBHProject
//
//  Created by 李俊恒 on 2016/11/3.
//  Copyright © 2017年 sinze. All rights reserved.
//

#import "LeftBarModel.h"
/**
 *  fileName
 *  模块名称：我的模块数据模型
 *  作者：李俊恒
 *  版本：V:1.0
 *  创建日期：2017/04/10
 *  备注：
 *  修改日期：
 *  修改人：
 *  修改内容
 *  Sequence    Date    Author  Version     Description(why & what)
 *   编号        日期     作者    版本号         修改原因及内容描述
 *
 */

@implementation LeftBarModel
+ (instancetype)leftBarModelWith:(NSString *)iconImageNameStr
                   myLabelTitle:(NSString *)myLabelTitle
{
    return [[self alloc]initWithIconImagenamed:iconImageNameStr
                                  myLabelTitle:myLabelTitle
            ];
}
- (id)initWithIconImagenamed:(NSString *)iconImageNameStr
                myLabelTitle:(NSString *)myLabelTitle
{
    if (self = [super init]) {
//        _iconImageNameStr = iconImageNameStr;
        _myLabelTitle = myLabelTitle;
    }
    return self;
}

@end
