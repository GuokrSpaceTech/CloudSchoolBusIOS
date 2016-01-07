//
//  ClassObj.h
//  CloudBusParent
//
//  Created by HELLO  on 15/11/9.
//  Copyright (c) 2015年 BeiJingYinChuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassObj : NSObject
@property (nonatomic,strong) NSString * classid;
@property (nonatomic,strong) NSString * schoolid;
@property (nonatomic,strong) NSString * className;
@property (nonatomic,strong) NSString * dutyid;
@property (nonatomic,strong) NSString * remark;
@property (nonatomic,strong)NSArray * studentidArr;
@property (nonatomic,strong)NSMutableArray *teacherArr;
-(instancetype)initWithClassDic:(NSDictionary *)dic;
@end
