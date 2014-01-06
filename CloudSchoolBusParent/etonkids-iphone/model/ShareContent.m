//
//  ShareContent.m
//  etonkids-iphone
//
//  Created by wpf on 1/21/13.
//  Copyright (c) 2013 wpf. All rights reserved.
//

#import "ShareContent.h"

@implementation ShareContent
@synthesize shareContent,shareId,sharePic,shareTime,shareTitle;
@synthesize isMore;
@synthesize audio;
@synthesize sharePicArr;
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
    
    [super dealloc];
}
@end
