//
//  Teacher.h
//  CloudBusParent
//
//  Created by HELLO  on 15/11/9.
//  Copyright (c) 2015年 BeiJingYinChuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Teacher : NSObject
@property (nonatomic,copy)NSString * avatar;
@property (nonatomic,copy)NSString * duty;
@property (nonatomic,copy)NSString *teacherid;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString * className;
-(instancetype)initWithDic:(NSDictionary *)dic;
@end
