//
//  GKUserLogin.h
//  SchoolBusParents
//
//  Created by CaiJingPeng on 13-7-24.
//  Copyright (c) 2013年 wen peifang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClassInfo.h"
#import "GKTeacher.h"
typedef enum {LOGINSERVER,LOGINOFF} LoginState;

/**
 *	单例模式  存储用户登录后的信息
 *  包括 登录状态，用户名密码  及sid
 */
@interface GKUserLogin : NSObject

{
    LoginState loginState;
    
    NSString * userName;
    NSString * passWord;
    NSString *sid;
    
}
@property (nonatomic,copy) NSString * _userName;
@property (nonatomic,copy) NSString * _passWord;
@property (nonatomic) LoginState _loginState;
@property (nonatomic,copy) NSString *_sid;

@property (nonatomic,retain) ClassInfo *classInfo;
@property (nonatomic,retain)GKTeacher *teacher;
@property (nonatomic,retain)NSMutableArray *studentArr;
@property (nonatomic,retain)NSString *upIP;

@property (nonatomic,retain) NSString * credit;
@property (nonatomic,retain) NSString * credit_orders;
@property (nonatomic,retain) NSString * credit_last;

@property (nonatomic,retain) NSString * vipCredit;
@property (nonatomic,retain) NSString * photoCredit;
@property (nonatomic,retain) NSString * predCredit;
@property (nonatomic, retain) NSArray *photoTagArray;


@property (nonatomic,retain)NSNumber *badgeNumber;
+(GKUserLogin *)currentLogin;
-(void)clearSID;
+ (void)clearLastLogin;
- (BOOL)getLastLogin;
- (void)updateLastLogin;
+(void)clearpassword;
@end
