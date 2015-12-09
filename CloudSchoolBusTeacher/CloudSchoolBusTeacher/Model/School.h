//
//  School.h
//  CloudBusParent
//
//  Created by HELLO  on 15/11/9.
//  Copyright (c) 2015年 BeiJingYinChuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface School : NSObject
@property (nonatomic,copy) NSString * remark;
@property (nonatomic,copy) NSString * address;
@property (nonatomic,copy) NSString * groupid;
@property (nonatomic,copy) NSString * id;
@property (nonatomic,strong) NSMutableArray * tags;
@property (nonatomic,copy) NSString * cover;
@property (nonatomic,strong) NSMutableArray * messageTypeArr;
@property (nonatomic,strong) NSMutableArray * classModuleArr;
@property (nonatomic,strong) NSMutableArray * classArr;
@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy) NSString *logo;
-(instancetype)initWithSchoolDic:(NSDictionary *)schooldic;
@end
