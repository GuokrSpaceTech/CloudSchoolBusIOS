//
//  School.h
//  CloudBusParent
//
//  Created by HELLO  on 15/11/9.
//  Copyright (c) 2015年 BeiJingYinChuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface School : NSObject
@property (nonatomic,copy) NSString * address;
@property (nonatomic,copy) NSString * schoolid;
@property (nonatomic,strong) NSMutableArray * classesArr;
@property (nonatomic,copy) NSString * schoolName;
@property (nonatomic,copy) NSString * cover;
@property (nonatomic,strong) NSMutableArray * tagsArr;
@property (nonatomic,copy)NSString *logo;
-(instancetype)initWithSchoolDic:(NSDictionary *)schooldic;
@end
