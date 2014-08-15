//
//  ETUser.h
//  etonkids-iphone
//
//  Created by wen peifang on 14-8-15.
//  Copyright (c) 2014年 wpf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ETUser : NSManagedObject

@property (nonatomic, retain) NSString * account;
@property (nonatomic, retain) NSString * age;
@property (nonatomic, retain) NSString * allowmutionline;
@property (nonatomic, retain) NSString * avatar;
@property (nonatomic, retain) NSString * birthday;
@property (nonatomic, retain) NSString * can_comment;
@property (nonatomic, retain) NSString * can_comment_action;
@property (nonatomic, retain) NSString * classname;
@property (nonatomic, retain) NSString * cnname;
@property (nonatomic, retain) NSString * enname;
@property (nonatomic, retain) NSString * healthstate;
@property (nonatomic, retain) NSString * inactive;
@property (nonatomic, retain) NSString * ischeck_mobile;
@property (nonatomic, retain) NSString * mobile;
@property (nonatomic, retain) NSString * nikename;
@property (nonatomic, retain) NSString * orderenddate;
@property (nonatomic, retain) NSString * ordertitle;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * pid;
@property (nonatomic, retain) NSString * schoolname;
@property (nonatomic, retain) NSString * sex;
@property (nonatomic, retain) NSString * skinid;
@property (nonatomic, retain) NSString * studentid;
@property (nonatomic, retain) NSString * tuition_time;
@property (nonatomic, retain) NSString * uid_class;
@property (nonatomic, retain) NSString * uid_student;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * chunyuopen;
@property (nonatomic, retain) NSString * chunyuendtime;

@end
