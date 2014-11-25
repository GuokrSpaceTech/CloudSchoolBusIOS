//
//  GKCommentObject.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-11-25.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import "GKCommentObject.h"

@implementation GKCommentObject
@synthesize addtime,adduserid,avatar,commentid,content,isstudent,nickname,replynickname;

-(void)dealloc
{
    self.adduserid=nil;
    self.addtime=nil;
    self.avatar=nil;
    self.commentid=nil;
    self.isstudent=nil;
    self.nickname=nil;
    self.replynickname=nil;
    [super dealloc];
}
@end
