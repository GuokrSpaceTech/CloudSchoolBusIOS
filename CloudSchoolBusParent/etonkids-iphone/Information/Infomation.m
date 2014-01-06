//
//  Infomation.m
//  etonkids-iphone
//
//  Created by wen peifang on 13-7-11.
//  Copyright (c) 2013年 wpf. All rights reserved.
//

#import "Infomation.h"

@implementation Infomation
@synthesize content,
            infoId,
            linkage,
            publishTime,
            thumbnail,
            isCollect,
            isCollected,
htmlurl,
title;

-(void)dealloc
{
    self.content=nil;
    self.infoId=nil;
    self.linkage=nil;
    self.publishTime=nil;
    self.thumbnail=nil;
    self.htmlurl=nil;
    [super dealloc];
}
@end
