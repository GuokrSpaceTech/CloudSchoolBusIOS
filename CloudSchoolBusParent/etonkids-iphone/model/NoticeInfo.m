//
//  NoticeInfo.m
//  etonkids-iphone
//
//  Created by wpf on 1/22/13.
//  Copyright (c) 2013 wpf. All rights reserved.
//

#import "NoticeInfo.h"

@implementation NoticeInfo
@synthesize noticeTitle,noticeContent,noticeTime,noticeId,pictures,addtime;
@synthesize isMore;

@synthesize shortContent;
@synthesize noticekey,isconfirm,haveisconfirm;
-(void)dealloc
{
    self.noticeId = nil;
    self.noticeContent=nil;
    self.noticeTime=nil;
    self.noticeTitle=nil;
    self.shortContent=nil;
    self.noticekey=nil;
    self.isconfirm=nil;
    self.haveisconfirm=nil;
    self.pictures = nil;
    self.addtime = nil;
    [super dealloc];
}
@end
