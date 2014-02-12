//
//  ETCoreDataManager.h
//  etonkids-iphone
//
//  Created by CaiJingPeng on 13-9-12.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserLogin.h"
#import "AppDelegate.h"
#import "ETUser.h"
#import "ETClassShare.h"
#import "ETActicalPicture.h"
#import "ETNotice.h"
#import "ETActivity.h"
#import "ETAttendance.h"
#import "ETCalendar.h"
#import "ETSchedule.h"
#import "ETFood.h"
#import "ShareContent.h"
#import "ETNoStartActivity.h"
#import "MyActivity.h"
#import "ETEvents.h"
#import "ETImportantNotice.h"

@interface ETCoreDataManager : NSObject


/// 将用户数据保存到数据库.
+ (void)saveUser;

/// 将数据库中的数据读取到内存中.
+ (UserLogin*)cachedUser:(NSString*)userName withPass:(NSString*)password andStudent:(NSString *)stuid;
+ (ETUser *)getUserInfo:(NSString *)account andStudent:(NSString *)stuid;
+ (NSArray *)getUsers:(NSString *)userName;
+ (BOOL)saveUserChildren:(NSArray *)children;
+ (BOOL)saveUserChildren:(NSArray *)children ByAccount:(NSString *)username;


+ (BOOL)removeAllArticalData;
+ (BOOL)addArticalData:(NSArray *)infoArray;
+ (NSArray *)searchAllArticals;
+ (BOOL)updateArticalData:(ShareContent *)share ById:(NSString *)articalId;
+ (BOOL)removeArticalDataById:(NSString *)articalId;
+ (BOOL)addSingleArticalData:(ShareContent *)share;


+ (NSArray *)searchAllNotices;
+ (BOOL)removeAllNotices;
+ (BOOL)addNoticeData:(NSArray *)noticeArray;
+ (BOOL)updateNoticeData:(NSString *)isconfirm ById:(NSString *)noticeid;

+ (NSArray *)searchImportantNotices;
+ (BOOL)removeAllImportantNotices;
+ (BOOL)addImportantNoticeData:(NSArray *)noticeArray;
+ (BOOL)updateImportantNoticeData:(NSString *)isconfirm ById:(NSString *)noticeid;



+ (NSArray *)searchAllActivity;
+ (BOOL)removeAllActivity;
+ (BOOL)addActivityData:(NSArray *)activityArray;
+ (BOOL)removeActivity:(ETEvents *)active;
+ (BOOL)updateActivity:(ETEvents *)active;

+ (NSArray *)searchAllMyActivity;
+ (BOOL)removeAllMyActivity;
+ (BOOL)removeMyActivity:(ETEvents *)active;
+ (BOOL)addMyActivityData:(NSArray *)activityArray;

+ (NSArray *)searchAllNoStartActivity;
+ (BOOL)removeAllNoStartActivity;
+ (BOOL)removeNoStartActivity:(ETEvents *)active;
+ (BOOL)addNoStartActivityData:(NSArray *)activityArray;
+ (BOOL)updateNoStartActivity:(ETEvents *)active;


+ (NSArray *)searchAttendanceByMonth:(NSString *)month;
+ (BOOL)removeAttendanceByMonth:(NSString *)month;
+ (BOOL)addAttendance:(NSArray *)attArr withMonth:(NSString *)month;


+ (NSArray *)searchCalendarByMonth:(NSString *)month;
+ (BOOL)removeCalendarByMonth:(NSString *)month;
+ (BOOL)addCalendar:(NSArray *)calArr withMonth:(NSString *)month;
+ (BOOL)removeAllCalendar;


+ (NSArray *)searchScheduleByDate:(NSString *)date;
+ (BOOL)removeAllSchedule;
+ (BOOL)removeScheduleByDate:(NSString *)date;
+ (BOOL)addSchedule:(NSArray *)schArr withDate:(NSString *)date;


+ (NSArray *)searchFoodByDate:(NSString *)date;
+ (BOOL)removeAllFood;
+ (BOOL)removeFoodByDate:(NSString *)date;
+ (BOOL)addFood:(NSArray *)foodArr;

@end
