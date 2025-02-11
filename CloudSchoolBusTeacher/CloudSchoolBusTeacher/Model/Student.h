//
//  Student.h
//  CloudBusParent
//
//  Created by HELLO  on 15/11/9.
//  Copyright (c) 2015年 BeiJingYinChuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Student : NSObject
@property (nonatomic,copy)NSString * studentid;
@property (nonatomic,copy)NSString * cnname;
@property (nonatomic,copy)NSString * avatar;
@property (nonatomic,copy)NSString * nickname;
@property (nonatomic,copy)NSString * classid;
@property (nonatomic,copy)NSArray  * classids;
@property (nonatomic,copy)NSString * birthday;
@property (nonatomic,copy)NSString * sex;
@property (nonatomic,copy)NSString * pictureid;

@property (nonatomic,copy)NSString * relaton;
-(instancetype)initWithDic:(NSDictionary *)dic;
@end
