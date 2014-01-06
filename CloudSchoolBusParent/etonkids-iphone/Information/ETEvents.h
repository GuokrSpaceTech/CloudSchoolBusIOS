//
//  ETEvents.h
//  etonkids-iphone
//
//  Created by wen peifang on 13-7-11.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

/**
 *	@file   ETEvents
 *  @brief  活动类
 *  @author
 *  @version 2.2
 *  @date   2013-09-03
 */


#import <Foundation/Foundation.h>

@interface ETEvents : NSObject
{
    NSString *address;
    NSString *addtime;
    NSString *content;
    NSString *end_time;
    NSString *events_id;
    NSString *isonline;
//    NSNumber *isover;
    NSString *picUrl;
    NSString *shool_id;
    NSString *sign_up;
    NSString *sign_up_end_time;
    NSString *sign_up_start_time;
    NSString *start_time;
    NSString *title;
    NSString *htmlurl;
    
    NSString *isSignup;
    
    NSString *SignupStatus;
    
    BOOL isMyActive;
}
@property (nonatomic ,retain) NSString *isSignup;
@property (nonatomic ,retain) NSString *SignupStatus;

@property  BOOL isMyActive;

@property (nonatomic , retain) NSString * address;
@property (nonatomic , retain) NSString * addtime;
@property (nonatomic , retain) NSString * content;
@property (nonatomic , retain) NSString * end_time;
@property (nonatomic , retain) NSString * events_id;
@property (nonatomic , retain) NSString * isonline;
@property (nonatomic , retain) NSString * picUrl;
@property (nonatomic , retain) NSString * shool_id;
@property (nonatomic , retain) NSString * sign_up;
@property (nonatomic , retain) NSString * sign_up_end_time;
@property (nonatomic , retain) NSString * sign_up_start_time;
@property (nonatomic , retain) NSString * start_time;
@property (nonatomic , retain) NSString * title;
@property(nonatomic,retain)NSString  *htmlurl;


@end
