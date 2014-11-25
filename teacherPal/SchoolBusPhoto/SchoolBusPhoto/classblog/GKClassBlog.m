//
//  GKClassBlog.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-11-22.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import "GKClassBlog.h"

@implementation GKClassBlog
@synthesize shareContent,shareId,sharePic,shareTime,shareTitle;
@synthesize isMore;
@synthesize audio;
@synthesize sharePicArr;
@synthesize tagArr;
@synthesize upnum,havezan,commentnum,publishtime,shareKey;
-(void)dealloc
{
    self.audio=nil;
    self.shareId=nil;
    self.sharePic=nil;
    self.shareContent=nil;
    self.shareTitle=nil;
    self.shareTime=nil;
    self.sharePicArr = nil;
    self.shareidArr=nil;
    self.upnum=nil;
    self.havezan=nil;
    self.commentnum=nil;
    self.publishtime = nil;
    self.shareKey = nil;
    self.tagArr=nil;
    [super dealloc];
}
@end
