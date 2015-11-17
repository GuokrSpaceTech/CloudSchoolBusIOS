//
//  ClassObj.h
//  CloudBusParent
//
//  Created by HELLO  on 15/11/9.
//  Copyright (c) 2015年 BeiJingYinChuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassObj : NSObject
@property (nonatomic,copy)NSString *classid;
@property (nonatomic,copy) NSString * className;
@property (nonatomic,strong)NSArray * studentidArr;
@property (nonatomic,strong)NSMutableArray *teacherArr;
-(instancetype)initWithClassDic:(NSDictionary *)dic;
@end
