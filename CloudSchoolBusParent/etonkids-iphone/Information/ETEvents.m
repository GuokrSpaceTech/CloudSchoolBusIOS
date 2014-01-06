//
//  ETEvents.m
//  etonkids-iphone
//
//  Created by wen peifang on 13-7-11.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "ETEvents.h"

@implementation ETEvents
@synthesize address,
            addtime,
            content,
            end_time,
            events_id,
            isonline,
            picUrl,
            shool_id,
            sign_up,
            sign_up_end_time,
            sign_up_start_time,
            start_time,
            title,
            isMyActive,
            isSignup,
            SignupStatus,
            htmlurl;



-(void)dealloc
{
    self.address=nil;
    self.addtime=nil;
    self.content=nil;
    self.end_time=nil;
    self.events_id=nil;
    self.isonline=nil;
    self.SignupStatus=nil;
    self.picUrl=nil;
    self.shool_id=nil;
    self.sign_up=nil;
    self.sign_up_end_time=nil;
    self.sign_up_start_time=nil;
    self.start_time=nil;
    self.title=nil;
    self.htmlurl=nil;

    [super dealloc];
}
@end
