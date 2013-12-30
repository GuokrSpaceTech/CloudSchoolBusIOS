//
//  ClassInfo.h
//  SchoolBusParents
//
//  Created by wen peifang on 13-7-24.
//  Copyright (c) 2013年 wen peifang. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *	存放班级信息
 */
@interface ClassInfo : NSObject

/**
 *	学校地址
 */
@property (nonatomic,copy) NSString *address;

/**
 *	城市
 */
@property (nonatomic,copy) NSString *city;

/**
 *	班级id
 */
@property (nonatomic,copy) NSNumber *classid;

/**
 *	班级名称
 */
@property (nonatomic,copy) NSString *classname;

/**
 *	手机号码
 */
@property (nonatomic,copy) NSString *phone;

/**
 *	省份
 */
@property (nonatomic,copy) NSString *province;

/**
 *	学校名称
 */
@property (nonatomic,copy) NSString *schoolname;
@property (nonatomic,retain)   NSString * uid ;
@end
