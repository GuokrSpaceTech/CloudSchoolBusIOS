//
//  Message.h
//  CloudBusParent
//
//  Created by HELLO  on 15/11/11.
//  Copyright (c) 2015年 BeiJingYinChuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sender.h"
@interface Message : NSObject
@property (nonatomic,copy) NSString * desc;
@property (nonatomic,copy) NSString * messageid;
@property (nonatomic,copy) NSString * apptype;
@property (nonatomic,copy) NSString * ismass;
@property (nonatomic,copy) NSString * body;
@property (nonatomic,copy) NSString * sendtime;
@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * tag;
@property (nonatomic,copy) NSString * isconfirm;
@property (nonatomic,copy) NSString * isreaded;
@property (nonatomic,strong) Sender * sender;
@property (nonatomic,copy) NSString * studentid;
-(instancetype)initWithDic:(NSDictionary *)dic;
-(id)bodyObject;
@end
