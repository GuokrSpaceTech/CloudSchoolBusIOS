//
//  ETEvents.m
//  etonkids-iphone
//
//  Created by wen peifang on 13-7-11.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "ETEvents.h"

@implementation ETEvents
@synthesize addtime,
            end_time,
            events_id,
            sign_up_end_time,
            sign_up_start_time,
            start_time,
            title,
            num,peopleArr,
            SignupStatus,
            htmlurl;



-(void)dealloc
{
    
    self.addtime=nil;
    self.end_time=nil;
    self.events_id=nil;
    self.SignupStatus=nil;
    self.sign_up_end_time=nil;
    self.sign_up_start_time=nil;
    self.start_time=nil;
    self.title=nil;
    self.num=nil;
    self.peopleArr=nil;
    self.htmlurl=nil;
    [super dealloc];
}
@end
