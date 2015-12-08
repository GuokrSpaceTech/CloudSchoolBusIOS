//
//  Sender.h
//  CloudBusParent
//
//  Created by HELLO  on 15/11/11.
//  Copyright (c) 2015年 BeiJingYinChuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Sender : NSObject
@property (nonatomic,copy) NSString * senderid;
@property (nonatomic,copy) NSString * classname;
@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy) NSString * role;
@property (nonatomic,copy) NSString * avatar;
-(instancetype)initWithDic:(NSDictionary *)dic;
@end
