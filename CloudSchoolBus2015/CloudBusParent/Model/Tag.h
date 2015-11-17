//
//  Tag.h
//  CloudBusParent
//
//  Created by wenpeifang on 15/11/9.
//  Copyright (c) 2015年 BeiJingYinChuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tag : NSObject
@property (nonatomic,copy)NSString * tagid;
@property (nonatomic,copy)NSString * schoolid;
@property (nonatomic,copy)NSString * tagnamedesc_en;
@property (nonatomic,copy)NSString * isdelete;
@property (nonatomic,copy)NSString *tagname_en;
@property (nonatomic,copy)NSString *tagnamedesc;
@property (nonatomic,copy)NSString * tagname;

-(instancetype)initWithDic:(NSDictionary *)dic;
@end
