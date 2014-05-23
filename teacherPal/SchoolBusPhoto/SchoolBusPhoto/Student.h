//
//  Student.h
//  SchoolBusParents
//
//  Created by wen peifang on 13-7-24.
//  Copyright (c) 2013年 wen peifang. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *	存放学生基本信息
 */
@interface Student : NSObject

/**
 *	学生缺勤原因
 */
@property (nonatomic,copy) NSString *absence;

/**
 *	学生头像
 */
@property (nonatomic,copy) NSString *avatar;

/**
 *	学生年龄
 */
@property (nonatomic,copy) NSNumber *age;


/**
 *	学号
 */
@property (nonatomic,copy) NSNumber *stunumber;


/**
 *	学生生日
 */
@property (nonatomic,copy) NSString *birthday;

/**
 *	学生中文名
 */
@property (nonatomic,copy) NSString *cnname;

/**
 *	学生英文名
 */
@property (nonatomic,copy) NSString *enname;

@property (nonatomic,copy) NSNumber *filesize;
/**
 *	是否缺勤
 */
@property (nonatomic,copy) NSNumber *isabsence;

/**
 *	是否在校
 */
@property (nonatomic,copy) NSNumber *isattendance;

/**
 *	是否锁定
 */
@property (nonatomic,copy) NSNumber *islock;

/**
 *	学生家长电话
 */
@property (nonatomic,copy) NSNumber *mobile;


/**
 *	学生性别
 */
@property (nonatomic,copy) NSNumber *sex;

/**
 *	学生id
 */
@property (nonatomic,copy) NSNumber *studentid;

@property (nonatomic,copy) NSNumber *studentno;


@property (nonatomic,copy)NSNumber *isinstalled;

/**
 *	是否在线
 */
@property (nonatomic,copy)NSNumber *online;
@property (nonatomic,copy)NSNumber *uid;

@property (nonatomic,copy)NSString *orderendtime;
@property (nonatomic,copy)NSNumber *parentid;
@property (nonatomic,copy)NSString *username;

//
//isinstalled = 1;
//islock = 0;
////
//isabsence = 0;
//isattendance = 0;
//islock = 0;
//mobile = 15001065932;
//sex = 1;
//studentid = 39482;
//studentno = 2013004;


@end
