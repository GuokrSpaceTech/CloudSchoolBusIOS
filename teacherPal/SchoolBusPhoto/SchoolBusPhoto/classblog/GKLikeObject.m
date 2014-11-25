//
//  GKLikeObject.m
//  SchoolBusPhoto
//
//  Created by wen peifang on 14-11-25.
//  Copyright (c) 2014年 mactop. All rights reserved.
//

#import "GKLikeObject.h"

@implementation GKLikeObject
@synthesize actionid,adduserid,addtime,avatar,isstudent,nickname;


-(void)dealloc
{
    self.actionid=nil;
    self.addtime=nil;
    self.adduserid=nil;
    self.avatar=nil;
    self.isstudent=nil;
    self.nickname=nil;
    [super dealloc];
}
@end
