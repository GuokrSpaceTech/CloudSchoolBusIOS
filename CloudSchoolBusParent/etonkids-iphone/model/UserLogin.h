//
//  UserLogin.h
//  etonkids-iphone
//
//  Created by wpf on 1/28/13.
//  Copyright (c) 2013 wpf. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kMHKeychainServiceName    @"my_school_last_login"
#define kMHKeychainAccount        @"my_school_account"
#define kMHKeychainPassword       @"my_school_password"
#define kMHKeychainAccountType    @"my_school_account_type"
#define kMHKeychainStudent        @"my_school_student"
#define kMHKeychainClass          @"my_school_class"


typedef enum {LOGIN_SERVER,LOGIN_OFF} LoginStatus;

@interface UserLogin : NSObject
{
    
    LoginStatus loginStatus;
}

@property(nonatomic,assign)LoginStatus loginStatus;
@property (nonatomic,assign)BOOL isStudentInterface;
@property (nonatomic,assign)BOOL isClassInfonterface;
@property (nonatomic,assign)BOOL isSettingInterface;

@property (nonatomic,retain)NSString *schooldID;
@property(nonatomic,retain)NSString *age;
@property(nonatomic,retain)NSString *birthday;
@property(nonatomic,retain)NSString *cnname;
@property(nonatomic,retain)NSString *enname;
@property(nonatomic,retain)NSString *mobile;
@property(nonatomic,retain)NSString *nickname;
@property(nonatomic,retain)NSString *parent;
@property(nonatomic,retain)NSString *sex;
@property(nonatomic,retain)NSString *inClass;
@property(nonatomic,retain)NSString *duty;
@property(nonatomic,retain)NSString *passWord;
@property(nonatomic,retain)NSString *regName;
@property(nonatomic,retain)NSString *className;
@property(nonatomic,retain)NSString *avatar;
@property(nonatomic,retain)NSDictionary * attendancetype;
@property(nonatomic, retain)NSString *studentId;
@property(nonatomic, retain)NSString *allowmutionline;
@property(nonatomic, retain)NSString *pid;
@property(nonatomic, retain)NSString *uid_class;
@property (nonatomic, retain)NSString *uid_student;
@property (nonatomic, retain)NSString *ischeck_mobile;
@property (nonatomic, retain)NSString *skinid;
@property (nonatomic, retain)NSString *username;
@property (nonatomic, retain)NSString *can_comment; //是否可以评论
@property (nonatomic, retain)NSString *can_comment_action;  //是否可以赞
@property (nonatomic, retain)NSString *orderTitle;
@property (nonatomic, retain)NSString *orderEndTime;
@property (nonatomic,retain)NSString *inactive;
@property (nonatomic,retain)NSString *healtState;
@property(nonatomic,retain)NSString *tuition_time;
@property(nonatomic,retain)NSString *chunyuisopen;
@property(nonatomic,retain)NSString *chunyuendtime;
@property(nonatomic,retain)NSString *ddns;
@property(nonatomic,retain)NSString * port;
@property(nonatomic,retain)NSString * camera_name;
@property(nonatomic,retain)NSString   *schoolname;




+(UserLogin *)currentLogin;
+ (void)clearLastLogin;
- (BOOL)getLastLogin;
- (void)updateLastLogin;
+ (void)clearLastPassword;
+ (void)releaseCurrentUser;


@end
