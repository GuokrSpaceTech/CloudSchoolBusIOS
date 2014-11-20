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
@property (nonatomic,retain) NSString *absence;

/**
 *	学生头像
 */
@property (nonatomic,retain) NSString *avatar;

/**
 *	学生年龄
 */
@property (nonatomic,retain) NSNumber *age;


/**
 *	学号
 */
@property (nonatomic,retain) NSNumber *stunumber;


/**
 *	学生生日
 */
@property (nonatomic,retain) NSString *birthday;

/**
 *	学生中文名
 */
@property (nonatomic,retain) NSString *cnname;

/**
 *	学生英文名
 */
@property (nonatomic,retain) NSString *enname;

@property (nonatomic,retain) NSNumber *filesize;
/**
 *	是否缺勤
 */
@property (nonatomic,retain) NSNumber *isabsence;

/**
 *	是否在校
 */
@property (nonatomic,retain) NSNumber *isattendance;

/**
 *	是否锁定
 */
@property (nonatomic,retain) NSNumber *islock;

/**
 *	学生家长电话
 */
@property (nonatomic,retain) NSNumber *mobile;


/**
 *	学生性别
 */
@property (nonatomic,retain) NSNumber *sex;

/**
 *	学生id
 */
@property (nonatomic,retain) NSNumber *studentid;

@property (nonatomic,retain) NSNumber *studentno;


@property (nonatomic,retain)NSNumber *isinstalled;

/**
 *	是否在线
 */
@property (nonatomic,retain)NSNumber *online;
@property (nonatomic,retain)NSNumber *uid;

@property (nonatomic,retain)NSString *orderendtime;
@property (nonatomic,retain)NSNumber *parentid;
@property (nonatomic,retain)NSString *username;

/**
 *	学生健康状态
 */
@property (nonatomic,retain) NSString *healthstate;


/**
 *	学费到期日
 */
@property (nonatomic,retain) NSString *xuefeuTime;



@property (nonatomic,retain) NSString *parentAlert;;
@property (nonatomic,retain) NSString *inSchoolHealth;

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
