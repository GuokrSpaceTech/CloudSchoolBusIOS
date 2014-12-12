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

    NSString *addtime;
    
    NSString *end_time;
    NSString *events_id;


    NSString *sign_up_end_time;
    NSString *sign_up_start_time;
    NSString *start_time;
    NSString *title;
    NSString *htmlurl;

    
    NSString *SignupStatus;
    
}

@property (nonatomic ,retain) NSString *SignupStatus;
@property (nonatomic , retain) NSString * addtime;
@property (nonatomic , retain) NSString * end_time;
@property (nonatomic , retain) NSString * events_id;
@property (nonatomic , retain) NSString * sign_up_end_time;
@property (nonatomic , retain) NSString * sign_up_start_time;
@property (nonatomic , retain) NSString * start_time;
@property (nonatomic , retain) NSString * title;
@property (nonatomic,retain)NSString *num;
@property (nonatomic,retain)NSArray *peopleArr;
@property(nonatomic,retain)NSString  *htmlurl;


@end
